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

```bash
pip install -r requirements.txt
```

## Usage
1. Place raw data in `data/raw`.
2. Run the training script in the `scripts/` directory.
