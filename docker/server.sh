#!/bin/bash
set -eu

cd /app
npm start || true

while true; do sleep 10; done
