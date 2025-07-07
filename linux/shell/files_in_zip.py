#!/usr/bin/env python3
import os, zipfile, fnmatch, argparse


def list_files_in_zip(filpath, pattern=None):
    def match_file(v):
        if pattern is None:
            return not v.is_dir()
        else:
            return not v.is_dir() and fnmatch.fnmatch(v.filename, pattern)

    def file_info(info):
        return {
            "filepath": info.filename,
            "file_size": info.file_size,
            "compress_size": info.compress_size,
        }

    with zipfile.ZipFile(filpath, 'r') as zipf:
        matched = [file_info(v) for v in zipf.infolist() if match_file(v)]
        return matched

def read_files_in_zip(filpath, pattern=None):
    def match_file(v):
        if pattern is None:
            return not v.is_dir()
        else:
            return not v.is_dir() and fnmatch.fnmatch(v.filename, pattern)

    def read_file(zipf, info):
        with zipf.open(info) as f:
            data = f.read()
        return data

    with zipfile.ZipFile(filpath, 'r') as zipf:
        contents = [(v.filename, read_file(zipf, v)) for v in zipf.infolist() if match_file(v)]
        return contents


parser = argparse.ArgumentParser(
    description="parse commandline arguments",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("--zip-file", help="zip filepath", required=True)

parser.add_argument("--pattern", help="match files in zip", default="*")
parser.add_argument(
    "--action", choices=["list", "read"], default="list",
    help="list: list files, read: read content of files",
)

args = parser.parse_args()


if args.action == "list":
    files = list_files_in_zip(args.zip_file, args.pattern)
    for f in files:
        print(f"- {{ filepath: {repr(f['filepath'])}, file_size: {f['file_size']}, " + \
            f"compress_size: {f['compress_size']} }}")
elif args.action == "read":
    contents = read_files_in_zip(args.zip_file, args.pattern)
    for e in contents:
        print(f"--------\n{e[0]}:\n{e[1]}")
