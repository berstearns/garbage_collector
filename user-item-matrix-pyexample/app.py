import numpy as np
import pandas as pd

# Create a dummy User-Movie matrix
data = {
    "Naruto": [5, 3, np.nan, 1],
    "One Piece": [4, np.nan, 2, 1],
    "Full metal alchemist": [np.nan, 4, 3, 5],
    "Demon Slayer": [2, 1, np.nan, 4],
}

# Create a DataFrame
user_movie_matrix = pd.DataFrame(data, index=["User1", "User2", "User3", "User4"])

# Fill missing values with 0 (assuming no rating means no interaction)
user_movie_matrix_filled = user_movie_matrix.fillna(0)

print(user_movie_matrix_filled)

