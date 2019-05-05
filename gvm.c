#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include "is.h"

#define TRUE 1
#define FALSE 0
#define REGMAX 16
#define MEMMAX (256 * 256)
#define R_IP 1
#define R_FLAG 0
#define FLAG_EZ 0
#define FLAG_LZ 1
#define FLAG_GZ 2

int r[REGMAX]; /* registers */
unsigned char mem[MEMMAX]; /* memory */
char *image_file; /* image to load */
int trace;

/* instruction */
int op; /* opcode */
int rx, ry; /* registers */
int operand; /* immediate operand */

void init()
{
	int i;
	int ch;
	FILE *fh;
	int maxmem;

	for( i=0; i < REGMAX; i++ ) r[i]=0;
	for( i=0; i < MEMMAX; i++ ) mem[i]=0;
	r[R_IP]=0;
	r[R_FLAG]=0;

	fh=fopen( image_file, "rb" );
	if( fh ==  NULL )
	{
		printf( "gvm: Couldn't open %s\n", image_file );
		exit( 10 );
	}

	for( maxmem=0; (ch=fgetc( fh )) != EOF; maxmem++ ) mem[maxmem]=(char)ch;
}

void getinstruction(int ipnow)
{
	op=mem[ipnow];
	op=(op << 8) | mem[ipnow+1];
	rx=mem[ipnow+2];
	ry=mem[ipnow+3];
	operand=mem[ipnow+4];
	operand=(operand << 8) | mem[ipnow+5];
	operand=(operand << 8) | mem[ipnow+6];
	operand=(operand << 8) | mem[ipnow+7];	
}

