using DataFrames, Query, CategoricalArrays
import CSV

df = DataFrame(A=1:4, B=["M", "F", "M", "F"])

df.A
df."B"

df.A === df[:, :A]
df.A === df[!, :A]

df.A === df[!, "A"]

firstcolumn = :A
df[:, firstcolumn]

names(df)

size(df)

size(df, 1)




df = DataFrame(A = Int[], B = String[])
push!(df, (1, "M"))

push!(df, [2, "N"])
df



df = DataFrame(a=[1, 2, 3], b=[:a, :b, :c])
# write DataFrame out to CSV file
CSV.write("dataframe.csv", df)

CSV.write("dataframe.tsv", df; delim="\t")



using CategoricalArrays
df = DataFrame(a = 1:2, b = [1.0, missing], c = categorical('a':'b'), d = [1//2, missing])


df = df |> @map({A=_.A + 1, _.B}) |> DataFrame



v = [(a=1, b=2), (a=3, b=4)]
df = DataFrame(v)


df = DataFrame(A = 1:2:1000, B = repeat(1:10, inner=50), C = 1:500)
first(df, 6)
laste(df, 6)
show(df, allcols=true)


df = DataFrame(x1=1, x2=2, y=3)
df[!, Not(:x1, :x2)]


df[:, Cols(r"x1", :)]

df[:, Not(Cols(r"x1", r"x2"))]

df[:, Not(["x1", "x2"])]


df[:, Cols(Not(r"x1"), :)]


df = DataFrame(A = 1:2:1000, B = repeat(1:10, inner=50), C = 1:500)
df[df.A .> 500, :]

df[(df.A .> 500) .& (300 .< df.C .< 400), :]
 
 
df[in.(df.A, Ref([1, 5, 601])), :]



df = DataFrame(x1=[1, 2], x2=[3, 4], y=[5, 6])
select(df, Not(:x1))

select(df, r"x")

select(df, :x1 => :a1, :x2 => :a2)

select(df, :x1, :x2 => (x -> x .- minimum(x)) => :x2)

describe(df)
