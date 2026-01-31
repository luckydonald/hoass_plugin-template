#!/usr/bin/env bash
# Auto-commit helper for local use
# Stages files and runs `make commit` if available, else falls back to `git commit`.
# Usage:
#   scripts/_auto_commit_after_edit.sh            # stage all changes and run make commit
#   scripts/_auto_commit_after_edit.sh file1 file2 # stage specified files and run make commit
#   scripts/_auto_commit_after_edit.sh --yes       # stage all and run without prompt

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

CONFIRM=true
if [ "${1-}" = "--yes" ]; then
  CONFIRM=false
  shift || true
fi

# Choose files to add
if [ "$#" -gt 0 ]; then
  FILES=("$@")
else
  # get list of modified/untracked files
  mapfile -t FILES < <(git status --porcelain | awk '{print $2}' | sed '/^$/d') || true
fi

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No changes to commit."
  exit 0
fi

echo "Will stage the following files:"
for f in "${FILES[@]}"; do
  echo "  $f"
done

if [ "$CONFIRM" = true ]; then
  read -p "Proceed to stage and run commit? (y/N) " ans
  case "$ans" in
    [Yy]*) ;;
    *) echo "Aborted."; exit 1;;
  esac
fi

# Stage files
for f in "${FILES[@]}"; do
  git add -- "$f"
done

# Run `make commit` if available, otherwise fallback
if command -v make >/dev/null 2>&1 && make -n commit >/dev/null 2>&1; then
  echo "Running: make commit"
  make commit
else
  echo "Running fallback: git commit -m 'chore: auto-commit after script edit'"
  git commit -m "chore: auto-commit after script edit"
fi

echo "Auto-commit finished."
