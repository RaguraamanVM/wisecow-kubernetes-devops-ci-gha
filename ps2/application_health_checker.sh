#!/bin/bash

APP_URL="${1:-https://localhost}"
APP_HOST="wisecow.local"
LOG_FILE="/tmp/application_health.log"

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

log() {
    echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

echo "Application Health Check"
echo "------------------------"
echo "URL: $APP_URL"

HTTP_STATUS=$(curl -k -s -o /dev/null \
    -w "%{http_code}" \
    --max-time 10 \
    -H "Host: $APP_HOST" \
    "$APP_URL")

echo "HTTP Status: $HTTP_STATUS"

if [[ "$HTTP_STATUS" =~ ^2[0-9][0-9]$ ]]; then
    log "UP: Application is runing"
    exit 0
elif [[ "$HTTP_STATUS" =~ ^3[0-9][0-9]$ ]]; then
    log "WARNING: Application returned $HTTP_STATUS"
    exit 1
else
    log "DOWN: Application is not avilable"
    exit 1
fi
