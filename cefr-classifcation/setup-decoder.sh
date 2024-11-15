#!/bin/bash

# Create main project structure
mkdir -p decoders_cefr_classification/{client,code}
cd decoders_cefr_classification

# Initialize Poetry in the 'code' directory
cd code
poetry init -n --name cefr_model --description "A package for fine-tuning and using small LLMs for CEFR classification." --license MIT
poetry add torch transformers datasets scikit-learn

# Create package structure in 'code' folder
mkdir -p cefr_model/{data,training,prediction}

# Create __init__.py files to make directories packages
touch cefr_model/__init__.py
touch cefr_model/training/__init__.py
touch cefr_model/prediction/__init__.py

# Create a training script in 'code/cefr_model/training/train.py'
cat << 'EOF' > cefr_model/training/train.py
import torch
from transformers import AutoModelForSequenceClassification, AutoTokenizer, Trainer, TrainingArguments
from datasets import load_dataset
from sklearn.metrics import accuracy_score, precision_recall_fscore_support

def compute_metrics(pred):
    labels = pred.label_ids
    preds = pred.predictions.argmax(-1)
    precision, recall, f1, _ = precision_recall_fscore_support(labels, preds, average='weighted')
    acc = accuracy_score(labels, preds)
    return {"accuracy": acc, "f1": f1, "precision": precision, "recall": recall}

def train(model_name="gpt2", dataset_path="data/cefr_dataset.csv", output_dir="model"):
    dataset = load_dataset("csv", data_files=dataset_path)
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=6)  # Assuming CEFR levels A1 to C2
    
    def preprocess(data):
        return tokenizer(data["text"], truncation=True, padding="max_length")

    tokenized_data = dataset.map(preprocess, batched=True)
    train_args = TrainingArguments(
        output_dir=output_dir,
        evaluation_strategy="epoch",
        per_device_train_batch_size=8,
        per_device_eval_batch_size=8,
        num_train_epochs=3,
        weight_decay=0.01,
    )
    trainer = Trainer(
        model=model,
        args=train_args,
        train_dataset=tokenized_data["train"],
        eval_dataset=tokenized_data["test"],
        compute_metrics=compute_metrics
    )
    trainer.train()
    trainer.save_model(output_dir)
EOF

# Create a prediction script in 'code/cefr_model/prediction/predict.py'
cat << 'EOF' > cefr_model/prediction/predict.py
import torch
from transformers import AutoModelForSequenceClassification, AutoTokenizer
import sys

def predict(model_dir, text):
    tokenizer = AutoTokenizer.from_pretrained(model_dir)
    model = AutoModelForSequenceClassification.from_pretrained(model_dir)
    inputs = tokenizer(text, return_tensors="pt", truncation=True, padding="max_length")
    outputs = model(**inputs)
    probs = torch.nn.functional.softmax(outputs.logits, dim=-1)
    predicted_class = probs.argmax().item()
    confidence = probs.max().item()
    return predicted_class, confidence

if __name__ == "__main__":
    model_dir = sys.argv[1]
    text = sys.argv[2]
    label, confidence = predict(model_dir, text)
    print(f"Predicted CEFR Level: {label}, Confidence: {confidence:.2f}")
EOF

# Create a README for the 'code' package
cat << 'EOF' > README.md
# CEFR Model
A package for training and using small language models for CEFR level classification.
EOF

# Go to 'client' directory and create user-facing scripts
cd ../client

# Create the train.py script for user
cat << 'EOF' > train.py
import os
import sys
sys.path.insert(0, os.path.abspath('../code'))
from cefr_model.training.train import train

if __name__ == "__main__":
    model_name = "gpt2"  # Replace with "smoLLM" or another model if desired
    dataset_path = "data/cefr_dataset.csv"
    output_dir = "model"
    train(model_name=model_name, dataset_path=dataset_path, output_dir=output_dir)
EOF

# Create the predict.py script for user
cat << 'EOF' > predict.py
import os
import sys
sys.path.insert(0, os.path.abspath('../code'))
from cefr_model.prediction.predict import predict

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python predict.py <model_dir> <text>")
        sys.exit(1)
    
    model_dir = sys.argv[1]
    text = sys.argv[2]
    label, confidence = predict(model_dir, text)
    print(f"Predicted CEFR Level: {label}, Confidence: {confidence:.2f}")
EOF

# Create a sample dataset in client/data
mkdir -p data
cat << 'EOF' > data/cefr_dataset.csv
text,label
"I am learning English",A1
"This is an intermediate level example.",B2
"I have an advanced understanding of English vocabulary.",C1
EOF

echo "Project setup complete!"
