#!/usr/bin/env bash
# Usage: bash .devcontainer/session-config.sh on|off   (on = AI features enabled, off = disabled)
# Applies to this Codespace only (machine settings, not the repo).
# Reload the window afterwards (Developer: Reload Window).
set -euo pipefail

SETTINGS="${HOME}/.vscode-remote/data/Machine/settings.json"

case "${1:-}" in
  on|off) ;;
  *) echo "Usage: $0 on|off" >&2; exit 1 ;;
esac

mkdir -p "$(dirname "$SETTINGS")"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

python3 - "$SETTINGS" "$1" <<'PY'
import json
import sys

path, state = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
if state == "off":
    data["chat.disableAIFeatures"] = True
else:
    data.pop("chat.disableAIFeatures", None)
with open(path, "w") as f:
    json.dump(data, f, indent=4)
    f.write("\n")
PY

echo "AI features: ${1} (reload the window to apply)"
