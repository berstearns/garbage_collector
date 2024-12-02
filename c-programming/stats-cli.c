#include <stdio.h>
#include <stdlib.h>
#include "sorting.h"
#include "quantile.h"

extern void GPTbubbleSort(float *arr, int n);

float mean(float *a, int size_a){
	float total_sum=0.0f;
	for(int i=0;i<size_a;i++){
		total_sum+=a[i];
	}
	float mean = total_sum / size_a;
	return mean;
}

void assign_value_to(float v, float *a, int *PCURR_N){
	a[*PCURR_N] = v;
	(*PCURR_N)+=1;
}


int main(){
	int MAX_N = 100;
	int *PCURR_N = (int *)calloc(1, sizeof(int));
	float *Parr = (float *)malloc(MAX_N * sizeof(float));
    	if (Parr == NULL || PCURR_N == NULL) {
		printf("Memory allocation failed!\n");
		return -1;
	}
	printf("%i\n", *PCURR_N);
	assign_value_to(1.f, Parr, PCURR_N);
	assign_value_to(2.f, Parr, PCURR_N);
	assign_value_to(3.f, Parr, PCURR_N);
	assign_value_to(5.f, Parr, PCURR_N);
	assign_value_to(1.f, Parr, PCURR_N);
	assign_value_to(4.f, Parr, PCURR_N);
	assign_value_to(2.f, Parr, PCURR_N);
	printf("%f\t", mean(Parr, *PCURR_N));
	printf("\n", mean(Parr, *PCURR_N));

	GPTbubbleSort(Parr, *PCURR_N); 
	
	for(int i = 0; i < *PCURR_N; i++){
		printf("%.2f\t", Parr[i]);
	}
	printf("\n");

    	free(Parr);
    	free(PCURR_N);
}
