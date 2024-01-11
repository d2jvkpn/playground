using LinearAlgebra, StatsBase

# Transition probability matrix
P = [0.5 0.4 0.1;
     0.3 0.2 0.5;
     0.5 0.3 0.2]

# First way
piProb1 = (P^100)[1,:]
# Second way
A = vcat((P’ - I)[1:2,:],ones(3)’)
b = [0 0 1]’
piProb2 = A\b
# Third way
eigVecs = eigvecs(copy(P’))
highestVec = eigVecs[:,findmax(abs.(eigvals(P)))[2]]
piProb3 = Array{Float64}(highestVec)/norm(highestVec,1)
# Fourth way
numInState = zeros(Int,3)
state = 1

N = 10^6
for t in 1:N
  numInState[state] += 1
  global state = sample(1:3,weights(P[state,:]))
end

piProb4 = numInState/N
display([piProb1 piProb2 piProb3 piProb4])


####
x = [
  1 2 3;
  4 5 6;
  7 8 9;
]

x'
vcat(x, x)
hcat(x, x)

x*2
x^2

diag(x)
ndims(x)
norm(x)


####
using HTTP, JSON

data = HTTP.request(
  "GET",
  "https://ocw.mit.edu/ans7870/6/6.006/s08/lecturenotes/files/t8.shakespeare.txt",
)

shakespeare = String(data.body)
shakespeareWords = split(shakespeare)

jsonWords = HTTP.request("GET",
  "https://raw.githubusercontent.com/"*
  "h-Klok/StatsWithJuliaBook/master/1_chapter/jsonCode.json",
)

parsedJsonDict = JSON.parse(String(jsonWords.body))
keywords = Array{String}(parsedJsonDict["words"])
numberToShow = parsedJsonDict["numToShow"]

wordCount = Dict([
  (x, count(w -> lowercase(w) == lowercase(x), shakespeareWords))
  for x in keywords
])

sortedWordCount = sort(collect(wordCount), by=last, rev=true)
sortedWordCount[1:numberToShow]



using Plots, StatsPlots

N, faces = 10^6, 1:6
numSol = sum([iseven(i+j) for i in faces, j in faces]) / length(faces)^2
mcEst = sum([iseven(rand(faces) + rand(faces)) for i in 1:N]) / N
println("Numerical solution = $numSol \nMonte Carlo estimate = $mcEst")



using Random
Random.seed!()

passLength, numMatchesForLog = 8, 1

possibleChars = ['a':'z'; 'A':'Z'; '0':'9']
correctPassword = "3xyZu4vN"

numMatch(loginPassword) = sum([loginPassword[i] == correctPassword[i] for i in 1:passLength])

N = 10^7
passwords = [String(rand(possibleChars, passLength)) for _ in 1:N]

numLogs = sum([numMatch(p) >= numMatchesForLog for p in passwords])

println("Number of login attempts logged: ", numLogs)
println("Proportion of login attempts logged: ", numLogs/N)


x1 = [
  1 2 3;
  4 5 6;
]

x2 = [
  1 2;
  3 4;
  5 6;
]
