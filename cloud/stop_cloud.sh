#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Load config
source $DIR/../config.env

####### Webhooks ########################################################################################
# Inject config.json
cat $DIR/webhooks/config.json.template |
    sed "s|%DOMAIN|$DOMAIN|" |
    sed "s|%MQTT_PORT|$MQTT_PORT|" |
    sed "s|%MQTT_PASS|$MQTT_PASS|" \
        >$DIR/webhooks/config.json
####### Webhooks ########################################################################################

####### MQTT ############################################################################################
# Create mosquitto config
sed "s/DOMAIN/$DOMAIN/" $DIR/mqtt/config/mosquitto.conf.template >$DIR/mqtt/config/mosquitto.conf

# Create password file
MQTT_USER=syncdnd
echo "$MQTT_USER:$MQTT_PASS" >$DIR/mqtt/config/password

# Encrypt password file
docker run -it -v $DIR/mqtt/config/password:/password eclipse-mosquitto mosquitto_passwd -U password
####### MQTT ############################################################################################

# Start MQTT & Webhooks
export MQTT_PORT
export WEBHOOKS_PORT
docker-compose up --build -d

# Clean up injected config.json (webhooks)
rm $DIR/webhooks/config.json
