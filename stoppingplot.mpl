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

# Generate all base-b strings ({0, 1, ..., b - 1}-lists) of length n.
baseStrings := proc(b, n)
    local allStrings, i, str, d:
    allStrings := [[]]:
    for i from 1 to n do
        allStrings:=[seq(seq([op(str), d], str in allStrings), d=0..b-1)]:
    od:

    allStrings:
end:

# Generate all binary strings of length n with stopping time k (defaults to n).
stoppedStrings := proc(n, k := n)
    select(s -> stoppingTime(s) = k, binaryStrings(n)):
end:

# Generate all base-b strings of length n with stopping time k (defaults to n).
stoppedBaseStrings := proc(b, n, k := n)
    select(s -> stoppingTime(s) = k, baseStrings(b, n)):
end:

#A recursive program to generate all lists of stopped strings of length less than or equal to n, for n an even positive integer
#Outputs a list L, with (for i>1) L[i] containing a list of all strings of length 2*i-2 having stopping time 2*i-2.
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

# Compute the smallest T such that s[j] = 0 for all j in (T - T / k, T],
# assuming that s is the prefix of an infinitely long string of 0's.
KStoppingTime := proc(s, k)
    j := 0:
    stopped := false:
    zeroCount := 0:

    while not stopped do
        j := j + 1:
        if j > nops(s) then
            digit := 0:
        else
            digit := s[j]:
        fi:

        if digit = 0 then
            zeroCount := zeroCount + 1:
        else
            zeroCount := 0:
        fi:

        # Length of interval (j - j / k, j] is
        # j - floor(j - j / k) = -floor(-j / k)
        #                      = ceil(j / k).
        if zeroCount >= ceil(j / k) then
            stopped := true:
        fi:
    od:

    j:
end:

# Generate all base-b strings of length L with k-stopping time n.
KStoppedBaseStrings:=proc(b, k, n)
    select(s -> KStoppingTime(s, k) = n, baseStrings(b, n)):
end:

# Generate all base-b strings of length L with k-stopping time n.
countKStoppedBaseStrings:=proc(b, k, n)
    option remember:
    nops(KStoppedBaseStrings(b, k, n)):
end:

#Inputs n, outputs list [(x_1,y_1), (x_2,y_2), ...] of points to plot, where
#the x's consist of 2^n evenly spaced binary points in [0,1), and
#y's give the stopping time of the binary sequence associated to the x's. 
plotheights:=proc(n) local i, L, str, allStrings:
    allStrings := binaryStrings(n):
    L:=[seq([add(str[i]*2^(-i),i=1..n),stoppingTime(str)],str in allStrings )]:
    pointplot(L,symbol=point):
end:

#Inputs n, outputs list [(x_1,y_1), (x_2,y_2), ...] of points to plot, where
#the x's consist of b^n evenly spaced b-ary points in [0,1), and
#y's give the stopping time of the b-ary sequence associated to the x's. 
plotBaseHeights:=proc(b, c, n) local i, L, str, allStrings:
    allStrings := baseStrings(b, n):
    L:=[seq([add(str[i]*b^(-i),i=1..n),stoppingTime(str)],str in allStrings )]:
    pointplot(L,symbol=point, color=c):
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
[seq(evalf(add(l[j],l in L)/m),j=1..n/2 -1)]:
end:

isStopped := proc(n)
    local digits:
    digits := ListTools[Reverse](convert(n, base, 2)):
    return evalb(stoppingTime(digits) <= nops(digits)):
end:

isMaximallyStopped := proc(n)
    local digits:
    digits := ListTools[Reverse](convert(n, base, 2)):
    return evalb(stoppingTime(digits) = nops(digits)):
end:

isPreStopped := proc(n)
    local digits:
    digits := ListTools[Reverse](convert(n, base, 2)):
    return evalb(stoppingTime(digits) = 2 * nops(digits)):
end:

# Select the first n positive integers k such that f(k) is true.
# (Assuming that there *are* n such positive integers!)
computeTerms := proc(f, n)
    local terms, k:
    terms := []:
    k := 1:

    while nops(terms) < n do
        if f(k) then
            terms := [op(terms), k]:
        fi:

        k := k + 1:
    od:

    terms:
end:

# Select the positive integers k <= n such that f(k) is true.
piTerms := proc(f, n) local k:
    select(f, [seq(k, k=1..n)]):
end:

# Compute the first n maximally stopped integers.
maximallyStopped := n -> computeTerms(isMaximallyStopped, n):

piMaximallyStopped := n -> piTerms(isMaximallyStopped, n):

# Compute the first n maximally stopped integers.
piPreStopped := n -> piTerms(isPreStopped, n):

# Compute the first n prestopped integers.
preStopped := n -> computeTerms(isPreStopped, n):

# Compute the first n stopped integers.
preStopped := n -> computeTerms(isStopped, n):

a := proc(n) option remember:
    if n = 1 or n = 2 then
        return 1:
    fi:

    if n mod 2 = 0 then
       return 2 * a(n - 1):
    fi:

    return 2 * a(n - 1) - a((n - 1) / 2):
end:

g := proc(b, n) option remember:
    if n = 1 then
        return 1:
    fi:

    if n = 2 then
        return b - 1:
    fi:

    if n = 4 then
        return (b - 1)^2:
    fi:

    if n mod 4 = 0 then
        return b * g(b, n - 2):
    fi:

    if n mod 4 = 2 then
        return b * g(b, n - 2) - (b - 1) * g(b, (n - 2) / 2):
    fi:

    return 0:
end:

s := proc(b, n) local k:
add(g(b, k) / b^k, k=1..n):
end:

s := (b, n) -> add(g(b, k) / b^k, k=1..n):
sf := (b, n) -> add(evalf(g(b, k) / b^k), k=1..n):
