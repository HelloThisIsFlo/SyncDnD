#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Load config
source $DIR/../config.env

# Stop MQTT & Webhooks
export MQTT_PORT
export WEBHOOKS_PORT
docker-compose -f $DIR/docker-compose.yml down

# Clean up generated files
rm -f $DIR/mqtt/config/mosquitto.conf
rm -f $DIR/mqtt/config/password
rm -f $DIR/webhooks/config.json
