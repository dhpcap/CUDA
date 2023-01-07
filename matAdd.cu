#include<stdio.h>
#include<stdlib.h>
#define N 256
__global__ void MatAdd(float* A,float* B,float* C)
{
  int i=blockIdx.x*blockDim.x+threadIdx.x;
  int j=blockIdx.y*blockDim.y+threadIdx.y;
  C[i*N+j]=A[i*N+j]+B[i*N+j];
}

int main()
{
    int size=N*sizeof(float);
    int i,j;
    float a[N][N],b[N][N],c[N][N],*A,*B,*C;
    
    for(i=0;i<N;i++)
    {
        for(j=0;j<N;j++)
        {
            a[i][j]=5;
            b[i][j]=5;
            c[i][j]=0;
        }
    }

   cudaMalloc(&A,size);
   cudaMalloc(&B,size);
   cudaMalloc(&C,size);
   cudaMemcpy(A,a,size,cudaMemcpyHostToDevice);
   cudaMemcpy(B,b,size,cudaMemcpyHostToDevice);
   //int numBlocks=1;
   dim3 numblocks(16,16);
   dim3 threadPerBlock(16,16);
   MatAdd<<<numblocks,threadPerBlock >>>(A,B,C);
   cudaMemcpy(c,C,size,cudaMemcpyDeviceToHost);

   for(i=0;i<N;i++)
    {
        for(j=0;j<N;j++)
        {
            printf("\t%f",c[i][j]);
        }
    }

    cudaFree(A);
    cudaFree(B);
    cudaFree(C);

    return 0;
}