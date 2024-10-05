# BERT with Nationality Embeddings

This project implements a BERT model with additional nationality embeddings for use in an MLM task.
The model is fine-tuned using LoRA and can be quantized using bitsandbytes for efficiency.

## Project Structure:
- `model/`: Contains model definition
- `data/`: Data preparation scripts
- `train/`: Training script
- `scripts/`: Helper scripts for running tasks

## Setup
Run `setup_bert_nationality_project.sh` to initialize the project structure.

## Training
Modify the train.py script and run:

```bash
python train.py
```

