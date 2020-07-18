#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PLIST_FILENAME=com.floriankempenich.daemon.plist
PLIST_PATH=$HOME/Library/LaunchAgents/$PLIST_FILENAME

cp $DIR/daemon.plist $PLIST_PATH
launchctl load $PLIST_PATH
