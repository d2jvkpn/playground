using DataFrames, CSV, Query


# df1 = DataFrame(A=1:10, B=[12, 30, 11, 80, 5, 1, 78, 45, 90, 14]);
df1 = CSV.read("data/d1.tsv", DataFrame; header=1, delim="\t")

println(df1)

mkpath("tmp")
CSV.write("tmp/d2.tsv", df1, delim="\t")
