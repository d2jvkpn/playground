using DataFrames, CSV, Tables

df = DataFrame(CSV.File("tmp/d2.tsv"; delim="\t"))

print(df)
