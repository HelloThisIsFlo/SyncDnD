#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

DAEMON_LABEL=com.floriankempenich.syncdnd.daemon.plist

PLIST_FILENAME=$DAEMON_LABEL
PLIST_PATH=$HOME/Library/LaunchAgents/$PLIST_FILENAME

launchctl unload $PLIST_PATH
rm $PLIST_PATH
