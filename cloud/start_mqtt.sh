#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# Load config
source $DIR/../config.env

# Create mosquitto config
sed "s/DOMAIN/$DOMAIN/" $DIR/mqtt/config/mosquitto.conf.template > $DIR/mqtt/config/mosquitto.conf

# Create password file
MQTT_USER=syncdnd
echo "$MQTT_USER:$MQTT_PASS" > $DIR/mqtt/config/password

# Encrypt password file
docker run -it -v $DIR/mqtt/config/password:/password eclipse-mosquitto mosquitto_passwd -U password

# Start MQTT
export MQTT_PORT
docker-compose -f $DIR/mqtt/docker-compose.yml up --build -d
