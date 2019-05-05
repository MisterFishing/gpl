	# head
	LOD R2,STACK
	STO (R2),0
	LOD R4,EXIT
	STO (R2+4),R4

	# var i

	# var j

	# var k

	# label main
main:

	# begin

	# var l

	# var m

	# var n

	# l = 1
	LOD R5,1

	# m = 2
	LOD R6,2

	# n = 3
	LOD R7,3

	# actual l
	STO (R2+8),R5
	STO (R2+20),R5

	# call PRINTN
	STO (R2+12),R6
	STO (R2+16),R7
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTN

	# actual m
	LOD R5,(R2+12)
	STO (R2+20),R5

	# call PRINTN
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTN

	# actual n
	LOD R5,(R2+16)
	STO (R2+20),R5

	# call PRINTN
	STO (R2+24),R2
	LOD R4,R1+32
	STO (R2+28),R4
	LOD R2,R2+24
	JMP PRINTN

	# var t0

	# actual n
	LOD R5,(R2+16)
	STO (R2+24),R5

	# actual m
	LOD R6,(R2+12)
	STO (R2+28),R6

	# actual l
	LOD R7,(R2+8)
	STO (R2+32),R7

	# t0 = call func
	STO (R2+36),R2
	LOD R4,R1+32
	STO (R2+40),R4
	LOD R2,R2+36
	JMP func

	# n = t0
	LOD R5,R4

	# actual i
	LOD R4,STATIC
	LOD R6,(R4+0)
	STO (R2+24),R6

	# call PRINTN
	STO (R2+16),R5
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual j
	LOD R4,STATIC
	LOD R5,(R4+4)
	STO (R2+24),R5

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual k
	LOD R4,STATIC
	LOD R5,(R4+8)
	STO (R2+24),R5

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual n
	LOD R5,(R2+16)
	STO (R2+24),R5

	# call PRINTN
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTN

	# actual L1
	LOD R5,L1
	STO (R2+24),R5

	# call PRINTS
	STO (R2+28),R2
	LOD R4,R1+32
	STO (R2+32),R4
	LOD R2,R2+28
	JMP PRINTS

	# end
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

	# label func
func:

	# begin

	# formal o

	# formal p

	# formal q

	# actual o
	LOD R5,(R2-4)
	STO (R2+8),R5

	# call PRINTN
	STO (R2+12),R2
	LOD R4,R1+32
	STO (R2+16),R4
	LOD R2,R2+12
	JMP PRINTN

	# actual p
	LOD R5,(R2-8)
	STO (R2+8),R5

	# call PRINTN
	STO (R2+12),R2
	LOD R4,R1+32
	STO (R2+16),R4
	LOD R2,R2+12
	JMP PRINTN

	# actual q
	LOD R5,(R2-12)
	STO (R2+8),R5

	# call PRINTN
	STO (R2+12),R2
	LOD R4,R1+32
	STO (R2+16),R4
	LOD R2,R2+12
	JMP PRINTN

	# i = o
	LOD R5,(R2-4)

	# j = p
	LOD R6,(R2-8)

	# k = q
	LOD R7,(R2-12)

	# actual i
	LOD R4,STATIC
	STO (R4+0),R5
	STO (R2+8),R5

	# call PRINTN
	LOD R4,STATIC
	STO (R4+4),R6
	LOD R4,STATIC
	STO (R4+8),R7
	STO (R2+12),R2
	LOD R4,R1+32
	STO (R2+16),R4
	LOD R2,R2+12
	JMP PRINTN

	# actual j
	LOD R4,STATIC
	LOD R5,(R4+4)
	STO (R2+8),R5

	# call PRINTN
	STO (R2+12),R2
	LOD R4,R1+32
	STO (R2+16),R4
	LOD R2,R2+12
	JMP PRINTN

	# actual k
	LOD R4,STATIC
	LOD R5,(R4+8)
	STO (R2+8),R5

	# call PRINTN
	STO (R2+12),R2
	LOD R4,R1+32
	STO (R2+16),R4
	LOD R2,R2+12
	JMP PRINTN

	# return 999
	LOD R4,999
	LOD R3,(R2+4)
	LOD R2,(R2)
	JMP R3

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
	DBN 0,12
STACK:
