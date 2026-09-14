#!/bin/bash

LOG_FILE="/tmp/system_health.log"

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=200

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

log() {
    echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

echo "System Health Check"
echo "-------------------"

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)
echo "CPU Usage    : ${CPU_USAGE}%"

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log "ALERRT: CPU usage is ${CPU_USAGE}%"
else
    log "OK: CPU usage is ${CPU_USAGE}%"
fi

MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
echo "Memory Usage : ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    log "ALERT: Memory usage is ${MEMORY_USAGE}%"
else
    log "OK: Memory usage is ${MEMORY_USAGE}%"
fi

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
echo "Disk Usage   : ${DISK_USAGE}%"

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log "ALERT: Disk usage is ${DISK_USAGE}%"
else
    log "OK: Disk usage is ${DISK_USAGE}%"
fi

PROCESS_COUNT=$(ps -e --no-headers | wc -l)
echo "Processes    : ${PROCESS_COUNT}"

if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    log "ALERT: Running processes are ${PROCESS_COUNT}"
else
    log "Ok: Running prcesses are ${PROCESS_COUNT}"
fi

echo "-------------------"
echo "Health check completed"
echo "Log: $LOG_FILE"
