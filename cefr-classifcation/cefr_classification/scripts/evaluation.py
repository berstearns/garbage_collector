from sklearn.metrics import precision_score, recall_score, f1_score, accuracy_score, classification_report

class CEFRClassificationMetrics:
    """
    A class to calculate evaluation metrics (accuracy, precision, recall, F1 score)
    for CEFR level classification tasks.
    """

    def __init__(self, predicted_file, reference_file):
        """
        Initializes with paths to the predicted and reference classification files.
        
        :param predicted_file: Path to the file containing predicted CEFR labels.
        :param reference_file: Path to the file containing reference CEFR labels.
        """
        self.predicted_file = predicted_file
        self.reference_file = reference_file
        self.predicted_labels = self.load_labels(predicted_file)
        self.reference_labels = self.load_labels(reference_file)

    def load_labels(self, file_path):
        """
        Load labels from a file. Each line in the file should represent a single label
        (either predicted or reference) corresponding to a document or sentence.

        :param file_path: Path to the label file.
        :return: List of labels.
        """
        labels = []
        with open(file_path, 'r') as file:
            for line in file:
                labels.append(line.strip())  # Assuming each line contains one label
        return labels

    def calculate_accuracy(self):
        """Calculate accuracy for CEFR classification."""
        return accuracy_score(self.reference_labels, self.predicted_labels)

    def calculate_precision(self, average='macro'):
        """Calculate precision for CEFR classification."""
        return precision_score(self.reference_labels, self.predicted_labels, average=average, labels=list(set(self.reference_labels)))

    def calculate_recall(self, average='macro'):
        """Calculate recall for CEFR classification."""
        return recall_score(self.reference_labels, self.predicted_labels, average=average, labels=list(set(self.reference_labels)))

    def calculate_f1_score(self, average='macro'):
        """Calculate F1 score for CEFR classification."""
        return f1_score(self.reference_labels, self.predicted_labels, average=average, labels=list(set(self.reference_labels)))

    def evaluate(self, average='macro'):
        """
        Evaluate the accuracy, precision, recall, and F1 score for CEFR classification.

        :param average: Method to average the precision, recall, and F1 score ('macro', 'micro', or 'weighted').
        :return: Dictionary containing accuracy, precision, recall, and F1 score.
        """
        accuracy = self.calculate_accuracy()
        precision = self.calculate_precision(average)
        recall = self.calculate_recall(average)
        f1 = self.calculate_f1_score(average)

        # Optionally, you can also return a more detailed classification report
        report = classification_report(self.reference_labels, self.predicted_labels, output_dict=True)

        return {
            "accuracy": accuracy,
            "precision": precision,
            "recall": recall,
            "f1_score": f1,
            "classification_report": report
        }
