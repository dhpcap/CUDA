
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<sys/time.h>
#define N 1000000
/*
                N  PRIME_NUMBER

                1           0
               10           4
              100          25
            1,000         168
           10,000       1,229
          100,000       9,592
        1,000,000      78,498
       10,000,000     664,579
      100,000,000   5,761,455
    1,000,000,000  50,847,534

*/
__global__ void prime(int* countd)
{
    int i=blockIdx.x*blockDim.x+threadIdx.x;
    int j;
    int flag = 0;
    if((i>2) && (i<N))
    {
		for(j=2;j<i;j++)	
	    	{
		    if((i%j) == 0)
		    {
			    flag = 1;
			    break;
		    }
	    	}
        	if(flag == 0)
        	{
            		countd[i]=1;
        	}
            else
            {
              countd[i]=0;  
            }
    }        
}

int main()
{
	int i;
	int count,*countd,*cnt;
	double exe_time;
	struct timeval stop_time, start_time;
    int size =  N*sizeof(int);
	
	count = 1; // 2 is prime. Our loop starts from 3
	
	gettimeofday(&start_time, NULL);

    cnt=(int *)malloc(N*sizeof(int));
    cudaMalloc(&countd,N*sizeof(int));

    //cudaMalloc(&flagd,size);
    //cudaMemcpy(countd,cnt,size,cudaMemcpyHostToDevice);
    //    cudaMemcpy(flagd,flag,size,cudaMemcpyHostToDevice);

    int numBlocks=256;     
    int num_block= (N/numBlocks)+1; 
    prime<<<num_block,numBlocks >>>(countd);
	
    cudaMemcpy(cnt, countd, size, cudaMemcpyDeviceToHost);
	
	/*for(i=3;i<N;i++)
	{
	 	flag = 0;
		for(j=2;j<i;j++)	
	    	{
		    if((i%j) == 0)
		    {
			    flag = 1;
			    break;
		    }
	    	}
        	if(flag == 0)
        	{
            		count++;
        	}
	}*/
	
	gettimeofday(&stop_time, NULL);	
	exe_time = (stop_time.tv_sec+(stop_time.tv_usec/1000000.0)) - (start_time.tv_sec+(start_time.tv_usec/1000000.0));
	
    for(i=3;i<N;i++)
	{
	 	if(cnt[i]==1)
        {
            count++;
        }
    }    
	printf("\n Number of prime numbers = %d \n Execution time is = %lf seconds\n", count, exe_time);
	cudaFree(countd); 
	cudaFree(cnt);
    return 0;
}
