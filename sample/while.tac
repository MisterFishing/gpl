label main
begin
var i
i = 1
label L2
var t0
t0 = (i < 10)
ifz t0 goto L3
actual i
call PRINTN
actual L1
call PRINTS
var t1
t1 = i + 1
i = t1
goto L2
label L3
end
