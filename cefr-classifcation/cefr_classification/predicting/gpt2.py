from transformers import GPT2LMHeadModel, GPT2Tokenizer
import torch
import random

# Load the pre-trained GPT-2 model and tokenizer
checkpoint = "gpt2"  # GPT-2 model
device = "cuda" if torch.cuda.is_available() else "cpu"

# Load the tokenizer and model
tokenizer = GPT2Tokenizer.from_pretrained(checkpoint)
model = GPT2LMHeadModel.from_pretrained(checkpoint).to(device)

# Set the pad token to be the same as the eos token (as GPT-2 doesn't have a padding token)
tokenizer.pad_token = tokenizer.eos_token

# Define the CEFR levels (A1, A2, B1, B2, C1, C2)
cefr_levels = ["A1", "A2", "B1", "B2", "C1", "C2"]

# Example input text for CEFR classification
text = "Gravity is a force that attracts objects toward one another."

# Tokenize the input text, ensuring padding is handled by setting padding=True
inputs = tokenizer(text, return_tensors="pt", truncation=True, padding=True).to(device)

# Get model's output logits (we will not use actual generation here)
with torch.no_grad():
    outputs = model(**inputs)

logits = outputs.logits

# Since GPT-2 is not trained for CEFR classification, we'll simulate the prediction
# Randomly select a CEFR level as a dummy classification
predicted_class_idx = random.randint(0, 5)  # Randomly choose from 0-5 for 6 CEFR levels
predicted_cefr = cefr_levels[predicted_class_idx]

# Print the simulated CEFR level
print(logits.shape)
print(f"Simulated CEFR level: {predicted_cefr}")
