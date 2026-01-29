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

        pid = fork_rt(10);
        if(pid == 0)
        {
                
		pid = fork_rt(11);
                if(pid == 0)
                {
			dummy = 0;
                        for(i=0; i < STOP_POINT; i++)
                        {
                                for(j=0; j < INNER_LOOP; j++)
                                       dummy += PI*j;
                                printf(1, "PB (RT), i = %d, dummy = %x\n", i, dummy);
                        }
                        exit();
                }

                else{
			dummy = 0;
                        for(i=0; i < STOP_POINT; i++)
                        {
                                for(j=0; j < INNER_LOOP; j++)
                                       dummy += PI*j;
                                printf(1, "PA (RT), i = %d, dummy = %x\n", i, dummy);
                        }
                        wait();
		}
        }

        else
        {
		dummy = 0;
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


