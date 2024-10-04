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
