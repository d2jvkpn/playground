#!/usr/bin/env python3

my_str = "Hello\nWorld\t!"

print(my_str)
print(repr(my_str))


my_str = """hello
world!
"""

print(my_str.encode('unicode_escape').decode('utf-8'))
