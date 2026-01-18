#!/usr/bin/env bash
# This script handles squash commit messages automatically
# It keeps only the first non-comment line and removes the rest

FILE="$1"

# Debug log
if [ -n "$DEBUG_FIX_COMMITS" ]; then
  echo "[fix-commits-editor-real] Called with file: $FILE" >> /tmp/fix-commits-editor.log
  echo "[fix-commits-editor-real] COMMIT_PREFIX: $COMMIT_PREFIX" >> /tmp/fix-commits-editor.log
fi

# Get the first non-comment, non-empty line
FIRST_MSG=$(grep -v '^#' "$FILE" | grep -v '^$' | head -1)

# Remove any leading *TEMPLATE | * (with or without emoji/whitespace)
NORMALIZED_MSG=$(echo "$FIRST_MSG" | sed -E 's/^([[:space:]]*[[:graph:]]*TEMPLATE[[:space:]]*\|[[:space:]]*)//')

# Always prepend the correct prefix if set
if [ -n "$COMMIT_PREFIX" ]; then
    echo "$COMMIT_PREFIX$NORMALIZED_MSG" > "$FILE"
else
    echo "$NORMALIZED_MSG" > "$FILE"
fi

