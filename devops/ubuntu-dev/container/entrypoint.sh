#!/bin/sh
set -eu

sudo -n /opt/bin/prepare-container.sh

sudo -n supervisord -n -c /etc/supervisor/supervisord.conf &
supervisor_pid=$!

stop_supervisor() {
    sudo -n supervisorctl -c /etc/supervisor/supervisord.conf shutdown >/dev/null 2>&1 || \
        kill -TERM "$supervisor_pid" 2>/dev/null || true
    wait "$supervisor_pid" || true
}
trap stop_supervisor EXIT
trap 'exit 143' TERM
trap 'exit 130' INT

attempt=0
until sudo -n supervisorctl -c /etc/supervisor/supervisord.conf pid >/dev/null 2>&1; do
    if ! kill -0 "$supervisor_pid" 2>/dev/null; then
        wait "$supervisor_pid"
        exit 1
    fi
    attempt=$((attempt + 1))
    if [ "$attempt" -ge 30 ]; then
        echo "supervisord did not become ready" >&2
        exit 1
    fi
    sleep 1
done

sudo -n supervisorctl -c /etc/supervisor/supervisord.conf start sshd
wait "$supervisor_pid"
