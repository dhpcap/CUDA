#include<stdio.h>
#include<stdlib.h>
#define N 20
__global__ void arradd(int* md, int* nd, int* pd)
{
	int myid = threadIdx.y * blockDim.x + threadIdx.x;
	pd[myid] = md[myid] + nd[myid];
}
int main()
{
	int size = N *N* sizeof(int);
	int m[N][N], n[N][N], p[N][N],*md, *nd,*pd;
	int i=0,j=0;	
	for(i=0; i<N; i++ )
	{
		for(j=0; j<N; j++ )
		{
			m[i][j] = i;
			n[i][j] = i;
			p[i][j] = 0;
		}
	}
	cudaMalloc(&md, size);
	cudaMemcpy(md, m, size, cudaMemcpyHostToDevice);
	cudaMalloc(&nd, size);
	cudaMemcpy(nd, n, size, cudaMemcpyHostToDevice);
	cudaMalloc(&pd, size);
	dim3   DimGrid(1, 1);     
	dim3   DimBlock(N, N);   
	arradd<<< DimGrid,DimBlock >>>(md,nd,pd);
	cudaMemcpy(p, pd, size, cudaMemcpyDeviceToHost);
	cudaFree(md); 
	cudaFree(nd);
	cudaFree (pd);
	for(i=0; i<N; i++ )
	{
		for(j=0; j<N; j++ )
		{
			printf("\t%d",p[i][j]);
		}
		printf("\n");
	}
	cudaFree(md);
	cudaFree(nd);
	cudaFree(pd);
	return 0;
}
