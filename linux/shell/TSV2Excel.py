#!/usr/bin/env python3

import pandas as pd
import os, sys
# make sure that "xlsxwriter" have been installed

for c in os.sys.argv[1:]:
    c1 = c.split(":", 1)
    tsv = c1[0]
    excel = c1[1] if len(c1) == 2 else c1[0].rstrip(".tsv") + ".xlsx"
    try:
        d = pd.read_csv(tsv, sep="\t", dtype=str)
        writer = pd.ExcelWriter(excel, engine='xlsxwriter')
        d.to_excel(writer, index=False)
        writer.save()
        sys.stderr.write("saved " + excel + "\n")
    except:
        sys.stderr.write("failed to convert " + c + "\n")
