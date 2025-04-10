#!/bin/bash
# Name: init.sh
# Description: Create the datalake structure.
#
# Usage:
#   ./init.sh
echo "*****************************"
echo "*** INITIALIZATION SCRIPT ***"
echo "*****************************"

LAKE_BASE_PATH=${LAKE_PATH:-"$(pwd)/data"}

printf "Creating data lake directories under '%s' ..." "$LAKE_BASE_PATH"
mkdir -p \
    "$LAKE_BASE_PATH/raw/quotes" \
    "$LAKE_BASE_PATH/logs/"
echo " ✅"

tree "$LAKE_BASE_PATH"
echo "See ya ✌️"
exit 0
