import torch
import torch.nn as nn
import torch.optim as optim

# Function to compute Lasso (L1) regularization
def lasso_regularization(model, lambda_lasso):
    lasso_loss = 0
    for param in model.parameters():
        lasso_loss += torch.sum(torch.abs(param))
    return lambda_lasso * lasso_loss

# Load your dataset
# Assuming X_train is of shape (n_samples, n_features) and y_train is of shape (n_samples,)
# X_train, y_train = ...

# Define the model
input_dim = X_train.shape[1]  # number of features
output_dim = 6  # CEFR has 6 classes
model = LassoLogisticRegression(input_dim, output_dim)

# Loss and optimizer
lambda_lasso = 0.01  # L1 regularization strength
criterion = nn.CrossEntropyLoss()  # Standard cross-entropy loss for multi-class classification
optimizer = optim.SGD(model.parameters(), lr=0.1)

# Training loop
num_epochs = 100
for epoch in range(num_epochs):
    # Zero gradients
    optimizer.zero_grad()

    # Forward pass
    outputs = model(X_train)
    loss = criterion(outputs, y_train)

    # Add Lasso regularization term
    lasso_loss = lasso_regularization(model, lambda_lasso)
    total_loss = loss + lasso_loss

    # Backward pass and optimization
    total_loss.backward()
    optimizer.step()

    # Print the loss every 10 epochs
    if (epoch+1) % 10 == 0:
        print(f"Epoch [{epoch+1}/{num_epochs}], Loss: {total_loss.item():.4f}")

# After training, you can use the model to predict new data
# output_probs = model(X_test)
