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
