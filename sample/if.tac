label main
begin
var i
var j
i = 123
j = 222
var t0
t0 = (i != j)
ifz t0 goto L3
actual i
call PRINTN
actual L1
call PRINTS
actual j
call PRINTN
goto L4
label L3
actual i
call PRINTN
actual L2
call PRINTS
actual j
call PRINTN
label L4
i = 999
actual L5
call PRINTS
actual i
call PRINTN
actual L5
call PRINTS
end
