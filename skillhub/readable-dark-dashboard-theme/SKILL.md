---
name: readable-dark-dashboard-theme
description: Install and activate a readability-first dark theme for the Hermes Agent web dashboard.
version: 1.0.0
author: Ian Kidd
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [hermes, dashboard, theme, readability, dark-theme]
    requires_toolsets: [terminal, file]
---

# Readable Dark Dashboard Theme

Use this when the user wants a neutral, readable dark theme for the Hermes Agent web dashboard instead of the default Nous/Hermes Teal visual style.

## What it does

- Installs `readable-dark.yaml` into `~/.hermes/dashboard-themes/`
- Sets `dashboard.theme` to `readable-dark`
- Sets `dashboard.font` to `system-sans`
- Uses a neutral slate/blue palette with high-contrast text
- Uses larger `20px` system fonts and comfortable line height
- Disables decorative grain/filler and novelty display fonts through theme CSS

## Quick install

Run:

```bash
${HERMES_SKILL_DIR}/scripts/install.sh
```

Then refresh or restart the Hermes dashboard if it is already open.

## Verify

Run:

```bash
${HERMES_SKILL_DIR}/scripts/doctor.sh
```

Expected output ends with:

```text
readable-dark dashboard theme OK
```

## Manual install

If the helper script cannot run, copy the bundled theme manually:

```bash
mkdir -p ~/.hermes/dashboard-themes
cp ${HERMES_SKILL_DIR}/assets/readable-dark.yaml ~/.hermes/dashboard-themes/readable-dark.yaml
hermes config set dashboard.theme readable-dark
hermes config set dashboard.font system-sans
```

## Verification details

A correct install should have:

- the readable-dark user theme file present under the Hermes dashboard themes directory
- `dashboard.theme: readable-dark` in Hermes config
- `dashboard.font: system-sans` in Hermes config
- theme YAML containing `noiseOpacity: 0`, `baseSize: "20px"`, and `fillerOpacity: "0"`

For visual verification, open the dashboard. The page should use a slate background, plain system UI typography, readable larger text, and no large default artwork/filler backdrop.

## Pitfalls

- The dashboard may need a browser refresh or service restart before the visual change appears.
- If the dashboard still says `Hermes Teal` in the theme switcher, verify Hermes has discovered user themes and that Hermes config has `dashboard.theme` set to `readable-dark`.
- If the dashboard is running in a browser container, `127.0.0.1` inside that container may not be the host dashboard. Use the host gateway address when taking screenshots from containerized browser automation.
- Do not edit bundled dashboard source themes for this; the intended install path is the user theme directory under `~/.hermes/dashboard-themes/`.
