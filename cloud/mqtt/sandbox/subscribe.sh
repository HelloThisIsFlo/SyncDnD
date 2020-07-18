#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Load config
source $DIR/../../../config.env

mqtt-client subscribe \
    --host=$DOMAIN:$MQTT_PORT \
    --transport=TCP-TLS \
    --cert_path=/etc/ssl/cert.pem \
    --client_id=sandbox-cli-sub \
    --topic=dnd \
    --username=syncdnd \
    --password=$MQTT_PASS
