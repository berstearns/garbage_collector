#include <stdio.h>
#include "menu.h"

void clear_screen() {
    printf("\033[H\033[J");  // ANSI escape code to clear the terminal screen
}

void wait_for_keypress() {
    printf("\nPress Enter to continue...");
    getchar();  // Wait for user input
    getchar();  // Consume the newline character left by Enter key
}

void search_topics() {
    clear_screen();
    printf("=== Search Topics ===\n");
    // Add search topics functionality here
    wait_for_keypress();
}

void fill_gap_exercises() {
    clear_screen();
    printf("=== Fill the Gap Exercises ===\n");
    // Add fill the gap exercises functionality here
    wait_for_keypress();
}

void see_vocabulary() {
    clear_screen();
    printf("=== See My Vocabulary ===\n");
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
