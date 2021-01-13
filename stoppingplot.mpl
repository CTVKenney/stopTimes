with(plots):
#Inputs str, a string [0,1,0,0,1,1,1,0,1,1]
#of 0s and 1s, and outputs the stopping time of this string, assuming infinitely-many 0s after the string elements.
stoppingTime:=proc(str) local oCount, tim, dig, stopped:
oCount:=0:
tim:=0:
stopped:=0:
while stopped < 1 do
tim:=tim+1:
	if tim <= nops(str) then
		dig:=str[tim]:
	else
		dig:=0:
	fi:

	if dig=0 then
		oCount:=oCount+1:
	else
		oCount:=0:
	fi:

	if oCount >= ceil(tim/2) then
		stopped:=1:
	fi:
od:
tim:
end:

# Generate all binary strings ({0, 1}-lists) of length n.
binaryStrings := proc(n)
    local allStrings, i, str:
    allStrings := [[]]:
    for i from 1 to n do
        allStrings:=[seq([op(str),0],str in allStrings),seq([op(str),1],str in allStrings)]:
    od:

    allStrings:
end:

# Generate all binary strings of length n with stopping time k (defaults to n).
stoppedStrings := proc(n, k := n)
    select(s -> stoppingTime(s) = k, binaryStrings(n)):
end:

#A recursive program to generate all lists of stopped strings of length less than or equal to n, for n an even positive integer
#Outputs a list of length g(n) containing all the strings of length n with stopping time n
recStoppedStrings:=proc(n) local L,l,i,j,new:
L:=[[[0]],[[1,0]],[[1,1,0,0]]]:
for i from 3 to n/2+1 do
	if type(i, even) then
		L:=[op(L), [seq([op(1..i-2,l),1,op(i-1..2*i-2,l),0],l in L[i]), seq([op(1..i-2,l),0,op(i-1..2*i-2,l),0],l in L[i])]]:
	else
		new:=[]:
		for l in L[i] do
			if member([op(1..i-2,l),0],L[(i+1)/2]) then
				new:=[op(new),[op(1..i-2,l),1,op(i-1..2*i-2,l),0]]:
			else
				new:=[op(new),[op(1..i-2,l),1,op(i-1..2*i-2,l),0],[op(1..i-2,l),0,op(i-1..2*i-2,l),0]]:
			fi:
		od:

		L:=[op(L),new]:
	fi:
od:
L:
end:

#Inputs n, outputs list [(x_1,y_1), (x_2,y_2), ...] of points to plot, where
#the x's consist of 2^n evenly spaced binary points in [0,1), and
#y's give the stopping time of the binary sequence associated to the x's. 
plotheights:=proc(n) local i, L, str, allStrings:
    allStrings := binaryStrings(n):
    L:=[seq([add(str[i]*2^(-i),i=1..n),stoppingTime(str)],str in allStrings )]:
    pointplot(L,symbol=point):
end:

# Generate the average point of all length n strings with stopping time n.
avgPositions:=proc(n) option remember:
    local stopped:
    stopped := stoppedStrings(n):
    add(stopped) / nops(stopped):
end:

# Generate the average point of all length n strings with stopping time n (n even, >3 say; using recursive algo for stopped strings)
recAvgPositions:=proc(n) local l,L,m,j:
L:=recStoppedStrings(n)[(n/2)+1]: #The strings of length n stopped at time n
m:=nops(L):
print([seq(evalf(add(l[j],l in L)/m),j=1..n/2 -1, 2)], [seq(evalf(add(l[j],l in L)/m),j=2..n/2-1,2)]):
listplot([seq(add(l[j],l in L)/m,j=1..n/2 -1, 2)]), listplot([seq(add(l[j],l in L)/m,j=2..n/2-1,2)]):
end:
