#!/usr/bin/env bash
set -euo pipefail

SEASON="2025"
LEAGUE="NFBKC-50s-#29"
TEAM="kfredincal"

# Usage example: tools/log_round.sh 1 6
ROUND="${1:-}"
PICK="${2:-}"

# Provide a POSIX-friendly uppercase version of LEAGUE (macOS /bin/bash is old)
LEAGUE_UPPER="$(printf '%s' "$LEAGUE" | tr '[:lower:]' '[:upper:]')"

if [[ -z "$ROUND" || -z "$PICK" ]]; then
  echo "Usage: tools/log_round.sh <round> <pick_overall> [team]"
  exit 1
fi

DIR="draft/leagues/${SEASON}-${LEAGUE}"
mkdir -p "$DIR"

FILENAME="$(printf "%s/round-%02d.md" "$DIR" "$ROUND")"
DATE="$(date +%F)"

cat > "$FILENAME" <<EOF
---
season: ${SEASON}
league: ${LEAGUE_UPPER}
round: ${ROUND}
pick_overall: ${PICK}
team: ${TEAM}
date: ${DATE}
model: GPT-5 Thinking
---

## decision
**Player picked:** 

## prompts
\`\`\`text
# Paste your prompts below
\`\`\`

## transcript
\`\`\`text
# Paste the full ChatGPT conversation for this round here
\`\`\`

## notes
- 
EOF

${EDITOR:-vi} "$FILENAME"

git add "$FILENAME"
git commit -m "log(${SEASON}-${LEAGUE}): round ${ROUND} pick ${PICK}"
