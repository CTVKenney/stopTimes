print(`stoppingplot.mpl`):
print(`A Maple package for exploring stopping times of binary strings,`);
print(`by Robert Dougherty-Bliss and Charles Kenny,`);
print(`which accompanies their article "Stopped Binary Strings."`);
print(`For help, type "ezra();"`):

ezra:=proc()
if args=NULL then
print(`stoppingplot.mpl`):
print(`A Maple package for exploring stopping times of binary strings,`);
print(`by Robert Dougherty-Bliss and Charles Kenny,`);
print(`which accompanies their article "Stopped Binary Strings."`);
print(`For help with a specific procedure, type "ezra(procedure_name);"`):

print(`The main procedures are`);
print(`stoppingTime, plotHeights, gSeq, rSeq`);
print(`stoppedStrings, maximallyStoppedInts, preStoppedInts, stoppedInts, lowerBoundProof`);
fi:

if nops([args])=1 and op(1,[args])=`stoppingTime` then
print(`stoppingTime(L) computes the stopping time of the binary ({0, 1}) list L,`):
print(`assuming that infinitely-many 0's are appended after the final element.`);
print(`Try:`);
print(`stoppingTime([0])`);
print(`stoppingTime([1])`);
print(`stoppingTime([10])`);
print(`stoppingTime([1111111])`);
print(`stoppingTime([11100110000000])`);
fi:

if nops([args])=1 and op(1,[args])=`stoppedStrings` then
print(`stoppedStrings(n, k) computes all binary strings of length n with stopping time k (which defaults to n)`);
print(`Try:`);
print(`stoppedStrings(5, 5)`);
fi:

if nops([args])=1 and op(1,[args])=`maximallyStoppedInts` then
print(`maximallyStoppedInts(n) computes the first n maximally stopped integers.`);
print(`Try:`);
print(`maximallyStoppedInts(10)`);
fi:

if nops([args])=1 and op(1,[args])=`preStoppedInts` then
print(`preStoppedInts(n) computes the first n prestopped integers.`);
print(`Try:`);
print(`preStoppedInts(10)`);
fi:

if nops([args])=1 and op(1,[args])=`stoppedInts` then
print(`stoppedInts(n) computes the first n stopped integers.`);
print(`Try:`);
print(`stoppedInts(10)`);
fi:

if nops([args])=1 and op(1,[args])=`plotHeights` then
print(`plotHeights(n) outputs a pointplot of 2^n evenly-spaced points in [0, 1),`);
print(`where the height of a point is the stopping time of the string.`);
print(`Try:`);
print(`plotHeights(10)`);
fi:

if nops([args])=1 and op(1,[args])=`gSeq` then
print(`gSeq(b, n) computes the number of stopped base-b strings of length n.`);
print(`Note that g(b, n) is zero for odd n > 1.`);
print(`Try:`);
print(`gSeq(2, 100)`);
fi:

if nops([args])=1 and op(1,[args])=`rSeq` then
print(`rSeq(b, n) computes the number of stopped base-b strings of length 2*n.`);
print(`Shorthand for g(b, 2 * n).`);
print(`Try:`);
print(`rSeq(2, 50)`);
fi:

if nops([args])=1 and op(1,[args])=`lowerBoundProof` then
print(`lowerBoundProof(b) generates a proof that r(b, n) / b^n converges to a positive constant,`);
print(`where r(b, n) is the number of base-b strings of length 2n with stopping time 2n.`);
print(`Try:`);
print(`lowerBoundProof(10)`);
fi:
end:

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
    local j, stopped, zeroCount, digit:
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
plotHeights:=proc(n) local i, L, str, allStrings:
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

# Compute the first n maximally stopped integers.
maximallyStoppedInts := n -> computeTerms(isMaximallyStopped, n):

# Compute the first n prestopped integers.
preStoppedInts := n -> computeTerms(isPreStopped, n):

# Compute the first n stopped integers.
stoppedInts := n -> computeTerms(isStopped, n):

a := proc(n) option remember:
    if n = 1 or n = 2 then
        return 1:
    fi:

    if n mod 2 = 0 then
       return 2 * a(n - 1):
    fi:

    return 2 * a(n - 1) - a((n - 1) / 2):
end:

