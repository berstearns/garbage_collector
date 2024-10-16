#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include<stdbool.h>

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

struct Iter {
    uint32_t n; uint32_t m;
    const uint8_t *x; const  uint8_t *p;
    uint32_t current_index;
};
struct myMatch {
    uint32_t pos;
};


void initIter(
        struct Iter *my,
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

bool nextIter(
        struct Iter *currentIter,
        struct myMatch *match
    ){
    uint32_t n = currentIter->n, m = currentIter->m;
    uint8_t *x = currentIter->x;
    uint8_t *p = currentIter->p;
    if (m > n) return false;
    if (m == 0) return false;

    for (uint32_t j = currentIter->current_index;j <= n - m; j++){
        uint32_t i = 0;
        while (i < m && x[j+1] == p[i]){
        }
    }
    currentIter->current_index = currentIter->current_index + 1;
    return true;
}


int main(){
    struct Iter a;
    a.n = 32;
    struct Iter b;
    struct myMatch match;
    char *x = "I was searching for a banana but found an apple so I gave up on the banana .";
    char *p = "banana";
    initIter(&b, strlen(x), strlen(p), x, p, 0);
    printf("Current iter %d\t%d\t%d\t%d\t%d\n" , b.n, b.m, b.x, b.p, b.current_index);
    while(nextIter(&b, &match)){
        printf("Current iter %d\t%d\t%d\t%d\t%d\n" , b.n, b.m, b.x, b.p, b.current_index);
        break;
    }
    printf("done");
    return 0;
}
