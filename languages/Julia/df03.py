#! /bin/env python3

import pandas as pd

df = pd.read_csv("tmp/d2.tsv", sep="\t")
print(df)


import polars as pd

df = pd.read_csv("tmp/d2.tsv", sep="\t")
print(df)
