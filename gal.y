%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include "is.h"

#define LABNUM 100
#define REGNUM 16

typedef struct keyword
{
	int id;
	char name[100];
} KEYWORD;

typedef struct label
{
	int addr;
	char *name;
} LABEL;

%}

%union
{
	int num;
}

%token ADD
%token SUB
%token MUL
%token DIV
%token TST
%token STO
%token LOD
%token JMP
%token JEZ
%token JLZ
%token JGZ
%token DBN
%token DBS
%token OUT
%token NOP
%token END
%token <num> INTEGER REG LABLE

%{
void p1b(int  n);
void p2b(int  n);
void p4b(int n);

FILE *input, *output;
int  pass;
int  pc;
int  n;
int  line=1;
char character=' ';
char token[1000];
LABEL lab[LABNUM];
char reg[REGNUM][4]=
{
	{"R0"},
	{"R1"},
	{"R2"},
	{"R3"},
	{"R4"},
	{"R5"},
	{"R6"},
	{"R7"},
	{"R8"},
	{"R9"},
	{"R10"},
	{"R11"},
	{"R12"},
	{"R13"},
	{"R14"},
	{"R15"}
};
KEYWORD keywords[100]= 
{
	{ADD,"ADD"},
	{SUB,"SUB"},
	{MUL,"MUL"},
	{DIV,"DIV"},
	{TST,"TST"},
	{STO,"STO"},
	{LOD,"LOD"},
	{JMP,"JMP"},
	{JEZ,"JEZ"},
	{JLZ,"JLZ"},
	{JGZ,"JGZ"},
	{DBN,"DBN"},
	{DBS,"DBS"},
	{OUT,"OUT"},
	{NOP,"NOP"},
	{END,"END"},
	{0,""}
};	

%}

%%

start : program
;

program : program statement '\n'
| program '\n'
|
;

statement : nop_stmt
| add_stmt
| sub_stmt
| mul_stmt
| div_stmt
| tst_stmt
| lab_stmt
| jmp_stmt
| jez_stmt
| jlz_stmt
| jgz_stmt
| lod_stmt
| sto_stmt
| out_stmt
| end_stmt
| dbn_stmt
| dbs_stmt
;

nop_stmt : NOP	{ p2b(I_NOP); p1b(0); p1b(0); p4b(0);}
;

add_stmt : ADD REG ',' INTEGER
{
	p2b(I_ADD_0) ;
	p1b($2);
	p1b(0);
	p4b($4);
}
| ADD REG ',' LABLE
{
	p2b(I_ADD_0);
	p1b($2);
	p1b(0);
	p4b(lab[$4].addr);
}
| ADD REG ',' REG
{
	p2b(I_ADD_1);
	p1b($2);
	p1b($4);
	p4b(0);
}
;

sub_stmt : SUB REG ',' INTEGER
{
	p2b(I_SUB_0) ;
	p1b($2);
	p1b(0);
	p4b($4);
}
| SUB REG ',' LABLE
{
	p2b(I_SUB_0);
	p1b($2);
	p1b(0);
	p4b(lab[$4].addr);
}
| SUB REG ',' REG
{
	p2b(I_SUB_1);
	p1b($2);
	p1b($4);
	p4b(0);
}
;

mul_stmt : MUL REG ',' INTEGER
{
	p2b(I_MUL_0) ;
	p1b($2);
	p1b(0);
	p4b($4);
}
| MUL REG ',' LABLE
{
	p2b(I_MUL_0);
	p1b($2);
	p1b(0);
	p4b(lab[$4].addr);
}
| MUL REG ',' REG
{
	p2b(I_MUL_1);
	p1b($2);
	p1b($4);
	p4b(0);
}
;

div_stmt : DIV REG ',' INTEGER
{
	p2b(I_DIV_0) ;
	p1b($2);
	p1b(0);
	p4b($4);
}
| DIV REG ',' LABLE
{
	p2b(I_DIV_0);
	p1b($2);
	p1b(0);
	p4b(lab[$4].addr);
}
| DIV REG ',' REG
{
	p2b(I_DIV_1);
	p1b($2);
	p1b($4);
	p4b(0);
}
;

tst_stmt : TST REG
{
	p2b(I_TST_0) ;
	p1b($2);
	p1b(0);
	p4b(0);
}
;

