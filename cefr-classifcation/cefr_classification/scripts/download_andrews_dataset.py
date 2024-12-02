import os
import gdown
import yaml
import zipfile
from dataclasses import dataclass

# Constants
SCRIPT_ABSFP = os.path.abspath(__file__)  # Absolute path of this script
SCRIPT_FOLDER = os.path.dirname(SCRIPT_ABSFP)  # Folder containing the script
EXPECTED_PROJECT_ROOT_FOLDER = os.path.dirname(SCRIPT_FOLDER)  # Expected root folder for the project

@dataclass
class DownloadConfig:
    CONFIG_FILE_PATH: str = os.path.join(EXPECTED_PROJECT_ROOT_FOLDER, '.env')  # Default path to the config file
    ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID: str = None
    BASE_FOLDER_CFG: str = EXPECTED_PROJECT_ROOT_FOLDER  # Default to the root folder of the project

    def __post_init__(self):
        # Load configuration from YAML file
        self.load_config()

        # Ensure the Google Drive ID is provided
        if self.ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID is None:
            raise ValueError("ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID must not be None")

        # Set default folder paths using the BASE_FOLDER_CFG
        self.output_parent_dir_path = os.path.join(self.BASE_FOLDER_CFG, "datasets", "NLP4CALL_2025_experiment")
        self.output_filepath = os.path.join(self.output_parent_dir_path, "experiments_data.zip")
        self.expected_downloaded_file = self.output_filepath

    def load_config(self):
        """Load the configuration from the YAML file."""
        try:
            with open(self.CONFIG_FILE_PATH, 'r') as file:
                config = yaml.load(file,Loader=yaml.Loader)
                self.ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID = config.get('ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID', self.ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID)
                self.BASE_FOLDER_CFG = config.get('BASE_FOLDER_CFG', self.BASE_FOLDER_CFG)
        except FileNotFoundError:
            raise FileNotFoundError(f"Configuration file {self.CONFIG_FILE_PATH} not found.")
        except yaml.YAMLError as e:
            raise ValueError(f"Error loading YAML configuration: {e}")

class DataDownloader:
    def __init__(self, config: DownloadConfig):
        self.config = config
        self.url = f"https://drive.google.com/uc?id={self.config.ANDREW_EXPERIMENT_ZIP_FOLDER_GDRIVE_ID}"
        self.output_filepath = self.config.output_filepath
        self.output_parent_dir_path = self.config.output_parent_dir_path
        self.expected_downloaded_file = self.config.expected_downloaded_file

    def download_data(self):
        # Ensure the output directory exists
        if not os.path.exists(self.expected_downloaded_file):
            os.makedirs(self.output_parent_dir_path, exist_ok=True)  # Create parent directories if needed
            # Start downloading the file
            print(f"Downloading from {self.url} to {self.output_filepath}")
            gdown.download(url=self.url, output=self.output_filepath)
        else:
            print(f"File already exists: {self.expected_downloaded_file}")
        with zipfile.ZipFile(self.output_filepath, 'r') as zip_ref:
            zip_ref.extractall(self.output_filepath.replace(".zip",""))


if __name__ == "__main__":
    # Load configuration from YAML
    config = DownloadConfig()
    # Create a downloader with the config
    downloader = DataDownloader(config)
    # Start the download
    downloader.download_data()
