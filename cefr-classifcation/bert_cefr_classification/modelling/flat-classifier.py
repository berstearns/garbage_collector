from dataclasses import dataclass 
import os
import torch

'''
 a flat classifier simple get already processed 
 features and calculates a linear layer 
'''
class FlatMultiClassLogisticRegressionModel(torch.nn.Module):
    def __init__(self, input_size, num_classes):
        super(FlatMultiClassLogisticRegressionModel, self).__init__()
        # Linear layer with multiple output classes
        self.linear = torch.nn.Linear(input_size, num_classes)
    
    def forward(self, flat_x):
        # x = x.view(-1, 28*28)  # Flatten the input tensor
        logits = self.linear(x)  # Apply linear transformation
        return logits  # Output logits (no sigmoid needed in CrossEntropyLoss)

@dataclass
class Config:
    input_size: int = None  # Default to 28x28 image flattened
    num_classes: int = None  # Default to 10 classes (for MNIST)
    output_folder: str = None  # Directory to store results
    model_name: str = None
    
    def __post_init__(self):
        print(dir(self))
        for field in self.__dataclass_fields__:
            if self.__getattribute__(field) == None:
                raise Exception(f"Missing {field} field")
        # Validation checks
        if not isinstance(self.input_size, int) or self.input_size <= 0:
            raise ValueError("Input size must be a positive integer.")
        
        if not isinstance(self.num_classes, int) or self.num_classes <= 0:
            raise ValueError("Number of classes must be a positive integer.")
        
        if not os.path.exists(self.output_folder):
            print(f"Warning: Output folder '{self.output_folder}' does not exist. Creating it now.")
            os.makedirs(self.output_folder)
        
# Main execution starts here
if __name__ == "__main__":
    # Initialize config object
    config = Config(
        input_size=4,   # Example input size for 28x28 image data
        num_classes=6,     # Example for a 10-class classification problem (like MNIST)
        output_folder="models",  # Where to save the model
        model_name="CefrFlatMultiClassLogisticRegressionModel.pth",  # Where to save the model
    )
    
    # Print config values
    print(f"Using configuration: {config}")

    # Create the model (with random weights)
    model = FlatMultiClassLogisticRegressionModel(input_size=config.input_size, num_classes=config.num_classes)
    
    # Save the model with random weights
    model_save_path = os.path.join(config.output_folder, config.model_name)
    torch.save(model.state_dict(), model_save_path)

    print(f"Randomly initialized model saved to: {model_save_path}.pth")
