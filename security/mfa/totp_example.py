#!/usr/bin/env python3
"""
TOTP 示例：标准库手动实现 + pyotp 库两种方式
依赖：pip install pyotp qrcode[pil]
"""

import argparse
import hmac
import hashlib
import struct
import time
import base64


# ── 手动实现 ──────────────────────────────────────────────────────────────────

def _totp_manual(secret_b32: str, digits: int = 6, period: int = 30) -> str:
    key = base64.b32decode(secret_b32.upper())
    T = int(time.time()) // period
    msg = struct.pack(">Q", T)
    h = hmac.new(key, msg, hashlib.sha1).digest()
    offset = h[-1] & 0x0F
    code = struct.unpack(">I", h[offset:offset + 4])[0] & 0x7FFFFFFF
    return str(code % (10 ** digits)).zfill(digits)


# ── pyotp 库实现 ───────────────────────────────────────────────────────────────

def _totp_pyotp(secret: str, issuer: str, account: str, digits: int):
    import pyotp

    totp = pyotp.TOTP(secret, digits=digits, interval=30)
    code = totp.now()
    valid = totp.verify(code, valid_window=1)   # 允许 ±1 个窗口（±30秒）
    url = totp.provisioning_uri(name=account, issuer_name=issuer)
    return code, valid, url


def _print_qr(url: str):
    try:
        import qrcode
        qr = qrcode.QRCode(border=1)
        qr.add_data(url)
        qr.make(fit=True)
        qr.print_ascii(invert=True)
    except ImportError:
        print("（安装 qrcode[pil] 可显示二维码：pip install 'qrcode[pil]'）")


# ── 主程序 ────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="TOTP 示例")
    parser.add_argument("--issuer",  default="MyApp",            help="服务名称")
    parser.add_argument("--account", default="user@example.com", help="账户名")
    parser.add_argument("--secret",  default="",                 help="Base32 密钥，留空随机生成")
    parser.add_argument("--digits",  type=int, default=6,        help="OTP 位数（6 或 8）")
    parser.add_argument("--mode",    choices=["manual", "pyotp", "both"], default="both")
    args = parser.parse_args()

    secret = args.secret
    if not secret:
        import pyotp
        secret = pyotp.random_base32()
        print(f"secret:       {secret}")

    print(f"\n{'─'*50}")
    print(f"issuer:  {args.issuer}")
    print(f"account: {args.account}")
    print(f"digits:  {args.digits}")
    print(f"{'─'*50}\n")

    if args.mode in ("manual", "both"):
        print("[手动实现]")
        code = _totp_manual(secret, digits=args.digits)
        print(f"totp:  {code}\n")

    if args.mode in ("pyotp", "both"):
        print("[pyotp 库]")
        code, valid, url = _totp_pyotp(secret, args.issuer, args.account, args.digits)
        print(f"totp:         {code}")
        print(f"valid:        {valid}")
        print(f"otp_auth_url: {url}\n")
        _print_qr(url)


if __name__ == "__main__":
    main()
