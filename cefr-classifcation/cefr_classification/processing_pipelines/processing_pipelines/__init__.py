from typing import Union, TypeVar, List, Callable
import pandas as pd
import numpy as np
import re
import string
import sys
import nltk
import logging
import torch
import pandas as pd
from collections import defaultdict

class CleaningPipeline:
    def __init__(self):
        # Define mappings for replacements
        self.whitespace_map = {c: " " for c in string.whitespace}
        self.replaces = {
            "...": "",
            "..": "",
        }
        self.specials = string.whitespace + ".()"

    def __call__(self, input_data: Union[str, List[str], pd.DataFrame], column_name: str = None):
        """
        Choose between single text, list of texts, or DataFrame processing.
        """
        if isinstance(input_data, str):
            # Single text processing
            return self.clean_text(input_data)
        elif isinstance(input_data, list):
            # List of texts processing
            return [self.clean_text(text) for text in input_data]
        elif isinstance(input_data, pd.DataFrame):
            # DataFrame processing
            if column_name is None:
                raise ValueError("column_name must be provided when input_data is a DataFrame.")
            return self.clean_dataframe(input_data, column_name)
        else:
            raise TypeError("Input type not supported. Must be str, list, or pandas DataFrame.")

    def clean_text(self, text: str) -> str:
        """
        Clean a single text string.
        """
        # Normalize whitespace and lowercase
        text = "".join([self.whitespace_map.get(ch.lower(), ch.lower()) for ch in text if ch.isalnum() or ch in self.specials])
        
        # Replace patterns like "...", ".."
        for pattern, replacement in self.replaces.items():
            text = text.replace(pattern, replacement)
        
        # Remove multiple dots and spaces
        text = re.sub(r'\.{2,}', '', text)
        text = re.sub(r' {2,}', ' ', text).strip()
        
        return text

    def clean_dataframe(self, df: pd.DataFrame, column_name: str) -> pd.DataFrame:
        """
        Clean a text column in a pandas DataFrame.
        """
        if column_name not in df.columns:
            raise ValueError(f"Column '{column_name}' not found in DataFrame.")
        
        # Apply cleaning to the specified column
        df[column_name] = df[column_name].apply(self.clean_text)
        return df

class Text2SentencePipeline:
    def __init__(self, tokenizer: Callable[[str], List[str]]):
        """
        Initialize the Text2Sentence class with a tokenizer function.

        Args:
            tokenizer: A function that takes a string and returns a list of sentences.
        """
        self.tokenizer = tokenizer

    def text2sentence(self, text: str) -> List[str]:
        """
        Tokenize a single text into sentences using the provided tokenizer.
        """
        return self.tokenizer(text)

    def __call__(self, input_data: Union[str, List[str], pd.DataFrame], column_name: str = None) -> Union[List[str], List[List[str]], pd.DataFrame]:
        """
        Choose between single text, list of texts, or DataFrame processing.

        Args:
            input_data: A string, list of strings, or pandas DataFrame.
            column_name: The name of the column to process if input_data is a DataFrame.

        Returns:
            Tokenized sentences based on the input type.
        """
        if isinstance(input_data, str):
            # Single text processing
            return self.text2sentence(input_data)
        elif isinstance(input_data, list):
             # List of texts processing
            return [self.text2sentence(text) for text in input_data]
        elif isinstance(input_data, pd.DataFrame):
            # DataFrame processing
            if column_name is None:
                raise ValueError("column_name must be provided when input_data is a DataFrame.")
            df = input_data.copy()
            df[column_name] = df[column_name].apply(self.text2sentence)
            return df[column_name]
        else:
            raise TypeError("Input type not supported. Must be str, list, or pandas DataFrame.")
            
class MLMPerplexityCalculator(CLMPerplexityPipeline):
    def calculate_perplexity(self, text):
        """
        Calculate perplexity for a single text input using masked language modeling.
        
        Args:
            text (str): Input text to calculate perplexity for.
        
        Returns:
            float: Perplexity score.
        """
        # Tokenize the input text
        inputs = self.tokenizer(text, return_tensors="pt", truncation=True, max_length=512).to(self.device)
        input_ids = inputs["input_ids"]

        with torch.no_grad():
            # Get the logits from the model
            outputs = self.model(**inputs)
            logits = outputs.logits

            # Calculate the loss (negative log-likelihood)
            loss_fct = torch.nn.CrossEntropyLoss(reduction="none")
            loss = loss_fct(logits.view(-1, logits.size(-1)), input_ids.view(-1))

            # Calculate perplexity
            perplexity = torch.exp(loss.mean()).item()

        return perplexity
        
