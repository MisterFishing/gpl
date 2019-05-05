var i
var j
var k
label main
begin
var l
var m
var n
l = 1
m = 2
n = 3
actual l
call PRINTN
actual m
call PRINTN
actual n
call PRINTN
var t0
actual n
actual m
actual l
t0 = call func
n = t0
actual i
call PRINTN
actual j
call PRINTN
actual k
call PRINTN
actual n
call PRINTN
actual L1
call PRINTS
end
label func
begin
formal o
formal p
formal q
actual o
call PRINTN
actual p
call PRINTN
actual q
call PRINTN
i = o
j = p
k = q
actual i
call PRINTN
actual j
call PRINTN
actual k
call PRINTN
return 999
end
