#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<sys/time.h>
#define N 99999999
#define NUM_THDS 256
__global__ void piv2(double* aread)
{
   
    int i=blockIdx.x*blockDim.x+threadIdx.x;
     int j;
    double dx=1.0/N , y, x=0.0;
    double tmp =0.0;
 __shared__ double tmp_area[NUM_THDS];
 tmp_area[threadIdx.x]=0.0;
    if(i<N)
    {
       x=i*dx;
		y = sqrt(1-x*x);  
		
        tmp_area[threadIdx.x]=dx*y;
    } 
__syncthreads();
if(i<N)
{
    if(threadIdx.x==0)
    {
        tmp =0.0;
       for(j=0;j<NUM_THDS;j++)
        {
          tmp+=tmp_area[j];//tmp_area[threadIdx.x];
       }
      aread[blockIdx.x]=tmp;
    }
}   	
}

int main()
{
	int i;
	double area=0.0, pi,*aread,*arr; 
	double exe_time;
	struct timeval stop_time, start_time;
    gettimeofday(&start_time, NULL);
    int numperBlocks=NUM_THDS;     
    int num_block= (N/256)+1;

	arr=(double *)malloc (num_block*sizeof(double));
    cudaMalloc(&aread,num_block*sizeof(double));
    
     //
   piv2<<<num_block,numperBlocks >>>(aread);

   cudaMemcpy(arr,aread,num_block*sizeof(double),cudaMemcpyDeviceToHost);
   for(i=0;i<num_block;i++)
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

