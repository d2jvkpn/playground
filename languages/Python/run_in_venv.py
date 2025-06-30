#!/usr/bin/env python3
import os, sys, subprocess


def run_in_venv():
    venv_file = os.environ.get("venv_file", os.path.join("configs", "venv"))

    try:
        with open(venv_file, 'r', encoding='utf-8') as f:
            venv_path = f.readline().strip()
    except Exception as e:
        print(f"!!! An error occured: {e}")
        return (False, 0)

    cmd = [os.path.join(venv_path, "bin", "python")]
    cmd.extend(os.sys.argv)
    # print(f"venv_path: {venv_path}, cmd: {cmd}")

    # shell=True, executable='/bin/bash', capture_output=True, text=True
    result = subprocess.run(cmd, env={ **os.environ })

    return (True, result.returncode)


def run():
    # import ...
    print("==> Args: {}".format(os.sys.argv[1:]))
    print("<== Exit")


if __name__ == '__main__':
    # hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix')
    if sys.prefix != sys.base_prefix:
        print("+++ Already in venv")
        run()
    else:
        print("!!! Not in venv")
        result = run_in_venv()
        if not result[0]:
            os.sys.exit(1)
        else:
            os.sys.exit(result[1])
