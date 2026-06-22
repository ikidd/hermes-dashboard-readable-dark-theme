#!/usr/bin/env bash
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
theme_src="$src_dir/themes/readable-dark.yaml"
theme_dst="$HOME/.hermes/dashboard-themes/readable-dark.yaml"

mkdir -p "$(dirname "$theme_dst")"
cp "$theme_src" "$theme_dst"

if command -v hermes >/dev/null 2>&1; then
  hermes config set dashboard.theme readable-dark
  hermes config set dashboard.font system-sans
else
  printf 'Installed %s
' "$theme_dst"
  printf 'hermes CLI not found on PATH; set dashboard.theme=readable-dark and dashboard.font=system-sans manually.
' >&2
fi

python3 - <<'PY'
from pathlib import Path
try:
    import yaml
except Exception as exc:
    raise SystemExit(f'PyYAML unavailable; installed theme but could not validate YAML: {exc}')
p = Path.home() / '.hermes/dashboard-themes/readable-dark.yaml'
data = yaml.safe_load(p.read_text())
assert data['name'] == 'readable-dark'
assert data['palette']['noiseOpacity'] == 0
assert data['typography']['baseSize'] == '20px'
assert data['componentStyles']['backdrop']['fillerOpacity'] == '0'
print(f'validated {p}')
PY
