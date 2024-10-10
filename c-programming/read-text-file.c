#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void read_text_file_by_char(char[] filepath);

int main(){
	char filepath[] = "test.txt";
	read_text_file_by_char(filepath);
	return 0;
}

void read_text_file_by_char(char[] fp){
	FILE* ptr;
	char ch;
	ptr = fopen(fp, "r");

	if ( NULL == ptr ){
		printf("failed to open file \n");
	}

	do {
		ch = fgetc(ptr);
		printf("%c", ch);
	} while (ch != EOF);
	fclose(ptr);
}
