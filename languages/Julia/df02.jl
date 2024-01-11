using DataFrames, CSV, Tables

# using Pkg
# Pkg.add("DataFrames")


df = DataFrame(A = 1:4, B = ["M", "F", "F", "M"])

# sum of column
print(sum(df.A), sum(df.:A), sum(df."A"))

####
df.A === df[!, :A] # true

df.A === df[:, :A] # false

df.A == df[:, :A] # true

firstcolumn = :A
df[!, firstcolumn]

print(names(df))

print(propertynames(df))

####
df = DataFrame()
df.A = 1:8
df.B = ["M", "F", "F", "M", "F", "M", "M", "F"]

print(size(df, 1))

print(size(df))

####
df = DataFrame(A = Int[], B = String[])
push!(df, (1, "M"))

push!(df, Dict(:B => "F", :A => 3))


####
df = DataFrame(a=[1, 2, 3], b=[:a, :b, :c])

mkpath("tmp")
CSV.write("tmp/df02_a01.csv", df)

CSV.write("tmp/df02_a01.tsv", df; delim="\t")
readdir("tmp")
# cd("tmp_data"); pwd();  mkdir("tmp_data")


####
v = [(a=1, b=2), (a=3, b=4)]
df = DataFrame(v)


####
Tables.rowtable(df)
