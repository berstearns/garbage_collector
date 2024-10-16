#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "reading-csv.h"

#define MAX_ROWS 50
#define MAX_LINE_LENGTH 1024
#define MAX_COLUMNS 10  // Adjust based on your CSV structure

typedef struct {
    char data[MAX_COLUMNS][MAX_LINE_LENGTH];  // Assuming each column can fit in MAX_LINE_LENGTH
} Row;

typedef struct {
    Row rows[MAX_ROWS];
    int row_count;
} Batch;

void read_csv_in_batches(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Failed to open file");
        return;
    }

    char line[MAX_LINE_LENGTH];
    int batch_count = 0;

    while (fgets(line, sizeof(line), file)) {
        Batch batch;
        batch.row_count = 0;

        do {
            // Tokenize the line into columns
            char *token = strtok(line, ",");
            int column_count = 0;

            while (token != NULL && column_count < MAX_COLUMNS) {
                strncpy(batch.rows[batch.row_count].data[column_count], token, MAX_LINE_LENGTH);
                token = strtok(NULL, ",");
                column_count++;
            }

            batch.row_count++;
            if (batch.row_count >= MAX_ROWS) {
                break; // Batch is full
            }

        } while (fgets(line, sizeof(line), file) && batch.row_count < MAX_ROWS);

        // Print the current batch
        printf("Batch %d:\n", batch_count + 1);
        for (int i = 0; i < batch.row_count; i++) {
            for (int j = 0; j < MAX_COLUMNS; j++) {
                printf("%s ", batch.rows[i].data[j]);
            }
            printf("\n");
        }

        batch_count++;
        printf("Press Enter to continue to the next batch...\n");
        getchar();  // Wait for user input to continue
    }

    fclose(file);
    printf("Finished reading the CSV file.\n");
}
