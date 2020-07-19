#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

VIRTUALENV=syncdnd
LABEL=com.floriankempenich.syncdnd.daemon.plist
WORKING_DIR=/usr/local/lib/$LABEL

PLIST_FILENAME=$LABEL
PLIST_PATH=$HOME/Library/LaunchAgents/$PLIST_FILENAME

# Create app dir & copy code
mkdir -p $WORKING_DIR
cd $WORKING_DIR
cp $DIR/daemon.py .

# Create & activate virtual env
python3 -m venv $VIRTUALENV
source ./$VIRTUALENV/bin/activate

# Install MQTT dependency
pip3 install paho-mqtt==1.5.0

# Load daemon
cat $DIR/daemon.plist.template |
    sed "s|%WORKING_DIR|$WORKING_DIR|" |
    sed "s|%LABEL|$LABEL|" |
    sed "s|%VIRTUALENV|$VIRTUALENV|" \
        >$PLIST_PATH
launchctl load $PLIST_PATH

echo ""
echo "Sync DnD was installed"
