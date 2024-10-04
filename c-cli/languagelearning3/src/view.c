#include "view.h"
#include "model.h"
#include <stdio.h>

void print_border() {
    printf("=======================================\n");
}

void clear_screen() {
    printf("\033[H\033[J");  // ANSI escape code to clear the terminal screen
}

void render_menu() {
    clear_screen();
    print_border();
    printf("||           Language Learning       ||\n");
    print_border();
    printf("||  1. Search Topics                  ||\n");
    printf("||  2. Fill the Gap Exercises         ||\n");
    printf("||  3. See My Vocabulary              ||\n");
    printf("||  0. Exit                           ||\n");
    print_border();
    printf("Enter your choice: ");
}

void render_search_topics() {
    clear_screen();
    print_border();
    printf("||          Search Topics             ||\n");
    print_border();
    printf("This feature allows you to search for various topics related to language learning.\n");
    printf("\nExample topics: Grammar, Vocabulary, Pronunciation\n");
    printf("You can implement topic search functionality here.\n");
    print_border();
}

void render_fill_gap_exercises() {
    clear_screen();
    print_border();
    printf("||    Fill the Gap Exercises          ||\n");
    print_border();
    printf("This feature provides exercises where you fill in the missing words in sentences.\n");
    printf("\nExample Exercise: \n");
    printf("She ___ (like) to read books.\n");
    printf("You can implement fill the gap exercises functionality here.\n");
    print_border();
}

void render_see_vocabulary() {
    clear_screen();
    print_border();
    printf("||          See My Vocabulary         ||\n");
    print_border();
    printf("This feature displays the vocabulary you've learned so far.\n");
    printf("\nExample Vocabulary List: \n");
    printf("1. Eloquent: Fluent or persuasive in speaking or writing.\n");
    printf("2. Obfuscate: To deliberately make something difficult to understand.\n");
    printf("You can implement vocabulary display functionality here.\n");
    print_border();
}
