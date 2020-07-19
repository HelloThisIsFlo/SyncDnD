#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

LABEL=com.floriankempenich.syncdnd.daemon.plist
WORKING_DIR=/usr/local/lib/$LABEL

tail -f $WORKING_DIR/output/stdout.log
