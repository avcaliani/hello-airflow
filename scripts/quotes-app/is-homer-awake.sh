#!/bin/bash
# Name: is-homer-awake.sh
# Description: This script returns an error if Homer is not awake!
#
# Usage:
#   ./is-homer-awake.sh

JOB_NAME="is-homer-awake"
LOG_BASE_PATH="${LOGS_PATH:-"$(pwd)/data/logs"}/${JOB_NAME}"
LOG_FILE="$LOG_BASE_PATH/$(date +"%Y%m%d_%H%M%S").log"

init_log() {
    mkdir -p "$LOG_BASE_PATH"
    touch "$LOG_FILE"
}

info() {
    echo "[$(date '+%F %T')] $1" >> "$LOG_FILE"
    echo "$1"
}

# MAIN ---
init_log
info "Job: $JOB_NAME"

info "Cheking if Homer is awake... "
sleep "$(( (RANDOM % 10) + 1 ))"
is_awake=$(( RANDOM % 2 ))

if [[ "$is_awake" == 0 ]]; then
  info "Yayyyy! He's awake ☕️"
else
  info "Ops! He is sleeping 😴"
  info "Try again later 😅"
fi
exit "$is_awake"
