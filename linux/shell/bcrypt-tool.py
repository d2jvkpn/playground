#!/usr/bin/env python3

import sys, argparse, getpass

import bcrypt


parser = argparse.ArgumentParser(
  description="parse commandline arguments for bcrypt-tool",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument("command", help="command name", choices=["hash", "verify"])

parser.add_argument("--password", help="password", type=str, required=False, default="")
parser.add_argument("--cost", help="hash cost", type=int, required=False, default=12)

parser.add_argument(
  "--hashed", help="bcrypt hashed password",
  type=str, required=False, default="",
)

args = parser.parse_args()

#args.hashed = args.hashed.split(":", 1)[-1]
args.hashed = args.hashed.strip()
if args.command == "verify" and args.hashed == "":
    print(f"!!! Argument --hashed is required for verify")
    sys.exit(1)

# print("password: ", password)
if args.password == "":
    args.password = getpass.getpass("--> Enter password: ")

args.password = args.password.strip()
if args.password == "":
    print(f"??? Password is empty")
    sys.exit(1)

if args.command == "hash":
    hashed_password = bcrypt.hashpw(
      args.password.encode("utf-8"),
      bcrypt.gensalt(rounds=args.cost),
    )

    print(hashed_password.decode("utf8"))
else:
    try:
        ok = bcrypt.checkpw(args.password.encode("utf-8"), args.hashed.encode("utf-8"))
    except Exception as e:
        print(f"!!! Unexpected error: {e}")
        sys.exit(1)

    if ok:
        print("--> Password match")
    else:
        print("!!! Incorrect password")
        sys.exit(1)
