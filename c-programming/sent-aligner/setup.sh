#!/bin/bash

# Project structure
PROJECT_NAME="sentence_aligner"
SRC_DIR="$PROJECT_NAME/src"
BIN_DIR="$PROJECT_NAME/bin"
INCLUDE_DIR="$PROJECT_NAME/include"
BUILD_SCRIPT="$PROJECT_NAME/build.sh"

# Create directories
echo "Creating project directories..."
mkdir -p $SRC_DIR $BIN_DIR $INCLUDE_DIR

# Create C source file in src
echo "Creating source file..."
cat <<EOF > $SRC_DIR/main.c
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
    char *tokens1[] = {"the", "quick", "brown", "fox"};
    char *tokens2[] = {"quick", "brown", "fox", "jumps"};

    int len1 = 4;  // Length of tokens1
    int len2 = 4;  // Length of tokens2

    IndexPair pairs[MAX_TOKENS];
    
    // Get the matching pairs
    int pairCount = alignTokens(tokens1, len1, tokens2, len2, pairs);

    // Print the results
    printf("Matching pairs of indices:\\n");
    for (int i = 0; i < pairCount; i++) {
        printf("tokens1[%d] -> tokens2[%d]\\n", pairs[i].index1, pairs[i].index2);
    }

    return 0;
}
EOF

# Create a build script
echo "Creating build script..."
cat <<EOF > $BUILD_SCRIPT
#!/bin/bash

# Compile the program
echo "Compiling program..."
gcc -o $BIN_DIR/sentence_aligner $SRC_DIR/main.c

# Check if compilation was successful
if [ \$? -eq 0 ]; then
    echo "Compilation successful!"
    echo "You can run the program using: $BIN_DIR/sentence_aligner"
else
    echo "Compilation failed!"
fi
EOF

# Make build script executable
chmod +x $BUILD_SCRIPT

# Create a README file
echo "Creating README file..."
cat <<EOF > $PROJECT_NAME/README.md
# Sentence Aligner Project

This project is a simple sentence aligner implemented in C. It aligns tokens from two token arrays and returns matching indices.

## Project Structure

- **src/**: Contains the source code.
- **bin/**: Compiled binaries are stored here.
- **include/**: Header files (if needed in future versions) can be placed here.
- **build.sh**: Script to compile the project.

## How to Build and Run

1. Run the build script to compile the program:
   \`\`\`bash
   ./build.sh
   \`\`\`

2. After compilation, you can run the program:
   \`\`\`bash
   ./bin/sentence_aligner
   \`\`\`

## Example Output

For the token arrays:

- \`tokens1[] = {"the", "quick", "brown", "fox"}\`
- \`tokens2[] = {"quick", "brown", "fox", "jumps"}\`

The program will output the matching indices as:

\`\`\`
Matching pairs of indices:
tokens1[1] -> tokens2[0]
tokens1[2] -> tokens2[1]
tokens1[3] -> tokens2[2]
\`\`\`

EOF

# Create .gitignore file
echo "Creating .gitignore file..."
cat <<EOF > $PROJECT_NAME/.gitignore
# Ignore binary files
bin/

# Ignore build script outputs
*.o
*.out
EOF

# Finished
echo "Project setup is complete!"
echo "To build and run the project:"
echo "  1. Navigate to the $PROJECT_NAME directory."
echo "  2. Run './build.sh' to compile the project."
echo "  3. Run './bin/sentence_aligner' to execute the program."

