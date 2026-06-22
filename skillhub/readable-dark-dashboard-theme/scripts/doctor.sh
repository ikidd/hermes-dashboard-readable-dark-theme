#!/usr/bin/env bash
set -euo pipefail

THEME="$HOME/.hermes/dashboard-themes/readable-dark.yaml"

if [[ ! -f "$THEME" ]]; then
  echo "Missing installed theme: $THEME" >&2
  exit 1
fi

require_text() {
  local pattern="$1"
  local file="$2"
  local label="$3"
  if ! grep -Eq "$pattern" "$file"; then
    echo "Missing expected $label in $file" >&2
    exit 1
  fi
}

require_text '^name:[[:space:]]*readable-dark[[:space:]]*$' "$THEME" 'theme name'
require_text 'noiseOpacity:[[:space:]]*0([.]0)?[[:space:]]*$' "$THEME" 'noiseOpacity: 0'
require_text 'baseSize:[[:space:]]*"20px"[[:space:]]*$' "$THEME" '20px base font size'
require_text 'fillerOpacity:[[:space:]]*"0"[[:space:]]*$' "$THEME" 'disabled filler opacity'
require_text 'font-mondwest' "$THEME" 'novelty font override CSS'

if ! command -v hermes >/dev/null 2>&1; then
  echo "Theme file checks passed. hermes CLI is unavailable, so config values were not checked."
  exit 0
fi

CONFIG="$(hermes config path)"
if [[ ! -f "$CONFIG" ]]; then
  echo "Hermes reported a config path that does not exist: $CONFIG" >&2
  exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  set +e
  python3 - "$THEME" "$CONFIG" <<'PY'
from pathlib import Path
import sys
try:
    import yaml
except Exception:
    raise SystemExit(77)

theme = yaml.safe_load(Path(sys.argv[1]).read_text()) or {}
cfg = yaml.safe_load(Path(sys.argv[2]).read_text()) or {}

dash = cfg.get('dashboard') or {}
assert theme.get('name') == 'readable-dark', 'theme.name is not readable-dark'
assert (theme.get('palette') or {}).get('noiseOpacity') == 0, 'noiseOpacity is not 0'
assert (theme.get('typography') or {}).get('baseSize') == '20px', 'baseSize is not 20px'
assert ((theme.get('componentStyles') or {}).get('backdrop') or {}).get('fillerOpacity') == '0', 'fillerOpacity is not 0'
assert dash.get('theme') == 'readable-dark', 'dashboard.theme is not readable-dark'
assert dash.get('font') == 'system-sans', 'dashboard.font is not system-sans'
PY
  py_status=$?
  set -e
  if [[ "$py_status" -eq 0 ]]; then
    echo "readable-dark dashboard theme OK"
    exit 0
  elif [[ "$py_status" -ne 77 ]]; then
    echo "Python YAML validation failed" >&2
    exit "$py_status"
  fi
fi

# Fallback when python/PyYAML is unavailable. Less strict, but catches the expected config values.
require_text 'theme:[[:space:]]*["'"'"']?readable-dark["'"'"']?[[:space:]]*$' "$CONFIG" 'dashboard theme config'
require_text 'font:[[:space:]]*["'"'"']?system-sans["'"'"']?[[:space:]]*$' "$CONFIG" 'dashboard font config'

echo "readable-dark dashboard theme OK"
