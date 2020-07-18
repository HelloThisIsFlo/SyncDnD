#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

MSG=$1
if [ -z $MSG ]; then
    echo "Please provide a message to send: './publish.sh MSG'"
    exit 1
fi

# Load config
source $DIR/../../../config.env

mqtt-client publish \
    --host=$DOMAIN:$MQTT_PORT \
    --transport=TCP-TLS \
    --cert_path=/etc/ssl/cert.pem \
    --client_id=sandbox-cli-pub \
    --topic=dnd \
    --username=syncdnd \
    --password=$MQTT_PASS \
    --payload=$MSG
