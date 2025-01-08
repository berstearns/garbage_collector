from transformers import AutoModelForCausalLM, AutoTokenizer
import numpy as np

# Load the model and tokenizer
model_name="meta-llama/Llama-3.2-1B"
model_name="HuggingFaceTB/SmolLM2-1.7B"
model_name="HuggingFaceTB/SmolLM2-135M-Instruct"
# model_name="gpt2"
model = AutoModelForCausalLM.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Define the prompt
prompt = "When will a person "

# Tokenize the input
input_ids = tokenizer(prompt, return_tensors="pt").input_ids

# Generate text and return logits
generated_outputs = model.generate(
    input_ids,
    do_sample=True,
    temperature=0.5,
    max_length=100,
    output_scores=True,  # This will return the logits
    return_dict_in_generate=True,  # This ensures the output is returned as a dictionary
)

gen_text = tokenizer.batch_decode(generated_outputs.sequences)[0]
print(gen_text)

'''`
# Access the generated token IDs
generated_token_ids = generated_outputs.sequences

# Access the logits (scores) for each generated token
logits = generated_outputs.scores

# Decode the generated token IDs to text
generated_text = tokenizer.decode(generated_token_ids[0], skip_special_tokens=True)

def softmax(x):
    exp_x = np.exp(x - np.max(x))  # Subtract max for numerical stability
    return exp_x / np.sum(exp_x)

# Iterate through the logits and get the top 10 values for each token
for i, token_logits in enumerate(logits):
    print(chr(27) + "[2J")
    print(generated_text)
    # Convert logits to numpy array
    logits_np = token_logits.detach().numpy().flatten()

    # Get the indices of the top 10 values
    top_10_indices = np.argsort(logits_np)[-10:][::-1]  # Sort in descending order

    # Get the top 10 values
    top_10_values = logits_np[top_10_indices]

    # Apply softmax to normalize the top 10 values to sum to 1
    top_10_probabilities = softmax(top_10_values)

    # Map the indices to token IDs
    top_10_tokens = [tokenizer.decode([idx]) for idx in top_10_indices]

    # Print the results
    print(f"Top 10 tokens and their probabilities for token position {i}:")
    for token, prob in zip(top_10_tokens, top_10_probabilities):
        print(f"Token: {token}, Probability: {prob:.4f}")
    print("\n")
    input()
    print(chr(27) + "[2J")
    print(gen_text)
'''
