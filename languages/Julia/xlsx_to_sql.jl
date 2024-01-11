#! /bin/env julia

import XLSX, DataFrames as DF

# $ ./xlsx_to_sql.jl data/browsenode.xlsx data/browsenode.sql browse_node

# xlsx = XLSX.readdata("2021-07-14.xlsx", "Sheet1", "A1:H23")
# sheet = XLSX.readxlsx("2021-07-14.xlsx")[1]

if length(ARGS) < 3
  println("input.xls output.sql and tablename are required")
  exit(1)
end

input, output, target = ARGS[1], ARGS[2], ARGS[3]
println("==> input: $input, output: $output, target: $target")

df = DF.DataFrame(XLSX.readtable(input, 1))

# select!(df, DF.Not(r"icon")) # :icon
replace!(df.icon, missing => "")

# mapcols(col -> parse.(Int, col), df)

DF.mapcols(col -> typeof(col), df)

DF.mapcols!(col -> string.(col), df)

strRow = row -> "('$(join(row, "', '"))')"

sql = "INSERT INTO $target\n  " *
  "(" * join(names(df), ", ") * ")\n  " *
  "VALUES\n  " *
  join(strRow.(eachrow(df)), ",\n  ") * ";\n"

open(output, "w") do io
  write(io, sql)
end
