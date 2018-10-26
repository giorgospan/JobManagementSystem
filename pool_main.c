#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "MiscHeader.h"
#include "PoolHeader.h"



/*These variables are declared in pool_header.h*/
struct entry* job_table;

int maxjobs; 			
int pool_number; 		
int jobs = 0;		 	
int finished = 0; 		
int can_exit = 0;
char path[PATHSIZE]; 	



void 	main(int argc, char *argv[])
{
	int nwrite,nread;
	int in;
	int out;
	int i;
	char pool_out[MSGSIZE];
	char pool_in[MSGSIZE];
	pid_t pid;
	
	static struct sigaction act;
	act.sa_handler = catch_term_signal ;
	
	/* other signals to be blocked
	during the handling of the signal*/
	sigfillset (&(act.sa_mask ));
	
	sigaction (SIGTERM,&act,NULL );
	
	
/***********************************************************************************/		
	
	/*Accessing arguments given to pool.exe */
	pool_number = atoi(argv[1]);
	maxjobs = atoi(argv[2]);
	strcpy(pool_in,argv[3]);
	strcpy(pool_out,argv[4]);
	strcpy(path,argv[5]);
	
	
	
	job_table  = malloc(maxjobs*sizeof(struct entry));
	for(i=0;i<maxjobs;++i) job_table[i].jobID = 0;
	
/***********************************************************************************/	
	/*Creating pool_in fifo*/
	if ( mkfifo(pool_in, 0666) == -1 )
	{
		if ( errno!=EEXIST ) { perror("POOL: mkfifo"); exit(1); };
	}
	/*Opening both pool fifos*/
	if ( (in=open(pool_in, O_RDONLY | O_NONBLOCK)) < 0)
	{
		perror("pool_in open problem[POOL]"); exit(2);	
	}
	if ( (out=open(pool_out, O_WRONLY  )) < 0)
	{
		perror("pool_out open problem[POOL]"); exit(3);	
	}
	
/***********************************************************************************/

	pool_coord_comm(in,out);
		
/***********************************************************************************/
	// printf("~~~~~~~~~~~~~~Pool:%d is exiting with jobs done:%d~~~~~~~~~~~~~~\n",getpid(),finished);
	free(job_table);
	exit(0);
}
