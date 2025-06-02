#!/usr/bin/env python3

from pdfminer.high_level import extract_text as extract_pdf_text
import docx

def extract_text(file_path: str) -> str:
    if file_path.endswith(".pdf"):
        return extract_pdf_text(file_path)

    elif file_path.endswith(".docx"):
        doc = docx.Document(file_path)
        return "\n".join([p.text for p in doc.paragraphs])

    else:
        with open(file_path) as f:
            return f.read()
