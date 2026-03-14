#!/bin/bash
cd "$(dirname "$0")"

[ -f package.json ] || exit 0

pnpm install

# Print portless URL after server is ready
PORTLESS_NAME=$(node -e "const m=JSON.parse(require('fs').readFileSync('package.json','utf8')).scripts.dev.match(/portless\s+(\S+)/);if(m)console.log(m[1])")
if [ -n "$PORTLESS_NAME" ]; then
  (
    while ! portless list 2>/dev/null | grep -q "$PORTLESS_NAME"; do sleep 1; done
    URL="https://${PORTLESS_NAME}.localhost"
    echo ""
    echo "  → $URL"
    echo ""
  ) &
fi

pnpm dev
