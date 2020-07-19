#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Load config
source $DIR/../config.env

# Inject config.json
cat $DIR/webhooks/config.json.template |
    sed "s|%DOMAIN|$DOMAIN|" |
    sed "s|%MQTT_PORT|$MQTT_PORT|" |
    sed "s|%MQTT_PASS|$MQTT_PASS|" \
        >$DIR/webhooks/config.json

# Start Webhooks
export WEBHOOKS_PORT=3333 # TODO: Put in cfg & update readme
docker-compose -f $DIR/webhooks/docker-compose.yml up --build -d

# Clean up injected config.json
rm $DIR/webhooks/config.json
