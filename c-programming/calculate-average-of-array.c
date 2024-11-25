#include <stdio.h>
#include <stdlib.h>
float mean(float *a, int size_a){
	float mean=0.0f;
	for(int i=0;i<size_a;i++){
		printf("%f\t", a[i]); 
		mean+=a[i];
	}
	mean /= size_a;
	return mean;
}

void assign_value_to(float v, float *a, int *PCURR_N){
	a[*PCURR_N] = v;
	(*PCURR_N)+=1;
}

int main(){
	int MAX_N = 100;
	int *PCURR_N = (int *)calloc(1, sizeof(int));
	float *arr = (float *)malloc(MAX_N * sizeof(float));
    	if (arr == NULL || PCURR_N == NULL) {
		printf("Memory allocation failed!\n");
		return -1;
	}
	printf("%i", *PCURR_N);
	assign_value_to(1.f, arr, PCURR_N);
	assign_value_to(2.f, arr, PCURR_N);
	assign_value_to(3.f, arr, PCURR_N);
	printf("%f", mean(arr, *PCURR_N));
}
