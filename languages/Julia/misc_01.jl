nums = [i^2 for i in 1:10]
sum(nums)
reduce(+, nums)
mean(nums)

sqrt.(nums)


using Statistics

@time begin
  data = Float64[]

  for _ in 1:10^6
    group = Float64[]

    for _ in 1:5*10^2
      push!(group, rand())
    end

    push!(data,mean(group))
  end

  println(
    "98% of the means lie in the estimated range: ",
    (quantile(data,0.01), quantile(data,0.99)),
  )
end


rand(100, 1)
rand(100, 3)

rand(100, 1, 2)



function bubbleSort!(a)
  n = length(a)
  for i in 1:n-1
    for j in 1:n-i
      if a[j] > a[j+1]
        a[j], a[j+1] = a[j+1], a[j]
      end
    end
  end
  return a
end

data = [65, 51, 32, 12, 23, 84, 68, 1]
bubbleSort!(data)


f(x) = -10x^2 + 3x + 1

f.(data)

using Roots

methods(find_zeros)

using Roots

function polynomialGenerator(a...)
  n = length(a)-1
  poly = function(x)
    return sum([a[i+1]*x^i for i in 0:n])
  end
  return poly
end

polynomial = polynomialGenerator(1, 3, -10)
zeroVals = find_zeros(polynomial, -10, 10)

println("Zeros of the function f(x): ", zeroVals)
