"""
Module for Question Generation using prompts and Hugging Face Transformers

This module contains classes and methods for reading a knowledge related to an art, a prompt and a target LLM (Hugging Face model),
running a prompt with information to generate chunks on the quesiton in JSON format, and saving it.

Classes:
    MissingFileInQuestionGenerationConfig: Exception raised when a file is missing in the QuestionGenerationConfig.
    MissingQuestionGenerationConfigException: Exception raised when a required QuestionGenerationConfig property is missing.
    QuestionGenerationConfig: Dataclass containing configuration properties for Question Generation.
    QuestionGenerationPipeline: Main class to handle the quesiton generation process.

Usage example:
    config_dict = {
        'KG_FP': 'input.txt',
        'OUTPUT_FOLDER': 'output',
        'MODEL_NAME': 'gpt2'
    }
    prompt_loader = SomePromptLoaderClass()
    quesiton_gen = QuestionGenerationPipeline(config_dict, prompt_loader)
    quesiton_gen.load_prompt()
    quesiton_gen.run()
"""

from dataclasses import dataclass
import json
import os
from datetime import datetime

# from hf_olmo import OLMoForCausalLM, OLMoTokenizerFast
from transformers import pipeline, AutoModelForCausalLM, AutoTokenizer


class MissingFileInQuestionGenerationConfig(Exception):
    """Exception raised when a file is missing in the QuestionGenerationConfig."""

    pass


class MissingQuestionGenerationConfigException(Exception):
    """Exception raised when a required QuestionGenerationConfig property is missing."""

    pass


class ClientOptions:
    """
    Class to hold static variables (constants) for client options.
    """

    OLLAMA = "ollama"
    HUGGINGFACE = "huggingface"


@dataclass
class QuestionGenerationConfig:
    """
    Dataclass containing configuration properties for Question Generation.

    Attributes:
        KG_FP (str): File path for input text.
        OUTPUT_FOLDER (str): Folder path for output data.
        MODEL_NAME (str): Name of the model to use (e.g., "gpt2", "allenai/OLMo-7B", or "llama2").
        CLIENT (str): The client to use for model inference. Must be either "ollama" or "huggingface" (case-insensitive).
        OLLAMA_API_URL (str): URL for the Ollama API (if using Ollama).
    """

    KG_FP: str = None
    OUTPUT_FOLDER: str = None
    MODEL_NAME: str = None
    CLIENT: str = None

    def __post_init__(self):
        """
        Post-initialization to validate configuration properties.

        Raises:
            MissingQuestionGenerationConfigException: If a required property is missing.
            ValueError: If the CLIENT is not "ollama" or "huggingface" (case-insensitive).
        """
        # Check for missing required fields
        for key in self.__dataclass_fields__:
            if self.__getattribute__(key) is None and key != "OLLAMA_API_URL":
                raise MissingQuestionGenerationConfigException(
                    f"Missing {key} config property"
                )

        self.CLIENT = self.CLIENT.lower()  # Ensure case-insensitive comparison
        valid_clients = [ClientOptions.OLLAMA, ClientOptions.HUGGINGFACE]
        if self.CLIENT not in valid_clients:
            raise ValueError(
                f"Invalid CLIENT: {self.CLIENT}. Must be one of {valid_clients}."
            )


class QuestionGenerationPipeline:
    """
    Main class to handle the quesiton generation process.

    This class takes a chunk of text as input, runs a prompt to annotate
    the chunk in JSON format, and saves the annotated data.

    Example of the JSON format:
    {
        "chunk": "---text---",
        "psychological_concepts": {
            "anxiety_and_unease": {
                "explanation": "----text---",
                "reflective_question": "----?"
            }
        },
        "philosophical_concepts": {
            "nature_of_reality_and_perception": {
                "explanation": "----text---",
                "reflective_question": "----?"
            }
        },
        "reflective_questions": [
            ";;;;?",
            "ladsasf?"
        ]
    }

    Args:
        config_dict (dict): Configuration dictionary containing paths and settings.
        promptLoader (object): An instance of the prompt loader class.

    Attributes:
        config (QuestionGenerationConfig): Instance of the QuestionGenerationConfig dataclass.
        promptLoader (object): Instance of the prompt loader class.
    """

    def __init__(self, config_dict, promptLoader):
        """
        Initializes the QuestionGenerationPipeline class with configuration and prompt loader.

        Args:
            config_dict (dict): Configuration dictionary containing paths and settings.
            promptLoader (object): An instance of the prompt loader class.
        """
        self.config = QuestionGenerationConfig(**config_dict)
        self.promptLoader = promptLoader
        # Choose the appropriate model and tokenizer based on the MODEL_NAME
        # if "olmo" in self.config.MODEL_NAME.lower():
        #   self.model = OLMoForCausalLM.from_pretrained(self.config.MODEL_NAME)
        #   self.tokenizer = OLMoTokenizerFast.from_pretrained(self.config.MODEL_NAME)
        # else:
        if self.config.CLIENT == ClientOptions.OLLAMA:
            self.generator = self._ollama_pipeline
        if self.config.CLIENT == ClientOptions.OLLAMA:
            self.model = AutoModelForCausalLM.from_pretrained(
                self.config.MODEL_NAME, trust_remote_code=True
            )
            self.tokenizer = AutoTokenizer.from_pretrained(self.config.MODEL_NAME)
            self.generator = self._hf_pipeline

    def _hf_pipeline(self, prompt_instance, **kwargs):
        pipeline = pipeline(
            "text-generation", model=self.model, tokenizer=self.tokenizer
        )
        return pipeline(prompt_instance, max_length=500, num_return_sequences=1)[0][
            "generated_text"
        ]

    def _ollama_pipeline(self, prompt_instance, **kwargs):
        chat_args = {
            "model": self.config.MODEL_NAME,
            "messages": [{"role": "user", "content": prompt_instance}],
            "stream": True,
        }
        stream = self.client.chat(**chat_args)

        full_message = ""
        for chunk in stream:
            full_message += chunk["message"]["content"]
        return full_message

    def load_prompt_template(self):
        """Loads the prompt using the prompt loader."""
        return self.promptLoader()

    def run(self):
        """Executes the quesiton generation process."""
        with open(self.config.KG_FP) as inpf:
            if self.config.KG_FP.endswith(".txt"):
                texts = [inpf.read()]
            elif self.config.KG_FP.endswith(".md"):
                texts = [inpf.read()]
            elif self.config.KG_FP.endswith(".json"):
                texts = json.load(inpf)
            else:
                raise ValueError(
                    "Make sure your input file is either a single text txt file or a json array."
                )

        system_prompt_template, prompt_template = self.load_prompt_template()
        system_instruction = system_prompt_template.render()

        for text_idx, text in enumerate(texts):
            prompt_instance = prompt_template.render(text=text)
            input_filename = self.config.KG_FP.split("/")[-1]
            zfill_text_idx = str(text_idx).zfill(7)
            timestr = datetime.now().strftime("%Y-%m-%d-%H-%M")
            output_fp = f"{self.config.OUTPUT_FOLDER}/{input_filename}_{zfill_text_idx}_{self.config._normalized_modelname}-{timestr}.json"
            old_fp = f"{self.config.OUTPUT_FOLDER}/{input_filename}_{text_idx}_{self.config._normalized_modelname}.json"
            if os.path.isfile(output_fp) or os.path.isfile(old_fp):
                continue

            # Generate text using Hugging Face model
            generated_text = self.generator(
                prompt_instance, max_length=500, num_return_sequences=1
            )

            with open(output_fp, "w") as outf:
                outf.write(generated_text)
