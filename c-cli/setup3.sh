#!/bin/bash

# Define project directory and file paths
PROJECT_DIR="languagelearning3"
SRC_DIR="$PROJECT_DIR/src"
INCLUDE_DIR="$PROJECT_DIR/include"
BUILD_DIR="$PROJECT_DIR/build"
MAIN_C="$SRC_DIR/main.c"
MODEL_C="$SRC_DIR/model.c"
VIEW_C="$SRC_DIR/view.c"
MODEL_H="$INCLUDE_DIR/model.h"
VIEW_H="$INCLUDE_DIR/view.h"
CONTROLLER_H="$INCLUDE_DIR/controller.h"
MAKEFILE="$PROJECT_DIR/Makefile"

# Create the project directory structure
mkdir -p "$SRC_DIR"
mkdir -p "$INCLUDE_DIR"
mkdir -p "$BUILD_DIR"

# Create model.c
cat <<EOL > "$MODEL_C"
#include "model.h"
#include <stdio.h>

static AppState state;

void init_state() {
    state = MENU;
}

void dispatch(int action) {
    switch (action) {
        case 1:
            state = SEARCH_TOPICS;
            break;
        case 2:
            state = FILL_GAP_EXERCISES;
            break;
        case 3:
            state = SEE_VOCABULARY;
            break;
        case 0:
            state = MENU;
            break;
        default:
            state = MENU;
            break;
    }
}

AppState get_state() {
    return state;
}
EOL

# Create view.c
cat <<EOL > "$VIEW_C"
#include "view.h"
#include "model.h"
#include <stdio.h>

void print_border() {
    printf("=======================================\\n");
}

void render_menu() {
    print_border();
    printf("||           Language Learning       ||\\n");
    print_border();
    printf("||  1. Search Topics                  ||\\n");
    printf("||  2. Fill the Gap Exercises         ||\\n");
    printf("||  3. See My Vocabulary              ||\\n");
    printf("||  0. Exit                           ||\\n");
    print_border();
    printf("Enter your choice: ");
}

void render_search_topics() {
    print_border();
    printf("||          Search Topics             ||\\n");
    print_border();
    printf("This feature allows you to search for various topics related to language learning.\\n");
    printf("\\nExample topics: Grammar, Vocabulary, Pronunciation\\n");
    printf("You can implement topic search functionality here.\n");
    print_border();
}

void render_fill_gap_exercises() {
    print_border();
    printf("||    Fill the Gap Exercises          ||\\n");
    print_border();
    printf("This feature provides exercises where you fill in the missing words in sentences.\\n");
    printf("\\nExample Exercise: \\n");
    printf("She ___ (like) to read books.\\n");
    printf("You can implement fill the gap exercises functionality here.\n");
    print_border();
}

void render_see_vocabulary() {
    print_border();
    printf("||          See My Vocabulary         ||\\n");
    print_border();
    printf("This feature displays the vocabulary you've learned so far.\\n");
    printf("\\nExample Vocabulary List: \\n");
    printf("1. Eloquent: Fluent or persuasive in speaking or writing.\\n");
    printf("2. Obfuscate: To deliberately make something difficult to understand.\\n");
    printf("You can implement vocabulary display functionality here.\n");
    print_border();
}
EOL

# Create model.h
cat <<EOL > "$MODEL_H"
#ifndef MODEL_H
#define MODEL_H

typedef enum {
    MENU,
    SEARCH_TOPICS,
    FILL_GAP_EXERCISES,
    SEE_VOCABULARY
} AppState;

void init_state();
void dispatch(int action);
AppState get_state();

#endif // MODEL_H
EOL

# Create view.h
cat <<EOL > "$VIEW_H"
#ifndef VIEW_H
#define VIEW_H

void render_menu();
void render_search_topics();
void render_fill_gap_exercises();
void render_see_vocabulary();

#endif // VIEW_H
EOL

# Create controller.h
cat <<EOL > "$CONTROLLER_H"
#ifndef CONTROLLER_H
#define CONTROLLER_H

void handle_input();

#endif // CONTROLLER_H
EOL

# Create main.c
cat <<EOL > "$MAIN_C"
#include "controller.h"
#include "model.h"
#include "view.h"
#include <stdio.h>

void handle_input() {
    int choice;
    while (1) {
        switch (get_state()) {
            case MENU:
                render_menu();
                break;
            case SEARCH_TOPICS:
                render_search_topics();
                break;
            case FILL_GAP_EXERCISES:
                render_fill_gap_exercises();
                break;
            case SEE_VOCABULARY:
                render_see_vocabulary();
                break;
        }
        scanf("%d", &choice);
        dispatch(choice);
    }
}

int main() {
    init_state();
    handle_input();
    return 0;
}
EOL

# Create Makefile
cat <<EOL > "$MAKEFILE"
CC = gcc
CFLAGS = -Iinclude -Wall
SRC = src/main.c src/model.c src/view.c
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

