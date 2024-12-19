import torch
from transformers import BertTokenizer, BertForSequenceClassification, RobertaTokenizer, RobertaForSequenceClassification, Trainer, TrainingArguments
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from torch.utils.data import Dataset
from sklearn.metrics import accuracy_score, f1_score, classification_report
from tqdm import tqdm
import numpy as np
import os

# Check if GPU is available
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f'Using device: {device}')

model_name = 'bert-base-uncased'  # Replace with 'roberta-base' or your specific model
if model_name.startswith('bert'):
    tokenizer = BertTokenizer.from_pretrained(model_name)
    model_class = BertForSequenceClassification
elif model_name.startswith('roberta'):
    tokenizer = RobertaTokenizer.from_pretrained(model_name)
    model_class = RobertaForSequenceClassification
else:
    raise ValueError("Unsupported model")

# Check for checkpoint
checkpoint_dir = '../models/checkpoint-36166/'  # Path to the checkpoint directory
if os.path.isdir(checkpoint_dir) and len(os.listdir(checkpoint_dir)) > 0:
    model = model_class.from_pretrained(checkpoint_dir, num_labels=6).to(device)
    print(f"Loaded model from checkpoint: {checkpoint_dir}")
elif checkpoint_dir == "":
    model = model_class.from_pretrained(model_name, num_labels=6).to(device)
    print(f"No checkpoint found, loaded model from {model_name}")
else:
    raise ValueError("Checkpoint not found")
input()

# Load and preprocess data
data = pd.read_csv('../data/raw/cefr_data.csv', usecols=['text_corrected', 'cefr'])
data.rename(columns={"text_corrected": "text"}, inplace=True)

# Define mappings for labels
unique_labels_to_idx_map = {
    "A1": 0,
    "A2": 1,
    "B1": 2,
    "B2": 3,
    "C1": 4,
    "C2": 5,
}
idx_to_unique_labels_map = {
    0: "A1",
    1: "A2",
    2: "B1",
    3: "B2",
    4: "C1",
    5: "C2"
}
data['label'] = [unique_labels_to_idx_map[v] for v in data['cefr']]
unique_labels_idx = [0, 1, 2, 3, 4, 5]

train_texts, val_texts, train_labels, val_labels = train_test_split(
    data['text'].tolist(),
    data['label'].tolist(),
    test_size=0.2
)


# Define custom dataset
class CEFRDataset(Dataset):
    def __init__(self, texts, labels):
        self.encodings = tokenizer(
            texts,
            truncation=True,
            padding='max_length',  # Ensure consistent tensor sizes
            max_length=512,
            return_tensors='pt'
        )
        self.labels = torch.tensor(labels)

    def __getitem__(self, idx):
        item = {key: val[idx] for key, val in self.encodings.items()}
        item['labels'] = self.labels[idx]
        return item

    def __len__(self):
        return len(self.labels)

# Create datasets
train_dataset = CEFRDataset(train_texts, train_labels)
val_dataset = CEFRDataset(val_texts, val_labels)

# Function to compute metrics
def compute_metrics(p):
    preds = np.argmax(p.predictions, axis=1)
    accuracy = accuracy_score(p.label_ids, preds)
    f1 = f1_score(p.label_ids, preds, average='weighted')
    return {"accuracy": accuracy, "f1": f1}

# Set up training arguments
training_args = TrainingArguments(
    output_dir='../models',
    num_train_epochs=3,
    per_device_train_batch_size=32,
    per_device_eval_batch_size=32,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='../logs',
    logging_steps=10,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    save_total_limit=2,
    load_best_model_at_end=True,
    fp16=True if torch.cuda.is_available() else False,  # Enable mixed-precision training if GPU is available
)

# Initialize Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=val_dataset,
    compute_metrics=compute_metrics  # Pass the compute_metrics function
)

# Train the model
print("starting training", "*"*100)
trainer.train()

# Save the model
trainer.save_model('../models/bert_cefr_model')  # Adapt filename as needed

# Function to get predictions and classification report
def evaluate_and_report(dataset, labels, split_name):
    predictions = trainer.predict(dataset)
    predicted_labels = np.argmax(predictions.predictions, axis=1)
    report = classification_report(labels, predicted_labels, labels=unique_labels_idx, target_names=[idx_to_unique_labels_map[i] for i in unique_labels_idx], digits=2)
    print(f"Classification Report for {split_name} set:\n{report}")
    with open(f'../logs/{split_name}_classification_report.txt', 'w') as f:
        f.write(report)

# Evaluate and report on training set
evaluate_and_report(train_dataset, train_labels, "train")

# Evaluate and report on validation (test) set
evaluate_and_report(val_dataset, val_labels, "test")
