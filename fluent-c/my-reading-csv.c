#include <string.h>
#include <stdlib.h>
#include <stdio.h>
struct Data {
};
struct DatasetInfo {
	int n_rows;
	int n_cols;
};
struct DatasetRows {
	struct Data *data;
};
struct Dataset {
	struct DatasetInfo *dsi;
	struct DatasetRows *dsr;
};
int main(){
	/*
	 * reading a simple csv
	 * dataset
	 * 	has rows
	 * 		a row
	 * 			has data
	 *
	*/
	FILE *fp = NULL;
	char row_str[100];
	struct DatasetInfo *dsi = malloc(sizeof(struct DatasetInfo));
	if( dsi == NULL ){
		perror("Failed to allocate memory");
		return EXIT_FAILURE; // Exit if memory allocation fails
	}	
	fp = fopen("dummy.csv", "r");
	if(fp == NULL){
		perror("Failed to open file");
		free(dsi); // Free allocated memory before exit
		return EXIT_FAILURE; // Exit if file opening fails
        }


 	if(fscanf(fp, "%[^\n]", row_str)== 1){
		printf("Data from the file:\n%s\n", row_str);
		char *token;
		token = strtok(row_str, ",");
		dsi->n_rows = atoi(token);
		printf("n_rows: %d\n", dsi->n_rows);
		token = strtok(0, ",");
		dsi->n_cols =atoi(token);
		printf("n_cols: %d\n", dsi->n_cols);

	}
	struct Dataset *ds; 

	fclose(fp);
	return 0;
}