lab_stmt : LABLE ':'
{
	if(pass==1)
	{
		if(lab[$1].addr==0)
		{
			lab[$1].addr=pc;
		}
		else
		{
			printf("error: lable %s already exist\n", lab[$1].name);
			exit(0);
		}
	}
}
;

jmp_stmt : JMP LABLE
{
	p2b(I_JMP_0);
	p1b(0);
	p1b(0);
	p4b(lab[$2].addr);
}
| JMP REG
{
	p2b(I_JMP_1);
	p1b($2);		
	p1b(0);	
	p4b(0);				
}
;

jez_stmt : JEZ LABLE
{
	p2b(I_JEZ_0);
	p1b(0);
	p1b(0);
	p4b(lab[$2].addr);
}
| JEZ REG
{
	p2b(I_JEZ_1) ;
	p1b($2);		
	p1b(0);	
	p4b(0);	
}
;

jlz_stmt : JLZ LABLE
{
	p2b(I_JLZ_0);
	p1b(0);
	p1b(0);
	p4b(lab[$2].addr);
}
| JLZ REG
{
	p2b(I_JLZ_1) ;
	p1b( $2 ) ;		
	p1b(0);	
	p4b(0);	
}
;

jgz_stmt : JGZ LABLE
{
	p2b(I_JGZ_0);
	p1b(0);
	p1b(0);
	p4b(lab[$2].addr);
}
| JGZ REG
{
	p2b(I_JGZ_1) ;
	p1b( $2 ) ;		
	p1b(0);	
	p4b(0);	
}
;			

lod_stmt : LOD REG ',' INTEGER
{
	p2b(I_LOD_0) ;
	p1b($2);
	p1b(0);
	p4b($4);
}
| LOD REG ',' LABLE
{
	p2b(I_LOD_0);
	p1b($2);
	p1b(0);
	p4b(lab[$4].addr);
}
| LOD REG ',' REG
{
	p2b(I_LOD_1);
	p1b($2);
	p1b($4);
	p4b(0);
}
| LOD REG ',' REG '+' INTEGER
{
	p2b(I_LOD_2);
	p1b($2);
	p1b($4);
	p4b($6);
}
| LOD REG ',' REG '-' INTEGER
{
	p2b(I_LOD_2);
	p1b($2);
	p1b($4);
	p4b(-($6));
}
| LOD REG ',' '(' INTEGER ')'
{
	p2b(I_LOD_3);
	p1b($2);
	p1b(0);
	p4b($5);
}
| LOD REG ',' '(' LABLE ')'
{
	p2b(I_LOD_3);
	p1b($2);
	p1b(0);
	p4b(lab[$5].addr);
}
| LOD REG ',' '(' REG ')'
{
	p2b(I_LOD_4);
	p1b($2);
	p1b($5);
	p4b(0);
}
| LOD REG ',' '(' REG '+' INTEGER ')'
{
	p2b(I_LOD_5);
	p1b($2);
	p1b($5);
	p4b($7);
}
| LOD REG ',' '(' REG '-' INTEGER ')'
{
	p2b(I_LOD_5);
	p1b($2);
	p1b($5);
	p4b(-($7));
}
;

sto_stmt : STO '(' REG ')' ',' INTEGER
{
	p2b(I_STO_0);
	p1b($3);
	p1b(0);
	p4b($6);
}
| STO '(' REG ')' ',' LABLE
{
	p2b(I_STO_0);
	p1b($3);
	p1b(0);
	p4b(lab[$6].addr);
}
| STO '(' REG ')' ',' REG
{
	p2b( I_STO_1 ) ;
	p1b($3);
	p1b($6);
	p4b(0);
}
| STO '(' REG ')' ',' REG '+' INTEGER
{
	p2b( I_STO_2 ) ;
	p1b($3);
	p1b($6);
	p4b($8);
}
| STO '(' REG ')' ',' REG '-' INTEGER
{
	p2b( I_STO_2 ) ;
	p1b($3);
	p1b($6);
	p4b(-($8));
}
| STO '(' REG '+' INTEGER ')' ',' REG
{
	p2b( I_STO_3 ) ;
	p1b($3);
	p1b($8);
	p4b($5);
}
| STO '(' REG '-' INTEGER ')' ',' REG
{
	p2b( I_STO_3 ) ;
	p1b($3);
	p1b($8);
	p4b(-($5));
}
;

