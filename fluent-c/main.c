// main.c
#include <stdio.h>
#include "reading-csv.h"

int main() {
    const char *filename = "data.csv";  // Your CSV file name
    read_csv_in_batches(filename);
    return 0;
}
