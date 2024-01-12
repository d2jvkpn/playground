#! /bin/env python3

import sys, json

import pandas as pd

fp = sys.argv[1]
# fp = 'detail.1688.com-694198039590_2024-01-12.json'

with open(fp, 'r') as f:
  data = json.load(f)

headers = 

comments = pd.DataFrame.from_records([d.values() for d in data["comments"]])
comments.columns = data["comments"][0].keys()

output = fp.replace(".json", ".comments.tsv")

comments.to_csv(output, sep="\t", index=False)
