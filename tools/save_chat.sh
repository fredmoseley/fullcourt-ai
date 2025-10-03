#!/usr/bin/env bash
set -euo pipefail

SEASON="2025"
LEAGUE="NFBKC-50s-#29"
TEAM="kfredincal"

# In ChatGPT: Select All → Copy the chat for the round.
# In your repo:
# Usage: ./save_chat.sh 1 6
# git add transcripts && git commit -m "Add chat transcript round-01"
ROUND="${1:-}"
PICK="${2:-}"

DIR="draft/leagues/${SEASON}-${LEAGUE}/transcripts"
FILE="$DIR/round-${ROUND}.md"
MODEL="${CHAT_MODEL:-GPT-5 Thinking}"
DATE_ISO="$(date -Iseconds)"

mkdir -p "$DIR"

# Requires macOS clipboard (pbpaste). Copy your chat first, then run this script.
CONTENT="$(pbpaste)"

# Minimal YAML front matter + body
cat > "$FILE" <<"EOF"
---
season: ""
league: ""
team: ""
round: ""
pick: ""
date: ""
model: ""
---
EOF

# Fill metadata and append content
# (You can fill these flags per run; defaults are fine too.)
TITLE="${CHAT_TITLE:-ChatGPT Transcript}"
MODEL="${CHAT_MODEL:-GPT-5 Thinking}"
DATE_ISO="$(date -Iseconds)"
URL="${CHAT_URL:-[Round ${ROUND} Chat]()}"

# Replace placeholders
perl -0777 -pe "s/title:\s*\"\"/title: \"${TITLE//\//\\/}\"/;
s/round:\s*\"\"/round: \"${ROUND//\//\\/}\"/;
s/pick:\s*\"\"/pick: \"${PICK//\//\\/}\"/;
s/season:\s*\"\"/season: \"${SEASON//\//\\/}\"/;
s/league:\s*\"\"/league: \"${LEAGUE//\//\\/}\"/;
s/team:\s*\"\"/team: \"${TEAM//\//\\/}\"/;
s/date:\s*\"\"/date: \"${DATE_ISO//\//\\/}\"/;
#s/url:\s*\"\"/url: ${URL//\//\\/}/;
s/model:\s*\"\"/model: \"${MODEL//\//\\/}\"/;" \
   -i "$FILE"

# Append the clipboard content under a header
{
  echo -e "\n# [Transcript]()\n"
  # Wrap as fenced block for easy diffing; remove if you prefer plain text
  echo '```'
  printf "%s\n" "$CONTENT"
  echo '```'
  echo -e "\n## Notes\n"
  echo -e "\n## Problems\n"
} >> "$FILE"

echo "Saved: $FILE"
