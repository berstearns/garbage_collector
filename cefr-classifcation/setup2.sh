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

After training, the script will generate classification reports for both the training and validation (test) sets and save them in the \`logs/\` directory.
EOL

# Create the updated training script
cat <<EOL > scripts/train.py
import torch
from transformers import BertTokenizer, BertForSequenceClassification, Trainer, TrainingArguments
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import numpy as np
from sklearn.metrics import classification_report

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

# Function to get predictions and classification report
def evaluate_and_report(dataset, labels, split_name):
    predictions = trainer.predict(dataset).predictions
    predicted_labels = np.argmax(predictions, axis=1)
    report = classification_report(labels, predicted_labels, target_names=le.classes_, digits=4)
    print(f"Classification Report for {split_name} set:\n{report}")
    with open(f'../logs/{split_name}_classification_report.txt', 'w') as f:
        f.write(report)

# Evaluate and report on training set
evaluate_and_report(train_dataset, train_labels, "train")

# Evaluate and report on validation (test) set
evaluate_and_report(val_dataset, val_labels, "test")
EOL

# Create a sample cefr_data.csv file with some example data
cat <<EOL > data/raw/cefr_data.csv
text,cefr_level
"I can understand and use familiar everyday expressions and very basic phrases.",A1
"I can describe experiences and events, dreams, hopes, and ambitions.",B1
"I can produce simple connected text on topics that are familiar or of personal interest.",B1
"I can express ideas fluently and spontaneously without much obvious searching for expressions.",C1
"I can understand a wide range of demanding, longer texts, and recognize implicit meaning.",C2
"I can introduce myself and others, ask and answer questions about personal details.",A1
"I can deal with most situations likely to arise whilst travelling in an area where the language is spoken.",B2
"I can interact with a degree of fluency and spontaneity that makes regular interaction with native speakers quite possible.",B2
"I can present clear, detailed descriptions of complex subjects, integrating sub-themes and developing particular points.",C1
"I can understand the main ideas of complex text on both concrete and abstract topics, including technical discussions in my field of specialization.",B2
EOL

# Notify that setup is complete
echo "Project setup complete. You can now start fine-tuning BERT for CEFR classification. After training, classification reports will be saved in the logs directory."
