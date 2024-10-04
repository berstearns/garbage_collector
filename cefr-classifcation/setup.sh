#!/bin/bash

# Project root directory
PROJECT_NAME="bert_cefr_classification"
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Create folders for data, models, and scripts
mkdir -p data/raw
mkdir -p data/processed
mkdir -p models
mkdir -p scripts
mkdir -p notebooks
mkdir -p logs

# Create a requirements.txt file with necessary Python packages
cat <<EOL > requirements.txt
transformers
torch
scikit-learn
pandas
numpy
EOL

# Create a basic README.md
cat <<EOL > README.md
# BERT CEFR Classification

This project fine-tunes BERT to classify learner input text into CEFR levels: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].

## Project Structure
- **data/**: Contains raw and processed data.
- **models/**: Stores trained models.
- **scripts/**: Python scripts for data processing, training, and evaluation.
- **notebooks/**: Jupyter notebooks for exploration and model evaluation.
- **logs/**: Logs for training and evaluation.

## Requirements
Install the required Python packages:

\`\`\`bash
pip install -r requirements.txt
\`\`\`

## Usage
1. Place raw data in \`data/raw\`.
2. Run the training script in the \`scripts/\` directory.
EOL

# Create a basic training script
cat <<EOL > scripts/train.py
import torch
from transformers import BertTokenizer, BertForSequenceClassification, Trainer, TrainingArguments
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import numpy as np

# Load and preprocess data
data = pd.read_csv('../data/raw/cefr_data.csv')
le = LabelEncoder()
data['label'] = le.fit_transform(data['cefr_level'])

train_texts, val_texts, train_labels, val_labels = train_test_split(
    data['text'].tolist(), 
    data['label'].tolist(), 
    test_size=0.2
)

# Load tokenizer and model
tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
train_encodings = tokenizer(train_texts, truncation=True, padding=True, max_length=128)
val_encodings = tokenizer(val_texts, truncation=True, padding=True, max_length=128)

# Convert to torch tensors
train_labels = torch.tensor(train_labels)
val_labels = torch.tensor(val_labels)
train_dataset = torch.utils.data.TensorDataset(torch.tensor(train_encodings['input_ids']), train_labels)
val_dataset = torch.utils.data.TensorDataset(torch.tensor(val_encodings['input_ids']), val_labels)

# Initialize model
model = BertForSequenceClassification.from_pretrained('bert-base-uncased', num_labels=6)

# Set up training arguments
training_args = TrainingArguments(
    output_dir='../models',
    num_train_epochs=3,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=16,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='../logs',
    logging_steps=10,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    save_total_limit=2,
    load_best_model_at_end=True,
)

# Initialize Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=val_dataset,
)

# Train the model
trainer.train()

# Save the model
trainer.save_model('../models/bert_cefr_model')

EOL

# Create a placeholder for raw data
touch data/raw/cefr_data.csv

# Notify that setup is complete
echo "Project setup complete. You can now start fine-tuning BERT for CEFR classification."
