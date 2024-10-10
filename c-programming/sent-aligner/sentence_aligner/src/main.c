#include <stdio.h>
#include <string.h>

#define MAX_TOKENS 100

// Structure to hold a pair of indices
typedef struct {
    int index1;
    int index2;
} IndexPair;

// Function to align tokens and return matching indices
int alignTokens(char *tokens1[], int len1, char *tokens2[], int len2, IndexPair pairs[]) {
    int pairCount = 0;
    // Iterate over both token arrays to find exact matches
    for (int i = 0; i < len1; i++) {
        for (int j = 0; j < len2; j++) {
            if (strcmp(tokens1[i], tokens2[j]) == 0) {
                pairs[pairCount].index1 = i;
                pairs[pairCount].index2 = j;
                pairCount++;
            }
        }
    }

    return pairCount;  // Return the number of matching pairs found
}

int main() {
    // Example token arrays
    char *tokens1[] = {"the", "quick", "brown", "fox","oranges"};
    char *tokens2[] = {"quick", "brown", "fox", "jumps", "bananas","oranges"};

    int len1 = 4;  // Length of tokens1
    int len2 = 5;  // Length of tokens2

    IndexPair pairs[MAX_TOKENS];

    // Get the matching pairs
    int pairCount = alignTokens(tokens1, len1, tokens2, len2, pairs);

    // Print the results
    printf("Matching pairs of indices:\n");
    for (int i = 0; i < pairCount; i++) {
        printf("%d\n",i);
        printf("tokens1[%d] -> tokens2[%d]\n", pairs[i].index1, pairs[i].index2);
    }

    return 0;
}
