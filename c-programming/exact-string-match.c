#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include<stdbool.h>
struct naive_match_iter {
    const uint8_t *x; uint32_t n;
    const uint8_t *p; uint32_t m;
    uint32_t current_index;
};

/*void init_naive_match_iter(
    struct naive_match_iter *iter,
    const uint8_t *x, uint32_t n,
    const uint8_t *p, uint32_t m,
    uint32_t current_index;
        ){
    iter->x = x; iter->n = n;
    iter->p = p; iter->m = m;
    iter->current_index = current_index;
}*/

struct myBool {
    uint32_t n; uint32_t m;
    const uint8_t *x; const  uint8_t *p;
    uint32_t current_index;
};
struct myMatch {
    uint32_t pos;
};


void initMyBool(
        struct myBool *my,
        uint32_t n, uint32_t m,
        const uint8_t *x, const uint8_t *p,
        uint32_t current_index
        ){
    my->n = n;
    my->m = m;
    my->x = x;
    my->p = p;
    my->current_index = current_index;
}

bool nextMyBool(
        struct myBool *my,
        struct myMatch *match
    ){
    uint32_t n = my->n, m = my->m;
    uint8_t *x = my->x;
    uint8_t *p = my->p;
    my->current_index = (uint32_t) 32;
    return true;
}




int main(){
    struct myBool a;
    a.n = 32;
    struct myBool b;
    struct myMatch match;
    char *x = "I was searching for a banana but found an apple";
    char *p = "banan";
    initMyBool(&b, strlen(x), strlen(p), x, p, 0);
    printf("Current iter %d\t%d\t%d\t%d\t%d\n" , b.n, b.m, b.x, b.p, b.current_index);
    while(nextMyBool(&b, &match)){
        printf("Current iter %d\t%d\t%d\t%d\t%d\n" , b.n, b.m, b.x, b.p, b.current_index);
        break;
    }
    printf("done");
    // struct naive_match_iter iter;
    return 0;
}