gSeq := proc(b, n) option remember:
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
        return b * gSeq(b, n - 2):
    fi:

    if n mod 4 = 2 then
        return b * gSeq(b, n - 2) - (b - 1) * gSeq(b, (n - 2) / 2):
    fi:

    return 0:
end:

rSeq := (b, n) -> gSeq(b, 2 * n):

lowerBoundProof:=proc(b)
    local start, c0, C0, N, lhs, rhs:
    start := time():
    c0 := 0:
    N := 1:

    while evalf(c0) <= 10^(-5) do
        N := N + 1:
        C0 := (b - 1) * rSeq(b, N) / b^N / (b - sqrt(b)):
        c0 := (rSeq(b, 2 * N) / b^(2 * N) - C0 / b^N):
    od:

    print(`THEOREM. The sequence`, r(b, n) / b^n, `with numerator`, r(b, n), `defined by the recurrence`):
    print(r(b, 1) = (b - 1));
    print(r(b, 2) = (b - 1)^2);
    print(r(b, 2 * n) = b * r(b, 2 * n - 1));
    print(r(b, 2 * n + 1) = b * r(b, 2 * n) - (b - 1) * r(b, n));
    print(`converges to a positive constant`, c(b), `which is approximately equal to`, evalf(rSeq(b, 1000) / b^1000)):
    print(`PROOF. The sequence`, r(b, n) / b^n, `is obviously monotonically decreasing, so it will suffice to provide a positive lower bound for it.`):
    print(`We will instead prove the STRONGER claim, that`):
    print(r(b, n) / b^n >= c + C / b^n):
    print(`for all integers`, n >= 2 * N):
    print(`Where`, c = c0, C = C0):
    print(`These constants are approximately`, c = evalf(c0), C = evalf(C0)):

    print(`To check, note that`, r(b, 1000) / b^1000 = evalf(rSeq(b, 1000) / b^1000));
    print(`While`, c = evalf(c0));
    if evalf(rSeq(b, 1000) / b^1000) < evalf(c0) then
        print(`Something is wrong!`);
        return:
    fi:

    print(`The base case`, n = 2 * N, `is easy to verify:`):
    lhs := r(b, 2 * N) / b^(2 * N) - c - C / b^N:
    rhs := rSeq(b, 2 * N) / b^(2 * N) - c0 - C0 / b^N:
    print(lhs = evalf(rhs));

    print();

    print(`Suppose that the result holds for`, n = 2 * k - 1, `greater than or equal to`, 2 * N);
    print(`Then, by the defining recurrence, we have`);
    print(r(b, 2 * k) / b^(2 * k) = r(b, 2 * k - 1) / b^(2 * k - 1));
    print(`and the induction hypothesis immediately implies`);
    print(r(b, 2 * k - 1) / b^(2 * k - 1) >= c + C / b^k);

    print();

    print(`Now suppose that the result holds for`, n = 2 * k, `greater than or equal to`, 2 * N);
    print(`Then, by the defining recurrence, we have`);
    print(r(b, 2 * k + 1) / b^(2 * k + 1) = r(b, 2 * k) / b^(2 * k) - r(b, k) / b^(2 * k + 1));
    print(`The induction hypothesis implies`);
    print(r(b, 2 * k + 1) / b^(2 * k + 1) >= c + C / b^k - r(b, k) / b^(2 * k + 1));
    print(`so we would be done if we could establish`);
    print(C / b^k - r(b, k) / b^(2 * k + 1) >= C / b^(k + 1 / 2));
    print(`or, equivalently,`);
    print(r(b, k) / b^k <= (b - sqrt(b)) * C);
    print(`But this is obvious, because`, r(b, n) / b^n, `is monotonically decreasing,`);
    print(`and we have`, k >= N, `which implies`, r(b, k) / b^k <= r(b, N) / b^N);
    print(`And it just so happens that`, r(b, N) / b^N = (b - sqrt(b)) * C);
    print(`in fact, their quotient is`, rSeq(b, N) / b^N / (b - sqrt(b)) / C0);

    print(`We have proven that EVEN implies ODD and ODD implies EVEN for all`, n >= 2 * N);
    print(`and the EVEN base case of`, n = 2 * N, `was easy to establish.`);
    print(`Therefore, by induction, the result holds for all`, n >= 2 * N);
    print(`Q.E.D.`);
    print(`The whole thing took`, time() - start, `seconds`);
end:
