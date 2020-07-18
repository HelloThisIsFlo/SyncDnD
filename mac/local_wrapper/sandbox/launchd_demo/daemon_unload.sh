#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PLIST_FILENAME=com.floriankempenich.daemon.plist
PLIST_PATH=$HOME/Library/LaunchAgents/$PLIST_FILENAME

launchctl unload $PLIST_PATH
rm $PLIST_PATH
