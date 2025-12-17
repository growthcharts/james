#!/bin/bash
# Helper function for authenticated curl requests
# Source this file in bash chunks: source auth_curl.sh

auth_curl() {
  if [ -f .bearer ]; then
    TOKEN=$(cat .bearer)
    curl -H "Authorization: Bearer $TOKEN" "$@"
  else
    curl "$@"
  fi
}
