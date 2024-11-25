#include <stdio.h>
#include <stdlib.h>
float mean(float *a, int size_a){
	float total_sum=0.0f;
	for(int i=0;i<size_a;i++){
		total_sum+=a[i];
	}
	float mean = total_sum / size_a;
	return mean;
}

float median(float *a, int size){
	return 0.f;
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

    	free(arr);
    	free(PCURR_N);

}