void run()
{
	int i,t,t1,t2;
	r[R_IP]=0;
	
	for(;;)
	{
		if(trace) 
		{
			printf(" ( ");
			for(i=0; i<REGMAX; i++) printf("%d ",r[i]);
			printf(")\n");
		}
		getinstruction(r[R_IP]);
		if(trace) printf( "%08x: ", r[R_IP]);
		
		switch(op)
		{
			case I_END:
			if(trace) printf("END\n");
			exit(0);

			case I_NOP:
			if(trace) printf("NOP");
			break;

			case I_OUT:
			if(trace) printf("OUT:");
			printf( "%c", r[15] ); /* Print out r[15] in ASCII */
			break;

			case I_ADD_0:
			r[rx]=r[rx] + operand;
			if(trace) printf("ADD R%d,%d",rx,operand);
			break;

			case I_ADD_1:
			r[rx]=r[rx] + r[ry];
			if(trace) printf("ADD R%d,R%d",rx,ry);
			break;

			case I_SUB_0:
			r[rx]=r[rx] - operand;
			if(trace) printf("SUB R%d,%d",rx,operand);
			break;

			case I_SUB_1:
			r[rx]=r[rx] - r[ry];
			if(trace) printf("SUB R%d,R%d",rx,ry);
			break;

			case I_MUL_0:
			r[rx]=r[rx] * operand;
			if(trace) printf("MUL R%d,%d",rx,operand);
			break;

			case I_MUL_1:
			r[rx]=r[rx] * r[ry];
			if(trace) printf("MUL R%d,R%d",rx,ry);
			break;

			case I_DIV_0:
			if( operand == 0 ) 
			{
				printf( "GVM: Divide by zero error\n" );
				exit(0);
			} 
			else 
			{
				r[rx]=r[rx] / operand;
			}			
			if(trace) printf("DIV R%d,%d",rx,operand);
			break;

			case I_DIV_1:
			if( r[ry] == 0 ) 
			{
				printf( "GVM: Divide by zero error" );
				exit(0);
			} 
			else 
			{
				r[rx]=r[rx] / r[ry];
			}			
			if(trace) printf("DIV R%d,R%d",rx,ry);
			break;

			case I_LOD_0:
			r[rx]=operand;
			if(trace) printf("LOD R%d,%d",rx,operand);
			break;

			case I_LOD_1:
			r[rx]=r[ry];
			if(trace) printf("LOD R%d,R%d",rx,ry);
			break;

			case I_LOD_2:
			r[rx]=r[ry] + operand;
			if(trace) 
			{
				if (operand>=0) printf("LOD R%d,R%d+%d",rx,ry,operand);
				else printf("LOD R%d,R%d-%d",rx,ry,-operand);
			}
			break;

			case I_LOD_3:
			t1=operand;
			t2=mem[t1     ];
			t2=(t2 << 8) + mem[t1  + 1];
			t2=(t2 << 8) + mem[t1  + 2];
			t2=(t2 << 8) + mem[t1  + 3];
			r[rx]=t2;
			if(trace) printf("LOD R%d,(%d)",rx,operand);
			break;

			case I_LOD_4:
			t=mem[r[ry]    ];
			t=(t << 8) + mem[r[ry] + 1];
			t=(t << 8) + mem[r[ry] + 2];
			t=(t << 8) + mem[r[ry] + 3];
			r[rx]=t;
			if(trace) printf("LOD R%d,(R%d)",rx,ry);
			break;

			case I_LOD_5:
			t1=r[ry] + operand;
			t2=mem[t1     ];
			t2=(t2 << 8) + mem[t1  + 1];
			t2=(t2 << 8) + mem[t1  + 2];
			t2=(t2 << 8) + mem[t1  + 3];
			r[rx]=t2;
			if(trace) 
			{
				if (operand>=0) printf("LOD R%d,(R%d+%d)",rx,ry,operand);
				else printf("LOD R%d,(R%d-%d)",rx,ry,-operand);
			}
			break;

			case I_STO_0:
			mem[r[rx]]=operand >> 24;
			mem[r[rx] + 1]=operand >> 16 & 0xff;
			mem[r[rx] + 2]=operand >>  8 & 0xff;
			mem[r[rx] + 3]=operand       & 0xff;
			if(trace) printf("STO (R%d),%d",rx,operand);
			break;

			case I_STO_1:
			mem[r[rx]]=r[ry] >> 24;
			mem[r[rx] + 1]=r[ry] >> 16 & 0xff;
			mem[r[rx] + 2]=r[ry] >>  8 & 0xff;
			mem[r[rx] + 3]=r[ry]       & 0xff;
			if(trace) printf("STO (R%d),R%d",rx,ry);
			break;

			case I_STO_2:
			t=r[ry]+operand;
			mem[r[rx]]=t >> 24;
			mem[r[rx] + 1]=t >> 16 & 0xff;
			mem[r[rx] + 2]=t >>  8 & 0xff;
			mem[r[rx] + 3]=t       & 0xff;
			if(trace) 
			{
				if (operand>=0) printf("STO (R%d),R%d+%d",rx,ry,operand);
				else printf("STO (R%d),R%d-%d",rx,ry,-operand);
			}
			break;

			case I_STO_3:
			t=r[rx] + operand;
			mem[t]=r[ry] >> 24;
			mem[t + 1]=r[ry] >> 16 & 0xff;
			mem[t + 2]=r[ry] >>  8 & 0xff;
			mem[t + 3]=r[ry]       & 0xff;
			if(trace) 
			{
				if (operand>=0) printf("STO (R%d+%d),R%d",rx,operand,ry);
				else printf("STO (R%d-%d),R%d",rx,-operand,ry);
			}
			break;

			case I_TST_0:
			t=r[rx];
			if(trace) printf("TST R%d",rx);
			if(t==0) r[R_FLAG]=FLAG_EZ;
			else if(t<0) r[R_FLAG]=FLAG_LZ;
			else if(t>0) r[R_FLAG]=FLAG_GZ;
			break;

			case I_JMP_0:
			if(trace) printf("JMP %d",operand);
			r[R_IP]=operand;
			continue;

			case I_JMP_1:
			if(trace) printf("JMP R%d",rx);
			r[R_IP]=r[rx];
			continue;

			case I_JEZ_0:
			if(trace) printf("JEZ %d",operand);
			if(r[R_FLAG]==FLAG_EZ) { r[R_IP]=operand; continue; }
			else break;
			
			case I_JEZ_1:
			if(trace) printf("JEQ R%d",rx);
			if(r[R_FLAG]==FLAG_EZ) { r[R_IP]=r[rx]; continue; }
			else break;

			case I_JLZ_0:
			if(trace) printf("JLZ %d",operand);
			if(r[R_FLAG]==FLAG_LZ) { r[R_IP]=operand; continue; }
			else break;

			case I_JLZ_1:
			if(trace) printf("JLZ R%d",rx);
			if(r[R_FLAG]==FLAG_LZ) { r[R_IP]=r[rx]; continue; }
			else break;

			case I_JGZ_0:
			if(trace) printf("JGZ %d",operand);
			if(r[R_FLAG]==FLAG_GZ) { r[R_IP]=operand; continue; }
			else break;

			case I_JGZ_1:
			if(trace) printf("JGZ R%d",rx);
			if(r[R_FLAG]==FLAG_GZ) { r[R_IP]=r[rx]; continue; }
			else break;

			default:
			printf( "GVM: Invalid Opcode %02x\n", op );
			exit(0);
		}
		
		r[R_IP]=r[R_IP]+8;
	}
}

int main(int argc, char *argv[])
{
	if(argc!=2 && argc!=3){
		printf("Usage: gvm file [-t]\n" );
		exit(10);		
	}

	image_file=(char *)malloc( strlen(argv[1]) + 10 );
	strcpy(image_file,argv[1]);
	strcat(image_file,".gvm");
	
	if(argc == 2) {
		trace=0;
	} else if( strcmp( argv[2], "-t" ) == 0 ) {
			trace=1;
	} else {
		printf("Usage: gvm file [-t]\n" );
		exit(10);
	}

	init();
	run();
	return 0;
}