class CLMPerplexityPipeline:
    def __init__(self, model_name="gpt2", device=None):
        """
        Initialize the model and tokenizer for perplexity calculation.
        
        Args:
            model_name (str): Name or path of the model (default is "gpt2").
            device (str): Device to run the model on (e.g., "cuda" or "cpu"). If None, auto-detects.
        """
        self.device = device if device else ("cuda" if torch.cuda.is_available() else "cpu")
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForCausalLM.from_pretrained(model_name).to(self.device)
        self.model.eval()  # Set the model to evaluation mode

    def calculate_perplexity(self, text):
        """
        Calculate perplexity for a single text input.
        
        Args:
            text (str): Input text to calculate perplexity for.
        
        Returns:
            float: Perplexity score.
        """
        # Tokenize the input text
        inputs = self.tokenizer(text, return_tensors="pt", truncation=True, max_length=512).to(self.device)
        input_ids = inputs["input_ids"]

        with torch.no_grad():
            # Get the logits from the model
            outputs = self.model(**inputs)
            logits = outputs.logits

            # Shift logits and labels to align for perplexity calculation
            shift_logits = logits[:, :-1, :].contiguous()
            shift_labels = input_ids[:, 1:].contiguous()

            # Calculate the loss (negative log-likelihood)
            loss_fct = torch.nn.CrossEntropyLoss(reduction="none")
            loss = loss_fct(shift_logits.view(-1, shift_logits.size(-1)), shift_labels.view(-1))

            # Calculate perplexity
            perplexity = torch.exp(loss.mean()).item()

        return perplexity

    def calculate_perplexity_for_column(self, df, text_column):
        """
        Calculate perplexity for all rows in a text column of a DataFrame.
        
        Args:
            df (pd.DataFrame): Input DataFrame.
            text_column (str): Name of the column containing text.
        
        Returns:
            pd.Series: A Series containing perplexity scores for each row.
        """
        if text_column not in df.columns:
            raise ValueError(f"Column '{text_column}' not found in DataFrame.")

        # Apply the perplexity calculation to each row in the text column
        perplexity_scores = df[text_column].apply(self.calculate_perplexity)
        return perplexity_scores

    def __call__(self, input_data, text_column=None):
        """
        Make the class callable. Accepts either a string or a DataFrame.
        
        Args:
            input_data (str or pd.DataFrame): Input text or DataFrame containing a text column.
            text_column (str, optional): Name of the text column if input_data is a DataFrame.
        
        Returns:
            float or pd.Series: Perplexity score(s) for the input data.
        """
        if isinstance(input_data, str):
            # If input is a string, calculate perplexity for the single text
            return self.calculate_perplexity(input_data)
        elif isinstance(input_data, pd.DataFrame):
            # If input is a DataFrame, calculate perplexity for the specified text column
            if text_column is None:
                raise ValueError("text_column must be provided when input_data is a DataFrame.")
            return self.calculate_perplexity_for_column(input_data, text_column)
        else:
            raise TypeError("input_data must be a string or a pandas DataFrame.")

    

class SelectAndrewsVariablesPipeline:
    def __init__(self, base_columns, selected_variables):
        self.base_columns = base_columns
        self.selected_variables = selected_variables

    def __call__(self, df):
        # Combine base_columns and selected_variables
        all_asked_columns = self.base_columns + self.selected_variables
        
        # Check which columns exist in the DataFrame
        asked_existing_columns = [col for col in all_asked_columns if col in df.columns]
        
        # Identify missing columns
        asked_missing_columns = set(all_asked_columns) - set(asked_existing_columns)
        
        if asked_missing_columns:
            # Log a warning for missing columns
            logging.warning(f"The following columns are not in the DataFrame and will be ignored: {asked_missing_columns}")
        
        # Return the DataFrame with only the existing columns
        return df[asked_existing_columns]
