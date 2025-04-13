#!/bin/bash
set -eu -o pipefail; _wd=$(pwd); _path=$(readlink -f `dirname "$0"`)


#### 1.
if [ $# -lt 1 ]; then
    echo '!!! Command(s) is required to run'
    exit 1
fi

cmd="$1"
lock_file=/tmp/$(basename "$cmd").lock


#### 2.
# Function: Try to acquire a file lock or exit if already locked
function lock_or_exit() {
    #lock_file=/tmp/$(basename "$0").lock

    exec {lock_fd}> "$lock_file" || {
        echo '!!!' "Failed to open lock file: lock_file=$lock_file, exit_code=10"
        exit 10
    }

    flock -n "$lock_fd" || {
        echo '!!!' "Another instance is already running: lock_file=$lock_file, exit_code=11"
        exit 11
    }

    # Lock acquired. The FD will be automatically closed when the script exits.
    echo "--> Lock acquired: lock_file=$lock_file, lock_fd=${lock_fd}"
}

# 🔐 Try to acquire the lock
lock_or_exit


#### 3.
# 🧠 Main script logic starts here
echo "==> $(date +%FT%T%:z) Task started: command=$cmd, PID=$$"
"$@"
echo "<== $(date +%FT%T%:z) Task completed: command=$cmd"

# ✅ No need to manually release the lock — it will be released when the script ends
