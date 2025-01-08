#!/bin/sh

if [ -z "$TF_BACKEND_CONFIG_FILENAME" ]; then
    echo "TF_BACKEND_CONFIG_FILENAME is not set!"
    exit 1
fi

if [ -z "$TF_WORK_DIR" ]; then
    echo "Environment variable TF_WORK_DIR is not set!"
    exit 1
fi

{ wait $PPID && terraform init -migrate-state -force-copy -backend-config="$TF_BACKEND_CONFIG_FILENAME"; } &

exit 0