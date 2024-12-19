#!/bin/bash

msg="source_path=$source_path, target_path=$target_path"

echo "==> $(date +%FT%T%:z) start oss copy: $msg"

while ! ossutil -c oss.ini cp -r $source_path $target_path; do
    echo "--> $(date +%FT%T%:z) try again in 5s: $msg"
    sleep 5
done

echo "<== $(date +%FT%T%:z) oss copy is done: $msg"
