#!/bin/bash

# Create project directory structure
PROJECT_NAME="bert_nationality_project"
MODEL_DIR="$PROJECT_NAME/model"
DATA_DIR="$PROJECT_NAME/data"
TRAIN_DIR="$PROJECT_NAME/train"
SCRIPT_DIR="$PROJECT_NAME/scripts"

echo "Setting up project directory: $PROJECT_NAME"
mkdir -p $MODEL_DIR
mkdir -p $DATA_DIR
mkdir -p $TRAIN_DIR
mkdir -p $SCRIPT_DIR

# Create README file
echo "Creating README.md..."
cat <<EOL > $PROJECT_NAME/README.md
# BERT with Nationality Embeddings

This project implements a BERT model with additional nationality embeddings for use in an MLM task.
The model is fine-tuned using LoRA and can be quantized using bitsandbytes for efficiency.

## Project Structure:
- \`model/\`: Contains model definition
- \`data/\`: Data preparation scripts
- \`train/\`: Training script
- \`scripts/\`: Helper scripts for running tasks

## Setup
Run \`setup_bert_nationality_project.sh\` to initialize the project structure.

## Training
Modify the train.py script and run:

\`\`\`bash
python train.py
\`\`\`

EOL

# Create model definition file
echo "Creating model definition file (bert_with_nationality_embeddings.py)..."
cat <<EOL > $MODEL_DIR/bert_with_nationality_embeddings.py
import torch
import torch.nn as nn
from transformers import BertModel

class BERTWithNationalityEmbeddings(nn.Module):
    def __init__(self, model_name="bert-base-uncased", num_nationalities=3, emb_size=768):
        super(BERTWithNationalityEmbeddings, self).__init__()
        # Load the BERT model
        self.bert = BertModel.from_pretrained(model_name)
        # Nationality embedding layer
        self.nationality_embeddings = nn.Embedding(num_embeddings=num_nationalities, embedding_dim=emb_size)
        # Final classifier layer (for MLM task, should match the vocab size)
        self.vocab_size = self.bert.config.vocab_size
        self.classifier = nn.Linear(emb_size * 2, self.vocab_size)

    def forward(self, input_ids, attention_mask=None, token_type_ids=None, nationality_ids=None):
        outputs = self.bert(input_ids=input_ids, attention_mask=attention_mask, token_type_ids=token_type_ids)
        sequence_output = outputs.last_hidden_state  # (batch_size, sequence_length, hidden_size)
        nationality_embeds = self.nationality_embeddings(nationality_ids)
        nationality_embeds = nationality_embeds.unsqueeze(1).repeat(1, sequence_output.size(1), 1)
        concat_output = torch.cat((sequence_output, nationality_embeds), dim=-1)
        logits = self.classifier(concat_output)  # (batch_size, sequence_length, vocab_size)
        return logits
EOL

# Create data processing script
echo "Creating data processing script (prepare_data.py)..."
cat <<EOL > $DATA_DIR/prepare_data.py
from transformers import BertTokenizer
from datasets import load_dataset

def prepare_dataset():
    tokenizer = BertTokenizer.from_pretrained("bert-base-uncased")
    dataset = load_dataset("wikitext", "wikitext-2-raw-v1", split="train")

    def tokenize_function(examples):
        tokenized = tokenizer(examples["text"], padding="max_length", truncation=True, max_length=128)
        nationality_ids = torch.randint(0, 3, (len(tokenized["input_ids"]),))  # Random nationality IDs
        tokenized["nationality_ids"] = nationality_ids
        return tokenized

    tokenized_dataset = dataset.map(tokenize_function, batched=True, remove_columns=["text"])
    tokenized_dataset.set_format("torch")
    return tokenized_dataset

if __name__ == "__main__":
    dataset = prepare_dataset()
    print("Data preparation complete.")
EOL

# Create training script
echo "Creating training script (train.py)..."
cat <<EOL > $TRAIN_DIR/train.py
import torch
from transformers import Trainer, TrainingArguments, DataCollatorForLanguageModeling
from model.bert_with_nationality_embeddings import BERTWithNationalityEmbeddings
from data.prepare_data import prepare_dataset
from peft import LoraConfig, get_peft_model

# Load dataset
dataset = prepare_dataset()

# Initialize the model
model = BERTWithNationalityEmbeddings(num_nationalities=3, emb_size=768)

# LoRA config
lora_config = LoraConfig(
    task_type="CAUSAL_LM",
    r=8,
    lora_alpha=32,
    target_modules=["query", "value"],
    lora_dropout=0.1,
    bias="none"
)
model = get_peft_model(model, lora_config)

# Define training arguments
training_args = TrainingArguments(
    output_dir="./bert_with_nationality_mlm",
    per_device_train_batch_size=16,
    gradient_accumulation_steps=4,
    num_train_epochs=3,
    weight_decay=0.01,
    logging_dir="./logs",
    logging_steps=100,
    save_steps=1000,
    fp16=True,
    push_to_hub=False
)

# Data collator for MLM
data_collator = DataCollatorForLanguageModeling(
    tokenizer=model.bert.config.name_or_path, mlm=True, mlm_probability=0.15
)

# Nationality-aware collator
def custom_collator(batch):
    input_ids = torch.stack([item['input_ids'] for item in batch])
    attention_mask = torch.stack([item['attention_mask'] for item in batch])
    nationality_ids = torch.stack([item['nationality_ids'] for item in batch])
    mlm_batch = data_collator([{"input_ids": input_ids[i]} for i in range(len(input_ids))])
    mlm_batch["nationality_ids"] = nationality_ids
    return mlm_batch

# Initialize Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset,
    data_collator=custom_collator
)

# Train the model
trainer.train()
EOL

# Create script to run everything
echo "Creating run.sh..."
cat <<EOL > $SCRIPT_DIR/run.sh
#!/bin/bash

echo "Preparing dataset..."
python $DATA_DIR/prepare_data.py

echo "Starting training..."
python $TRAIN_DIR/train.py
EOL

# Make run.sh executable
chmod +x $SCRIPT_DIR/run.sh

echo "Project setup complete!"

