#!/usr/bin/env python3

from b import hello as hello_b


print("....c")


def hello():
    hello_b()
    print("Hello from c")
