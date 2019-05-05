	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# label main
main:

	# begin

	# var i

	# i = 1
	LOD R5,1

	# label L2
	STO (R2+8),R5
L2:

	# var t0

	# t0 = (i < 10)
	LOD R5,(R2+8)
	LOD R6,10
	SUB R5,R6
	TST R5
	LOD R3,R1+40
	JLZ R3
	LOD R5,0
	LOD R3,R1+24
	JMP R3
	LOD R5,1

	# ifz t0 goto L3
	STO (R2+12),R5
	TST R5
	JEZ L3

	# actual i
	LOD R7,(R2+8)
	STO (R2+16),R7

	# call PRINTN
	STO (R2+20),R2
	LOD R4,R1+32
	STO (R2+24),R4
	LOD R2,R2+20
	JMP PRINTN

	# actual L1
	LOD R5,L1
	STO (R2+16),R5

	# call PRINTS
	STO (R2+20),R2
	LOD R4,R1+32
	STO (R2+24),R4
	LOD R2,R2+20
	JMP PRINTS

	# var t1

	# t1 = i + 1
	LOD R5,(R2+8)
	LOD R6,1
	ADD R5,R6

	# i = t1
	STO (R2+16),R5

	# goto L2
	STO (R2+8),R5
	JMP L2

	# label L3
L3:

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

PRINTN:
	LOD R7,(R2-4) # 789
	LOD R15,R7 # 789 
	DIV R7,10 # 78
	TST R7
	JEZ PRINTDIGIT
	LOD R8,R7 # 78
	MUL R8,10 # 780
	SUB R15,R8 # 9
	STO (R2+8),R15 # local 9 store

	# out 78
	STO (R2+12),R7 # actual 78 push

	# call PRINTN
	STO (R2+16),R2
	LOD R4,R1+32
	STO (R2+20),R4
	LOD R2,R2+16
	JMP PRINTN

	# out 9
	LOD R15,(R2+8) # local 9 

PRINTDIGIT:
	ADD  R15,48
	OUT

	# ret
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

PRINTS:
	LOD R7,(R2-4)

PRINTC:
	LOD R15,(R7)
	DIV R15,16777216
	TST R15
	JEZ PRINTSEND
	OUT
	ADD R7,1
	JMP PRINTC

PRINTSEND:
	# ret
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

EXIT:
	END

L1:
	DBS 10,0
STATIC:
	DBN 0,0
STACK:
