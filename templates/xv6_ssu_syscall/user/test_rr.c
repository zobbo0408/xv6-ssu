#include "types.h"
#include "stat.h"
#include "user.h"

#define INNER_LOOP 5000000
#define OUTER_LOOP 30
#define STOP_POINT 20
#define PI 3.14

int main(int argc, char **argv)
{
	int pid = getpid();
	float dummy = 0;
	int i, j;
	printf(1, "=== TEST START ===\n");

	pid = fork();
	if(pid == 0)
	{
		pid = fork();
		if(pid == 0)
		{
			dummy = 0;
			for(i=0; i < STOP_POINT; i++)
			{
				for(j=0; j < INNER_LOOP; j++)
				       dummy += PI*j;
				printf(1, "P3 (RR), i = %d, dummy = %x\n", i, dummy);
			}
                    	exit();
		}
		else
		{
			dummy = 0;
                        for(i=0; i < STOP_POINT; i++)
                        {
                                for(j=0; j < INNER_LOOP; j++)
                                       dummy += PI*j;
                                printf(1, "P2 (RR), i = %d, dummy = %x\n", i, dummy);
                        }
			wait();
		}
	}

	else
	{
                for (i=0; i< STOP_POINT; i++){   
                        for (j=0; j<INNER_LOOP; j++)
                                        dummy += PI*j;
                        printf(1, "P1 (RR), i = %d, dummy = %x\n", i, dummy);
                }   
                wait();
                printf(1, "=== TEST DONE ===\n");
	}
	exit();
}

