#!/bin/bash
# Authentication script for JAMES API (ACC environment)
# This script reads an API key, authenticates, and saves the bearer token
# Exit code 0: success, Exit code 1: failure

# Check if API key file exists
if [ ! -f "apikey-acc.txt" ]; then
  echo "Error: apikey-acc.txt not found" >&2
  exit 1
fi

# Read API key from file
APIKEY=$(cat apikey-acc.txt)

# Authenticate and get bearer token with timeout
TOKEN=$(curl -s --connect-timeout 10 --max-time 30 --location \
  'https://srminterlayer-az-acc.eaglescience.nl/api/v1/api-login' \
  --header 'Content-Type: text/plain' \
  --data-raw "$APIKEY" 2>&1)

# Check if curl succeeded
if [ $? -ne 0 ]; then
  echo "Error: Failed to connect to ACC server" >&2
  exit 1
fi

# Check if we got a valid token (not empty and not an error message)
if [ -z "$TOKEN" ] || [[ "$TOKEN" == *"error"* ]] || [[ "$TOKEN" == *"curl"* ]]; then
  echo "Error: Failed to obtain valid authentication token" >&2
  exit 1
fi

# Save token to file
echo "$TOKEN" > .bearer

# Success
exit 0

## GET request example
# curl https://srminterlayer-az-acc.eaglescience.nl/modules/james/index.html \
#    -H "accept: application/json" \
#    -H "Authorization: Bearer ${TOKEN}"

## POST request example
# curl -X POST https://srminterlayer-az-acc.eaglescience.nl/modules/james/version/json \
#    -H "accept: application/json" \
#    -H "Authorization: Bearer ${TOKEN}"

# curl -X POST https://srminterlayer-az-acc.eaglescience.nl/modules/james/blend/request/json \
# -H "accept: application/json" \
# -H "Content-Type: application/json" \
# -H "Authorization: Bearer ${TOKEN}" \
# -d '{
# "txt": "https://james.groeidiagrammen.nl/ocpu/library/bdsreader/examples/Laura_S.json",
# "sitehost": "https://srminterlayer-az-acc.eaglescience.nl/modules/james",
# "blend": "standard"
# }'
