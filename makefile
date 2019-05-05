all: gpl gal gvm

gpl: gpl.y
	yacc -o gpl.c gpl.y
	gcc -g3 gpl.c -o gpl

gal: gal.y
	yacc -o gal.c gal.y
	gcc -g3 gal.c -o gal

gvm: gvm.c
	gcc -g3 gvm.c -o gvm

