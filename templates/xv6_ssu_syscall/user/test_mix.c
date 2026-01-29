#include "types.h"
#include "stat.h"
#include "user.h"

#define INNER_LOOP 5000000
#define OUTER_LOOP 20
#define PI 3.14

const char *level[] = {"RR", "RT"};
int main(int argc, char **argv)
{
        int pid = getpid();
        float dummy = 0;
        int i, j;
        printf(1, "=== TEST START ===\n");

        pid = fork();
        if(pid == 0)		
        {
		dummy = 0;
                for (i=0; i<10; i++){
                        for (j=0; j<INNER_LOOP; j++)
                                dummy += PI*j;
                        printf(1, "P2 (RR), i = %d, dummy = %x\n", i, dummy);
                }

		pid = fork();
                if(pid == 0)
		{
			dummy = 0;
                        for (i=0; i<10; i++){
                                for (j=0; j<INNER_LOOP; j++)
                                        dummy += PI*j;
                                printf(1, "P3 (RR), i = %d, dummy = %x\n", i, dummy);
                        }

			pid = fork_rt(20);
			if(pid == 0)
			{
				printf(1, "=== RT SCHED START ===\n");
				dummy = 0;
                                for (i=0; i<10; i++){
                                	for (j=0; j<INNER_LOOP; j++)
                                        	dummy += PI*j;
                                        printf(1, "PA (RT), i = %d, dummy = %x\n", i, dummy);
                                }

				pid = fork_rt(10);
				if(pid == 0)
				{
					dummy = 0;
                                        for (i=0; i<10; i++){
                                                for (j=0; j<INNER_LOOP; j++)
                                                        dummy += PI*j;
                                                printf(1, "PB (RT), i = %d, dummy = %x\n", i, dummy);
                                        }

					pid = fork_rt(11);
					if(pid == 0)
					{

						dummy = 0;
                                                for (i=0; i<10; i++){
                                                        for (j=0; j<INNER_LOOP; j++)
                                                                dummy += PI*j;
                                                        printf(1, "PC (RT), i = %d, dummy = %x\n", i, dummy);
                                                }

						pid = fork();
						if(pid == 0) // P4
						{
							dummy = 0;
                                                        for (i=0; i<20; i++){
                                                                for (j=0; j<INNER_LOOP; j++)
                                                                        dummy += PI*j;
                                                                printf(1, "P4 (RR), i = %d, dummy = %x\n", i, dummy);
                                                        }
							exit();
						}

						else
						{
							dummy = 0;
							for (i=10; i<20; i++){
								for (j=0; j<INNER_LOOP; j++)
									dummy += PI*j;
								printf(1, "PC (RT), i = %d, dummy = %x\n", i, dummy);
							}
							wait();
						}
					}

					else
					{
						dummy = 0;
						for (i=10; i<20; i++){
							for (j=0; j<INNER_LOOP; j++)
								dummy += PI*j;
							printf(1, "PB (RT), i = %d, dummy = %x\n", i, dummy);
						}
                                        	wait();
					}
				}

				else
				{
					dummy = 0;
					for (i=10; i<20; i++){
						for (j=0; j<INNER_LOOP; j++)
							dummy += PI*j;
                                        	printf(1, "PA (RT), i = %d, dummy = %x\n", i, dummy);
					}
					printf(1, "=== RT SCHED DONE ===\n");
                                	wait();
				}
			}

			else
			{
				dummy = 0;
				for (i=10; i<20; i++){
					for (j=0; j<INNER_LOOP; j++)
						dummy += PI*j;
					printf(1, "P3 (RR), i = %d, dummy = %x\n", i, dummy);
				}
                        	wait();
			}
		}

		else
		{
			dummy = 0;
                	for (i=10; i<20; i++){
                        	for (j=0; j<INNER_LOOP; j++)
                               	        dummy += PI*j;
                        	printf(1, "P2 (RR), i = %d, dummy = %x\n", i, dummy);
                	}
                	wait();
		}
	}

        else
        {
		dummy = 0;
                for (i=0; i<20; i++){ 
                        for (j=0; j<INNER_LOOP; j++)
                                        dummy += PI*j;
                        printf(1, "P1 (RR), i = %d, dummy = %x\n", i, dummy);
                }
                wait();
                printf(1, "=== TEST DONE ===\n");
        }
        exit();
}
