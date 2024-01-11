latticePaths(n) = factorial(2big(n))/factorial(big(n))^2

latticePaths2(n) = reduce(*, [big(i) for i in 2n:-1:(n+1)])/factorial(big(n))
