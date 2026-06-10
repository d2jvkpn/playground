#!/usr/bin/env python3
import bcrypt


password = b"<your_password>"

hashed = bcrypt.hashpw(password, bcrypt.gensalt())
print(hashed)  # 输出类似 b'$2b$12$...'

if bcrypt.checkpw(password, hashed):
    print("密码匹配")
else:
    print("密码错误")
