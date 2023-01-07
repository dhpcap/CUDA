#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#define VECTORSIZE 10
__global__ void matVecMul(int* A,int* B, int* C)
{
  int i=blockIdx.x*blockDim.x+threadIdx.x;
  int j;
  int sum=0;
  if(i<VECTORSIZE)
  {
    sum = 0;
		for(j=0;j<VECTORSIZE;j++)
		{
			sum = sum + A[i*VECTORSIZE+j]*B[i];	
		}
		C[i] =  sum;
  }
}
int main(int argc, char **argv)
{
	int size=VECTORSIZE * sizeof(int);
	int i, j;
	int *A, *B, *C,*Ad,*Bd,*Cd;		
	double exe_time;
	struct timeval stop_time, start_time;
	
	//Allocate the arrays
	A = (int *)malloc(VECTORSIZE*VECTORSIZE*sizeof(int));
	B = (int *)malloc(VECTORSIZE*sizeof(int));
	C = (int *)malloc(VECTORSIZE*sizeof(int));
	
	//Initialize data to some value
	for(i=0;i<VECTORSIZE;i++)
	{
		for(j=0;j<VECTORSIZE;j++)
		{
			A[i*VECTORSIZE+j] = 1;	
		}
		B[i] = 1;
	}
	
    // for serial code
	//print the data
	/*printf("\nInitial data: \n");
	for(i=0;i<VECTORSIZE;i++)
	{
		for(j=0;j<VECTORSIZE;j++)                
		{
			printf("\t%d ", A[i*VECTORSIZE+j]);	
		}
		printf("\n");
	}
	for(i=0;i<VECTORSIZE;i++)
	{
		printf("\t%d", B[i]);
	}	*/
	
	gettimeofday(&start_time, NULL);
     
     cudaMalloc(&Ad, VECTORSIZE*size);
     cudaMalloc(&Bd, size);
     cudaMalloc(&Cd, size);

    cudaMemcpy(Ad, A ,VECTORSIZE*VECTORSIZE*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(Bd, B ,VECTORSIZE*sizeof(int),cudaMemcpyHostToDevice);
    dim3   DimGrid(1, 1);     
	dim3   DimBlock(VECTORSIZE,1);
    matVecMul<<<DimGrid,DimBlock >>>(Ad,Bd,Cd);
    cudaMemcpy(C,Cd,VECTORSIZE*sizeof(int),cudaMemcpyDeviceToHost);
	
    // for serial code
	/*for(i=0;i<VECTORSIZE;i++)
	{
		sum = 0;
		for(j=0;j<VECTORSIZE;j++)
		{
			sum = sum + A[i*VECTORSIZE+j]*B[i];	
		}
		C[i] =  sum;
	}*/
	
	gettimeofday(&stop_time, NULL);	
	exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));
	
	//print the data
	printf("\nMatrix & Vector multiplication output: \n");
	for(i=0;i<VECTORSIZE;i++)
	{
		printf("\t%d", C[i]);	
	}
	printf("\n Execution time is = %lf seconds\n", exe_time);
	
	printf("\nProgram exit!\n");
	
	//Free arrays
	free(A); 
	free(B);
	free(C);
    return 0;
}
