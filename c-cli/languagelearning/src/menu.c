#include <stdio.h>
#include "menu.h"

int show_menu() {
    int choice;
    printf("=======================================\n");
    printf("||           Language Learning       ||\n");
    printf("=======================================\n");
    printf("||  1. Search Topics                  ||\n");
    printf("||  2. Fill the Gap Exercises         ||\n");
    printf("||  3. See My Vocabulary              ||\n");
    printf("||  0. Exit                           ||\n");
    printf("=======================================\n");
    printf("Enter your choice: ");
    scanf("%d", &choice);
    return choice;
}
