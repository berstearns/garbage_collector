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
        self.linear = torch.nn.Linear(input_size, num_classes)
        self.softmax = torch.nn.functional.softmax 
    
    def forward(self, flat_x):
        logits = self.linear(flat_x)  # Apply linear transformation
        probas = self.softmax(logits, dim=1)
        return logits, probas  # Output logits (no sigmoid needed in CrossEntropyLoss)

@dataclass
class Config:
    input_size: int = None  # Default to 28x28 image flattened
    num_classes: int = None  # Default to 10 classes (for MNIST)
    output_folder: str = None  # Directory to store results
    model_name: str = None
    
    def __post_init__(self):
        for field in self.__dataclass_fields__:
            if self.__getattribute__(field) == None:
                raise Exception(f"Missing {field} field")
        if not isinstance(self.input_size, int) or self.input_size <= 0:
            raise ValueError("Input size must be a positive integer.")
        
        if not isinstance(self.num_classes, int) or self.num_classes <= 0:
            raise ValueError("Number of classes must be a positive integer.")
        
        if not os.path.exists(self.output_folder):
            print(f"Warning: Output folder '{self.output_folder}' does not exist. Creating it now.")
            os.makedirs(self.output_folder)

def save_model(model, config, model_save_path):
    # Save both model weights and configuration
    torch.save({
        'model_state_dict': model.state_dict(),
        'model_architecture': {
            'input_size': config.input_size,
            'num_classes': config.num_classes
        }
    }, model_save_path)

def load_model(model_save_path):
    # Load the model and configuration
    checkpoint = torch.load(model_save_path)
    input_size = checkpoint['model_architecture']['input_size']
    num_classes = checkpoint['model_architecture']['num_classes']
    model = FlatMultiClassLogisticRegressionModel(
            input_size=input_size,
            num_classes=num_classes
            )
    model.load_state_dict(checkpoint['model_state_dict'])
    return model, checkpoint


if __name__ == "__main__":
    config = Config(
        input_size=4,   # Example input size for 28x28 image data
        num_classes=5,     # Example for a 10-class classification problem (like MNIST)
        output_folder="models",  # Where to save the model
        model_name="CefrFlatMultiClassLogisticRegressionModel.pth",  # Where to save the model
    )
    
    print(f"Using configuration: {config}")
    model = FlatMultiClassLogisticRegressionModel(input_size=config.input_size, num_classes=config.num_classes)
    
    model_save_path = os.path.join(config.output_folder, config.model_name)
    save_model(model, config, model_save_path)
    print(f"Randomly initialized model saved to: {model_save_path}.pth")

    loaded_model, loaded_model_dict = load_model(model_save_path)

    # Example of making a prediction (random input tensor)
    with torch.no_grad():  # We don't need gradients for inference
        random_input = torch.randn(1, loaded_model_dict['model_architecture']['input_size'])  # Single example (1, 784)
        logits, probas = loaded_model(random_input)  # Get logits (predictions)
        print("Model output (logits):", logits)
        print("Model output (probas):", probas)
