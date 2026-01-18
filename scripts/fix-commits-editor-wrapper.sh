#!/usr/bin/env bash
# Wrapper to ensure COMMIT_PREFIX is set for the real editor script
export COMMIT_PREFIX="$COMMIT_PREFIX"
# Log for debugging
if [ -n "$DEBUG_FIX_COMMITS" ]; then
  echo "[fix-commits-editor-wrapper] Called with args: $@" >> /tmp/fix-commits-editor.log
  echo "[fix-commits-editor-wrapper] COMMIT_PREFIX: $COMMIT_PREFIX" >> /tmp/fix-commits-editor.log
fi
# Call the real editor script
"$(dirname "$0")/fix-commits-editor-real.sh" "$@"

