#!/bin/bash

# Define project directory and file paths
PROJECT_DIR="languagelearning"
SRC_DIR="$PROJECT_DIR/src"
INCLUDE_DIR="$PROJECT_DIR/include"
BUILD_DIR="$PROJECT_DIR/build"
MAIN_C="$SRC_DIR/main.c"
MENU_C="$SRC_DIR/menu.c"
MENU_H="$INCLUDE_DIR/menu.h"
MAKEFILE="$PROJECT_DIR/Makefile"

# Create the project directory structure
mkdir -p "$SRC_DIR"
mkdir -p "$INCLUDE_DIR"
mkdir -p "$BUILD_DIR"

# Create main.c
cat <<EOL > "$MAIN_C"
#include <stdio.h>
#include "menu.h"

void clear_screen() {
    printf("\\033[H\\033[J");  // ANSI escape code to clear the terminal screen
}

void wait_for_keypress() {
    printf("\\nPress Enter to continue...");
    getchar();  // Wait for user input
    getchar();  // Consume the newline character left by Enter key
}

void search_topics() {
    clear_screen();
    printf("=== Search Topics ===\\n");
    // Add search topics functionality here
    wait_for_keypress();
}

void fill_gap_exercises() {
    clear_screen();
    printf("=== Fill the Gap Exercises ===\\n");
    // Add fill the gap exercises functionality here
    wait_for_keypress();
}

void see_vocabulary() {
    clear_screen();
    printf("=== See My Vocabulary ===\\n");
    // Add see my vocabulary functionality here
    wait_for_keypress();
}

int main() {
    int choice;
    while (1) {
        clear_screen();
        choice = show_menu();
        switch (choice) {
            case 1:
                search_topics();
                break;
            case 2:
                fill_gap_exercises();
                break;
            case 3:
                see_vocabulary();
                break;
            case 0:
                clear_screen();
                printf("Exiting...\n");
                return 0;
            default:
                clear_screen();
                printf("Invalid choice. Please try again.\n");
                wait_for_keypress();
        }
    }
}
EOL

# Create menu.c
cat <<EOL > "$MENU_C"
#include <stdio.h>
#include "menu.h"

int show_menu() {
    int choice;
    printf("=======================================\\n");
    printf("||           Language Learning       ||\\n");
    printf("=======================================\\n");
    printf("||  1. Search Topics                  ||\\n");
    printf("||  2. Fill the Gap Exercises         ||\\n");
    printf("||  3. See My Vocabulary              ||\\n");
    printf("||  0. Exit                           ||\\n");
    printf("=======================================\\n");
    printf("Enter your choice: ");
    scanf("%d", &choice);
    return choice;
}
EOL

# Create menu.h
cat <<EOL > "$MENU_H"
#ifndef MENU_H
#define MENU_H

int show_menu();

#endif // MENU_H
EOL

# Create Makefile
cat <<EOL > "$MAKEFILE"
CC = gcc
CFLAGS = -Iinclude -Wall
SRC = src/main.c src/menu.c
OBJ = \$(SRC:.c=.o)
EXEC = languagelearning

all: \$(EXEC)

\$(EXEC): \$(OBJ)
	\$(CC) -o \$(EXEC) \$(OBJ)

%.o: %.c
	\$(CC) \$(CFLAGS) -c \$< -o \$@

clean:
	rm -f \$(OBJ) \$(EXEC)

.PHONY: all clean
EOL

echo "Project setup complete. To build the project, navigate to the '$PROJECT_DIR' directory and run 'make'."

