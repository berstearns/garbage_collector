#!/bin/bash

# Compile the program
echo "Compiling program..."
gcc -o ./bin/sentence_aligner ./src/main.c

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo "You can run the program using: ./bin/sentence_aligner"
else
    echo "Compilation failed!"
fi
