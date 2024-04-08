#!/bin/python3

import os
import pandas as pd

df = pd.read_html("https://www.tiobe.com/tiobe-index/")[0]

df.drop(axis=1,columns=["Change", "Programming Language"], inplace=True)
df.columns = [c.replace(".1", "") for c in df.columns]

filename = os.path.join("data", "TIOBE_Index_"+df.columns[0].replace(" ", "-"))+".tsv"

os.makedirs("data", exist_ok=True)
df.to_csv(filename, sep="\t")

print(f"==> saved to {filename}")
