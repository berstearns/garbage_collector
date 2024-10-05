import torch
import torch.nn as nn 
    
class SumPred_dummyModel(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(SumPred_dummyModel, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size, dtype=torch.float32)
        self.fc2 = nn.Linear(hidden_size, output_size, dtype=torch.float32)
        
    def forward(self, x):
        # x = torch.relu(self.fc1(x))
        x = self.fc1(x)
        x = self.fc2(x)
        return x

'''
    Model that given two numbers return their sum 
'''
model = SumPred_dummyModel(input_size=2, hidden_size=100, output_size=1)
