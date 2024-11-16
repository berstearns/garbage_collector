# usage python evaluate_predictions.py --predicted_file predicted_labels.txt --reference_file reference_labels.txt --average macro
import argparse
from cefr_classification_metrics import CEFRClassificationMetrics  # Assuming the class is in cefr_classification_metrics.py

def parse_args():
    """
    Parse command-line arguments.
    """
    parser = argparse.ArgumentParser(description="Evaluate CEFR classification model predictions")
    
    # Required arguments for predicted and reference label files
    parser.add_argument(
        "--predicted_file", 
        type=str, 
        required=True, 
        help="Path to the file containing predicted CEFR labels"
    )
    
    parser.add_argument(
        "--reference_file", 
        type=str, 
        required=True, 
        help="Path to the file containing reference CEFR labels"
    )
    
    # Optional argument to specify the averaging method for multi-class metrics
    parser.add_argument(
        "--average", 
        type=str, 
        choices=["macro", "micro", "weighted"], 
        default="macro", 
        help="Averaging method for precision, recall, F1 score ('macro', 'micro', or 'weighted')"
    )
    
    return parser.parse_args()

def main():
    # Parse command-line arguments
    args = parse_args()
    
    # Initialize the evaluation metrics class
    metrics = CEFRClassificationMetrics(predicted_file=args.predicted_file, reference_file=args.reference_file)

    # Evaluate predictions
    results = metrics.evaluate(average=args.average)
    
    # Print the results
    print(f"Evaluation Results:")
    print(f"Accuracy: {results['accuracy']:.4f}")
    print(f"Precision: {results['precision']:.4f}")
    print(f"Recall: {results['recall']:.4f}")
    print(f"F1 Score: {results['f1_score']:.4f}")
    
    # Optionally, print the detailed classification report (this is a dictionary)
    print("\nClassification Report:")
    for label, metrics in results['classification_report'].items():
        if isinstance(metrics, dict):  # Only print metrics for classes
            print(f"{label}:")
            for metric, value in metrics.items():
                print(f"  {metric}: {value:.4f}")

if __name__ == "__main__":
    main()
