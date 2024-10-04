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
