#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_SRC="$SKILL_DIR/assets/readable-dark.yaml"
THEME_DST="$HOME/.hermes/dashboard-themes/readable-dark.yaml"

if [[ ! -f "$THEME_SRC" ]]; then
  echo "Theme asset not found: $THEME_SRC" >&2
  exit 1
fi

mkdir -p "$(dirname "$THEME_DST")"
cp "$THEME_SRC" "$THEME_DST"

if command -v hermes >/dev/null 2>&1; then
  hermes config set dashboard.theme readable-dark
  hermes config set dashboard.font system-sans
else
  cat >&2 <<'EOF'
hermes CLI not found on PATH.
The theme file was installed, but you must set these config values manually:
  dashboard.theme: readable-dark
  dashboard.font: system-sans
EOF
fi

"$SKILL_DIR/scripts/doctor.sh"

echo "Installed readable-dark dashboard theme. Refresh or restart the Hermes dashboard if it is already open."
