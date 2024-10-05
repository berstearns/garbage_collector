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
