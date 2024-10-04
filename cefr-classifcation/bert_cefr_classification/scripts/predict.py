import json
import collections
import torch
from transformers import BertTokenizer, BertForSequenceClassification, Trainer, TrainingArguments
import pandas as pd
from torch.utils.data import Dataset
from sklearn.metrics import accuracy_score, f1_score, classification_report
import numpy as np

# Check if GPU is available
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f'Using device: {device}')

# Load the new dataset for prediction
dataframe = collections.defaultdict(list) 
with open('../data/raw/celva_texts.json') as inpf:
    json_data = json.load(inpf)
    for instance_id, instance_dict in json_data.items():
        dataframe["text"].append(instance_dict['text'])
        dataframe["cefr"].append(instance_dict['text_metadata']['CECRL'])
        
data = pd.DataFrame(dataframe)
#data = pd.read_csv('../data/raw/celva_text_cefr.csv',usecols=['text', 'cefr'])  # Adjust to the new dataset
# data.rename(columns={"text_corrected": "text"}, inplace=True)

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

# Extract texts and labels for evaluation
eval_texts = data['text'].tolist()
eval_labels = data['label'].tolist()

# Load the tokenizer
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

# Create evaluation dataset
eval_dataset = CEFRDataset(eval_texts, eval_labels)

# Load the last checkpoint model
model = BertForSequenceClassification.from_pretrained('../models/checkpoint-54249/').to(device)  # Adjust the path as needed

# Define compute metrics function
def compute_metrics(p):
    preds = np.argmax(p.predictions, axis=1)
    accuracy = (preds == p.label_ids).mean()
    f1 = f1_score(p.label_ids, preds, average='weighted')
    return {"accuracy": accuracy, "f1": f1}

# Initialize Trainer for prediction
trainer = Trainer(
    model=model,
    eval_dataset=eval_dataset,  # We only need eval_dataset for prediction
    compute_metrics=compute_metrics  # Pass the compute_metrics function
)

# Function to get predictions and classification report
def evaluate_and_report(dataset, labels, split_name):
    predictions = trainer.predict(dataset)
    predicted_labels = np.argmax(predictions.predictions, axis=1)
    report = classification_report(labels, predicted_labels, labels=range(6), digits=2)
    print(f"Classification Report for {split_name} set:\n{report}")
    with open(f'../logs/{split_name}_classification_report.txt', 'w') as f:
        f.write(report)

# Evaluate and report on the new dataset
evaluate_and_report(eval_dataset, eval_labels, "new_data")
