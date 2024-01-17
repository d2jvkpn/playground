#! /bin/env python3

import pandas as pd

import sys, json

for fp in sys.argv[1:]:
  print(f"==> load {fp}")
  with open(fp, 'r') as f:
    data = json.load(f)

  comments = pd.DataFrame.from_records([d.values() for d in data["comments"]])
  if len(comments) == 0:
    print(f"!!! no comments in ${fp}")
    continue

  comments.columns = data["comments"][0].keys()
  output = fp.replace(".json", ".comments.tsv")
  comments.to_csv(output, sep="\t", index=False)
  print(f"<== saved {out}")
