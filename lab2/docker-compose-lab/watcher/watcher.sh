#!/bin/sh

while true; do
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  RESPONSE=$(curl -sf http://api:8080/)
  if [ $? -eq 0 ]; then
    echo "[${TIMESTAMP}] OK — ${RESPONSE}"
  else
    echo "[${TIMESTAMP}] ERROR — api unreachable"
  fi
  sleep 10
done
