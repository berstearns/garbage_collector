from pathlib import Path
import sys
sys.path.append('./pytorch-model-pyclasses')
import json
from SumPred_dummyModel import model
from torch.utils.data import Dataset, DataLoader
from tqdm import tqdm
import torch
import random

'''
    Dataset 
'''
class SumNumbersData(Dataset):
    def __init__(self, data):
        self.data = data
        
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        return self.data[idx]

def generate_random_data():
    inputs = [
        random.randint(0, 10),
        random.randint(0, 10)
    ]
    output = sum(inputs)
    return {
        "inputs": torch.tensor(inputs, dtype=torch.float32),  # Convert to tensors
        "output": torch.tensor(output, dtype=torch.float32)
    }


def custom_collate_fn(batch):
    inputs = torch.stack([item['inputs'] for item in batch])  # Stack the inputs tensors
    outputs = torch.stack([item['output'] for item in batch])  # Stack the output tensors
    return {
        'inputs': inputs,
        'output': outputs
    }

def training_loop(model, dataset, len_dataset):
    dataloader = DataLoader(SumPred_dataset, batch_size=batch_size, collate_fn=custom_collate_fn, shuffle=True)
    model.train()
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
    n_epochs = 10
    with tqdm(total=len_dataset*n_epochs, position=0, leave=True) as pbar:
        for epoch in range(n_epochs):
            for batch in dataloader:
                pbar.update(batch_size)
                inputs, outputs = batch["inputs"], batch["output"]
                pred = model(inputs)  # Use inputs in the model prediction
                pred_error = torch.abs(pred - outputs)
                loss = torch.mean(pred_error)
                loss.backward()
                optimizer.step()
                optimizer.zero_grad()   
        return batch, pred

def test_loop(model, dataset, len_dataset):
    dataloader = DataLoader(SumPred_dataset, batch_size=batch_size, collate_fn=custom_collate_fn, shuffle=True)
    model.eval()
    with torch.no_grad():
        for batch in dataloader:
            inputs, outputs = batch["inputs"], batch["output"]
            pred = model(inputs)  # Use inputs in the model prediction
            pred_error = torch.abs(pred - outputs)
            loss = torch.mean(pred_error)
            print(f"{loss}")
    return batch, pred              

if __name__ == "__main__":
    '''
        Training
    '''
    batch_size = 32
    raw_data = [
        generate_random_data() for _ in range(100000)
    ]
    SumPred_dataset = SumNumbersData(raw_data)
    # SumPred_dataloader = DataLoader(SumPred_dataset, batch_size=batch_size, collate_fn=custom_collate_fn, shuffle=True)
    len_dataset = len(SumPred_dataset)
    training_loop(model, SumPred_dataset, len_dataset)
    raw_data = [
        generate_random_data() for _ in range(100000)
    ]
    SumPred_test_dataset = SumNumbersData(raw_data)
    test_loop(model, SumPred_test_dataset, len_dataset)

