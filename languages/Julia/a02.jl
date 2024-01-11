name = "Julia Rapdius"
age = 12

typeof(age)

first(methodswith(Int64), 5)

struct Language
    name::String
    title::String
    year_of_birth::Int64
    fast::Bool
end


fieldnames(Language)

julia = Language("Julia", "Rapidus", 2012, true)

python = Language("Python", "Letargicus", 1991, false)


mutable struct MutableLanguage
    name::String
    title::String
    year_of_birth::Int64
    fast::Bool
end

julia_mutable = MutableLanguage("Julia", "Rapidus", 2012, true)

julia_mutable.title = "Python Obliteratus"


!true
(false && true) || (!false)
# >, <, ==, >=, <=


function add_numbers(arg1, arg2)
    result = arg1 + arg2
    return result
end

add_numbers(arg1, arg2) = arg1 + arg2


function round_number(x::Float64)
    return round(x)
end

function round_number(x::Int64)
    return x
end

round_number(1.54)
round_number(2)

methods(round_number)

function round_number(x::AbstractFloat)
    return round(x)
end


Base.show(io::IO, l::Language) = print(
  io, l.name, " ",
  2021 - l.year_of_birth, ", years old, ",
  "has the following titles: ", l.title
)

function add_multiply(x, y)
    addition = x + y
    multiplication = x * y
    return addition, multiplication
end

r1, r2 = add_multiply(1, 2)


function logarithm(x::Real; base::Real=2.7182818284590)
    return log(base, x)
end

logarithm(2)

logarithm(2; base=3)

map(x -> 2.7182818284590^x, logarithm(2))

function compare(a, b)
    if a < b
        "a is less than b"
    elseif a > b
        "a is greater than b"
    else
        "a is equal to b"
    end
end

compare(3.14, 3.14)


for i in 1:10
    println(i)
end

n = 0
while n < 3
    global n += 1
end

[1, 2, 3] .+ 1

logarithm.([1, 2, 3])


function add_one!(V)
    for i in 1:length(V)
        V[i] += 1
    end
    return nothing
end

my_data = [1, 2, 3]
add_one!(my_data)
my_data


hello = "Hello"
goodbye = "Goodbye"
hello * goodbye

join([hello, goodbye], ", ")

map((x, y, z) -> x^y + z, 2, 3, 1)


my_namedtuple = (i=1, f=3.14, s="Julia")

println(my_namedtuple.s)

i = 1
f = 3.14
s = "Julia"

my_quick_namedtuple = (; i, f, s)

x = 3:10
typeof(x)
length(x)

y = [x for x in 1:10]

collect(1:10)
