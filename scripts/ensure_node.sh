#!/usr/bin/env bash
set -euo pipefail

# Ensure Node.js major version is >= 24
REQUIRED_MAJOR=24

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js not found. Please install Node ${REQUIRED_MAJOR}.x and retry."
  exit 2
fi

NODE_VER=$(node -v)
# strip leading 'v'
NODE_VER=${NODE_VER#v}
NODE_MAJOR=${NODE_VER%%.*}

if [ "$NODE_MAJOR" -lt "$REQUIRED_MAJOR" ]; then
  echo "Node ${REQUIRED_MAJOR} or newer is required. Detected: v${NODE_VER}"
  echo "Use nvm: 'nvm install ${REQUIRED_MAJOR} && nvm use ${REQUIRED_MAJOR}' or install from https://nodejs.org/"
  exit 3
fi

# success
exit 0
