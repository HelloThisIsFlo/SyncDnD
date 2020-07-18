#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

DAEMON_LABEL=com.floriankempenich.syncdnd.daemon.plist
DAEMON_WORKING_DIR=$DIR

PLIST_FILENAME=$DAEMON_LABEL
PLIST_PATH=$HOME/Library/LaunchAgents/$PLIST_FILENAME

cat $DIR/daemon.plist.template |
    sed "s|%WORKING_DIR|$DAEMON_WORKING_DIR|" |
    sed "s|%LABEL|$DAEMON_LABEL|" \
        >$PLIST_PATH
launchctl load $PLIST_PATH
