#!/bin/bash
# Name: quotes-extractor.sh
# Description: This script retrieves some quotes from the Simpsons API.
#
# Usage:
#   ./quotes-extractor.sh --quotes 100 --sleep 1
#
# Notes:
#   The arguments quotes and sleep are optional, their default values 
#   are 10 and 0.5 respectively.
#   More details about the API, check their documentation 👇
#   https://www.postman.com/simpsons-team
#
# Dependencies:
#   curl

JOB_NAME="quotes-extractor"
EXECUTION_TS=$(date +"%Y%m%d_%H%M%S")
LAKE_BASE_PATH=${LAKE_PATH:-"$(pwd)/data"}
LOG_BASE_PATH="${LOGS_PATH:-"$(pwd)/data/logs"}/${JOB_NAME}"
LOG_FILE="$LOG_BASE_PATH/$EXECUTION_TS.log"

init_log() {
    mkdir -p "$LOG_BASE_PATH"
    touch "$LOG_FILE"
}

info() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
    echo "$1"
}

# ARGUMENTS ---
n_quotes=10
request_sleep=0.5

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --quotes) n_quotes="$2"; shift ;;
        --sleep) request_sleep="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# MAIN ---
init_log
info "Job: $JOB_NAME"
info "Quotes to Extract: $n_quotes"
info "Sleep Between Requests: $request_sleep"

final_file="$LAKE_BASE_PATH/raw/quotes/$EXECUTION_TS.jsonl"
touch "$final_file"

for _ in $(seq 1 "$n_quotes"); do
  response=$(curl -s --location 'https://thesimpsonsquoteapi.glitch.me/quotes')
  echo "${response}" >> "$final_file"
  sleep "$request_sleep"
done
info "Job Done"
exit 0
