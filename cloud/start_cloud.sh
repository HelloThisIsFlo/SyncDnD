#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Load config
source $DIR/../config.env

# Stop MQTT & Webhooks
export MQTT_PORT
export WEBHOOKS_PORT
docker-compose down
