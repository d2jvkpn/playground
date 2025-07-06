#!/usr/bin/env python3

import os, argparse


parser = argparse.ArgumentParser(
    description="parse commandline arguments",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("command", help="command name", choices=["download", "run"])

parser.add_argument("-c", "--config", help="config path", default="./configs/local.yaml")
parser.add_argument("-v", "--verbose", help="verbose", action="store_true")
parser.add_argument("--model", help="model name", required=True, default="")
parser.add_argument("--number", help="number of max tokens", type=int, default=1024)

parser.add_argument("msg", help="message", nargs="*")

args = parser.parse_args()
# args = parser.parse_args(os.argv[1:])
# args = parser.parse_args(["run", "--model=xx"])

print(args)
