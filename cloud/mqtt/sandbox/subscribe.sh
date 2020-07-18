#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PASS=$(cat $DIR/pass)
mqtt-client subscribe \
    --host=floriankempenich.com:5678 \
    --transport=TCP-TLS \
    --cert_path=/etc/ssl/cert.pem \
    --client_id=sandbox-cli-sub \
    --topic=dnd \
    --username=syncdnd \
    --password=$PASS
