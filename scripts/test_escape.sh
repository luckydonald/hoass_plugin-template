#!/usr/bin/env bash
set -euo pipefail

samples=(
  "simple"
  "contains\`backtick\`"
  "dollar\$VAR"
  "single'quote"
  $'multi line\nwith newline'
  "complex \$VAR \`cmd\` '\"mixed\"'"
)

joined=""
for s in "${samples[@]}"; do
  esc=$(printf "%s" "$s" | sed "s/'/'\\''/g")
  joined="$joined '$esc'"
done

printf "PRINTED COMMAND:\n"
printf "%s\n" "./scripts/fix-commits.sh$joined"

printf "\nSIMULATED PARSED ARGS:\n"
# Use bash -c to parse the quoted joined string as shell would and print reconstructed args
bash -c "set -- $joined; i=1; for a in \"\$@\"; do printf 'ARG %d: %s\n' \$i \"\$(printf '%q' \"\$a\")\"; i=\$((i+1)); done"
