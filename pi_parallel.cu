#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<sys/time.h>
#define N 99999999
__global__ void piv2(double* aread)
{
    int i=blockIdx.x*blockDim.x+threadIdx.x;
    double dx=1.0/N , y, x=0.0;
    if(i<N)
    {
       x=i*dx;
		y = sqrt(1-x*x);  
		
        aread[i]=dx*y;
    }    	
}
int main()
{
	int i;
	double area=0.0, pi,*aread,*arr; 
	double exe_time;
	struct timeval stop_time, start_time;
    gettimeofday(&start_time, NULL);

	arr=(double *)malloc(N*sizeof(double));
    cudaMalloc(&aread,N*sizeof(double));
    
    int numperBlocks=256;     
    int num_block= (N/256)+1; //
   piv2<<<num_block,numperBlocks >>>(aread);
   cudaMemcpy(arr,aread,N*sizeof(double),cudaMemcpyDeviceToHost);
   for(i=0;i<N;i++)
   {
    area+=arr[i];
   }
	gettimeofday(&stop_time, NULL);	
	exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));
	pi = 4.0*area;
	printf("\n Value of pi is = %.16lf\n Execution time is = %lf seconds\n", pi, exe_time);
    cudaFree(aread);
    free(arr);
	return 0;
}

