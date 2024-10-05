import torch
import torch.nn as nn 
    
class FNN(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(FNN, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.fc2 = nn.Linear(hidden_size, output_size)
        
    def forward(self, x):
        x = torch.relu(self.fc1(x))
        x = self.fc2(x)
        return x                

"""
    which vocabulary ?
"""
BoG_V8473_FNN = FNN(input_size=[512, 12], hidden_size=100, output_size=2)
torch.save(BoG_V8473_FNN, "BoG_V8473_FNN")


NWP_BoG_V8473_FNN = FNN(input_size=784, hidden_size=100, output_size=2)
torch.save(NWP_V8473_FNN, "NWP_BoG_V8473_FNN")

NWP_VBERT_FNN = FNN(input_size=784, hidden_size=100, output_size=2)
torch.save(NWP_VBERT_FNN, "NWP_V8473_FNN")
