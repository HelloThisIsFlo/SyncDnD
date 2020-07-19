#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

LABEL=com.floriankempenich.syncdnd.daemon.plist
WORKING_DIR=/usr/local/lib/$LABEL

PLIST_FILENAME=$LABEL
PLIST_PATH=$HOME/Library/LaunchAgents/$PLIST_FILENAME

if ! [ -d "$WORKING_DIR" ] && ! [ -f "$PLIST_PATH" ]; then
    echo "Sync DnD was already uninstalled"
    exit 0
fi

# Unload daemon
launchctl unload $PLIST_PATH

# Clean up installation
rm -f $PLIST_PATH
rm -rf $WORKING_DIR

echo "Sync DnD was uninstalled"
