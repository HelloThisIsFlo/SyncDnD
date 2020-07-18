#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PASS=$1
if [ -z $PASS ]; then
    echo "Please provide the password as argument: './create_password_file.sh PASS'"
    exit 1
fi

# Create 'password' file - User: `syncdnd` Pass: $PASS
echo "syncdnd:$PASS" > $DIR/config/password

# Encrypt 'password' file
docker run -it -v $DIR/config/password:/password eclipse-mosquitto mosquitto_passwd -U password