out_stmt : OUT { p2b(I_OUT); p1b(0); p1b(0); p4b(0);}
;

end_stmt : END { p2b(I_END); p1b(0); p1b(0); p4b(0);}
;

dbn_stmt : DBN INTEGER ',' INTEGER
{
	n = $4;
	while(n-- > 0)
	p1b($2) ;
}
;

dbs_stmt : dbs_stmt ',' INTEGER { p1b($3); }
| DBS INTEGER { p1b($2); }
;

%%

int main(int  argc, char *argv[])
{
	char *input_file ;
	char *output_file ;

	input_file=(char *)malloc(strlen(argv[1])+10);
	strcpy(input_file,argv[1]);
	strcat(input_file,".gal");
	
	if((input=fopen(input_file,"r"))==NULL)
	{
		printf( "open input file %s failed\n", input_file ) ;
		exit(0);
	}
	
	output_file=(char *)malloc(strlen(argv[1])+10);
	strcpy(output_file,argv[1]);
	strcat(output_file,".gvm");
											   
	if((output=fopen(output_file,"w"))==NULL)
	{
		printf( "open output file %s failed\n", output_file ) ;
		exit(0);
	}

	int i=sizeof(lab);
	bzero(lab, i);

	/* First pass sets up labels */
	pc=0;
	pass=1;
	yyparse();

	/* Second pass generates code */
	rewind(input) ;
	pc=0;
	pass=2;
	yyparse();

	return 0;
}	/* int   main( int argc, char *argv[]) */

int yyerror(char *str)
{
	printf("yyerror: %s at line %d\n", str, line);
	return 0;
}

void p1b(int  n)
{
	if(pass==2)
		putc(n,output);
	pc++;
}

void p2b(int  n)
{
	if(pass==2)
	{
		putc(n>>8,output);
		putc(n,output);
	}
	pc+=2;
}	

void p4b(int n)
{
	if(pass==2)
	{
		putc(n>>24,output);
		putc(n>>16,output);
		putc(n>>8,output);
		putc(n,output);
	}
	pc+=4;
}

void getch()
{
	character=getc(input);
	if(character=='#') 
	{
		while(1)
		{
			character=getc(input);
			if(character=='\n' || character==EOF) break;
		}
	}
	if(character=='\n') line++;
}

void concat()
{
	int len=strlen(token);
	token[len]=character;
	token[len+1]='\0';	
}

int letter()
{
	if(((character>='a') && (character<='z')) || ((character>='A') && (character<='Z')))
		return 1;
	else 
		return 0;
}

int digit()
{
	if((character>='0') && (character<='9'))
		return 1;
	else 
		return 0;
}

void retract()
{
	ungetc(character,input);
	character='\0';
}

int find_reg()
{
	int i=0;
	while(i < REGNUM)
	{
		if(!strcmp(reg[i],token)) 
			return i;
		i++;
	}
	return -1;
}

int find_keyword()
{
	int i=0;
	while(keywords[i].id != 0)
	{
		if(!strcmp(keywords[i].name,token)) 
			return keywords[i].id;
		i++;
	}
	return -1;
}

int find_label(char * token)
{
	int i=0;
	char *label=strdup(token);

	while(lab[i].name != NULL)
	{
		if(!strcmp(lab[i].name,label)) 
			return i;
		i++;
	}

	if(i>=LABNUM)
	{
		printf("error: label num > %d\n", LABNUM);
		exit(0);
	}

	lab[i].name=label;
	return i;
}

int yylex()
{
	int num;
	strcpy(token,"");
	character=' ';
	while( (character==' ') || (character=='\t') || (character=='\r') ) 
		getch();

	if(letter())
	{
		while(letter() || digit())
		{
			concat();
			getch();
		}
		retract();
		num=find_keyword();
		if(num!=-1)
		{
			return num; // keyword
		}
		else
		{
			num=find_reg();
			if(num!=-1)
			{
				yylval.num=num;
				return REG; // register
			}
			
			yylval.num=find_label(token);
			return LABLE; // label
		}
	}

	if(digit())
	{
		while(digit())
		{
			concat();
			getch();
		}
		retract();
		yylval.num=atoi(token);
		return INTEGER;	
	}

	return character;
}

