#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _dir=$(readlink -f `dirname "$0"`)

pdf=$1

exit

####
less "$pdf" | 's/\x0c//g' > "${pdf}.txt"

####
ocrmypdf --deskew --rotate-pages --clean \
  --force-ocr --language chi_sim --clean-final --jobs 4 \
  "${pdf}" "${pdf%.pdf}.scanned.pdf"

sudo apt install ocrmypdf tesseract-ocr
sudo apt install tesseract-ocr-chi-sim tesseract-ocr-chi-tra  # Chinese support

####
sudo apt install poppler-utils

pdf_is_ocr=$(pdftotext "$pdf" - | sed 's/\x0c//g' | sed '/^[[:space:]]*$/d' | head -n5 | wc -c)

####
pandoc input.pdf -o output.md

marker convert input.pdf output.md

nougat input.pdf -o output.md

sed '/^$/d' output.md
sed 's/\[ \]/ /g' output.md 
sed 's/{\\*\\*}//g' my_document.md

####
pip install pdfminer.six markdownify

```
from pdfminer.high_level import extract_text
import markdownify

pdf_text = extract_text("input.pdf")
md_text = markdownify.markdownify(pdf_text, heading_style="ATX")

with open("output.md", "w") as f:
    f.write(md_text)
```

####
sudo apt install ocrmypdf tesseract-ocr
ocrmypdf input_scan.pdf output_ocr.pdf
pandoc output_ocr.pdf -o output.md

####
pip install pytesseract pillow pdf2image

```
import pytesseract
from pdf2image import convert_from_path

pages = convert_from_path("scan.pdf")

md_text = ""
for p in pages:
    text = pytesseract.image_to_string(p, lang="chi_sim+eng")
    md_text += text + "\n\n"

open("output.md", "w").write(md_text)
```

####
pdftohtml -xml input.pdf output.xml
pandoc output.xml -o output.md

pdf2md --imgpath=images input.pdf > output.md
