# Sentence Aligner Project

This project is a simple sentence aligner implemented in C. It aligns tokens from two token arrays and returns matching indices.

## Project Structure

- **src/**: Contains the source code.
- **bin/**: Compiled binaries are stored here.
- **include/**: Header files (if needed in future versions) can be placed here.
- **build.sh**: Script to compile the project.

## How to Build and Run

1. Run the build script to compile the program:
   ```bash
   ./build.sh
   ```

2. After compilation, you can run the program:
   ```bash
   ./bin/sentence_aligner
   ```

## Example Output

For the token arrays:

- `tokens1[] = {"the", "quick", "brown", "fox"}`
- `tokens2[] = {"quick", "brown", "fox", "jumps"}`

The program will output the matching indices as:

```
Matching pairs of indices:
tokens1[1] -> tokens2[0]
tokens1[2] -> tokens2[1]
tokens1[3] -> tokens2[2]
```

