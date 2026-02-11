---
description: Change keybindings, app routing, gaps, workspaces, or layouts
---

Use the customize-aerospace agent to handle this request.

Pass along whatever the user wants to change — keybindings, app routing,
gaps, workspaces, layouts, or any other AeroSpace config modification.

If the customize-aerospace agent is not available, handle the request directly:

1. Read `aerospace.toml` to understand the current config state.
2. Read `.claude/CLAUDE.hub.md` for the config structure reference
   (section order, anchor comments for insertion points, TOML syntax).
3. For app routing: look up the bundle ID with
   `mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"`
   (fallback: `osascript -e 'id of app "AppName"'`).
   Insert the rule in the correct section using the anchor comments.
4. For keybinding changes: check the AeroSpace docs at
   https://nikitabobko.github.io/AeroSpace/guide#configuring-aerospace
   to verify syntax. Warn if the binding conflicts with an existing one.
5. Show the user what will change before applying.
6. After editing, reload with `~/.config/aerospace/boom.sh` or
   `aerospace reload-config`.

If the user wants to bulk-detect and configure all their installed apps,
use the "App Discovery" procedure in CLAUDE.md instead (or suggest /scan-apps).
