import os
import datetime
import torch
from transformers import BertTokenizer, BertForSequenceClassification, Trainer, TrainingArguments
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from torch.utils.data import Dataset
from sklearn.metrics import accuracy_score, f1_score, classification_report
from tqdm import tqdm
import numpy as np

# Check if GPU is available
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f'Using device: {device}')

# Load and preprocess data
data = pd.read_csv('../data/raw/cefr_data.csv', usecols=['text_corrected', 'cefr'])
data.rename(columns={"text_corrected": "text"}, inplace=True)
unique_labels_to_idx_map = {
        "A1": 0,
        "A2": 1,
        "B1": 2,
        "B2": 3,
        "C1": 4,
        "C2": 5,
        }
idx_to_unique_labels_map = {
        0:"A1",
        1:"A2",
        2:"B1",
        3:"B2",
        4:"C1",
        5:"C2"
        }
data['label'] = [unique_labels_to_idx_map[v] for v in data['cefr']]
unique_labels_idx = [0, 1, 2, 3, 4, 5]

train_texts, val_texts, train_labels, val_labels = train_test_split(
    data['text'].tolist(),
    data['label'].tolist(),
    test_size=0.2,
    shuffle=True,
    random_state=200,
)

# Load tokenizer
tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')

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

# Initialize model
model = BertForSequenceClassification.from_pretrained('bert-base-uncased', num_labels=6).to(device)  # Move model to GPU

# Function to compute metrics
def compute_metrics(p):
    preds = np.argmax(p.predictions, axis=1)
    accuracy = accuracy_score(p.label_ids, preds)
    f1 = f1_score(p.label_ids, preds, average='weighted')
    return {"accuracy": accuracy, "f1": f1}
# Set up training arguments
run_hash = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M") 
output_dir=f'../models/{run_hash}'
print(output_dir)
if not os.path.isdir(output_dir):
    os.makedirs(output_dir)
training_args = TrainingArguments(
    output_dir=output_dir,
    num_train_epochs=10,
    per_device_train_batch_size=8,
    per_device_eval_batch_size=8,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='../logs',
    logging_steps=10,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    save_total_limit=10,
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
trainer.save_model(f'{outputdir}/best_training_bert_cefr_model')

# Function to get predictions and classification report
def evaluate_and_report(dataset, labels, split_name):
    predictions = trainer.predict(dataset)
    print(predictions)
    predicted_labels = np.argmax(predictions.predictions, axis=1)
    print(labels)
    print(predicted_labels)
    report = classification_report(labels, predicted_labels, labels=range(6), digits=2)
    print(f"Classification Report for {split_name} set:\n{report}")
    with open(f'../logs/{split_name}_classification_report.txt', 'w') as f:
        f.write(report)

# Evaluate and report on training set
evaluate_and_report(train_dataset, train_labels, "train")

# Evaluate and report on validation (test) set
evaluate_and_report(val_dataset, val_labels, "test")


