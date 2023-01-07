#include<stdio.h>
#include<stdlib.h>
#define N 200
__global__ void vacAdd(float* A, float* B, float* C)
{
    int i=blockIdx.x*blockDim.x+threadIdx.x;
    C[i]=A[i]+B[i];

}

int main()
{
    int size=N*sizeof(float);
    float a[N],b[N],c[N],*A,*B,*C;
    int i;
    
    for(i=0;i<N;i++)
    {
        a[i]=i;
        b[i]=i;
        c[i]=0;
    }
    cudaMalloc(&A,size);
    cudaMalloc(&B,size);
    cudaMalloc(&C,size);
    cudaMemcpy(A,a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(B,b,size,cudaMemcpyHostToDevice);

    vacAdd<<<1,N>>>(A,B,C);

    cudaMemcpy(c,C,size,cudaMemcpyDeviceToHost);
    for(i=0;i<N;i++)
    {
        printf("\t%f",c[i]);
    }
    cudaFree(A);
    cudaFree(B);
    return 0;
}