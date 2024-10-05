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
