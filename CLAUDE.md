# AeroSpace Starter

> For fully automated setup, run Claude Code with `--dangerously-skip-permissions`.
> Otherwise Claude will ask before each system change — which is fine, just slower.

## Project Overview

This is a portable, opinionated AeroSpace tiling config for macOS. Two workspaces, one toggle key, zero complexity.

**What each file does:**

| File | Purpose |
|---|---|
| `aerospace.toml` | The config — keybindings, gaps, and app-routing rules |
| `toggle.sh` | F1 handler — toggles between workspace 1 and 2 |
| `push-window.sh` | F2 handler — pushes focused window to the other workspace |
| `rescue.sh` | Opt+Shift+R handler — re-tiles lost/offscreen windows |
| `boom.sh` | Config reloader — validates and restarts AeroSpace safely |

**The two-workspace philosophy:**
- **Workspace 1** — terminals and editors (where you write code)
- **Workspace 2** — browsers (where you look things up)
- Everything else tiles on whichever workspace it opens on
- Apps that don't tile well (Finder, System Settings, utilities) auto-float

## First-Time Setup

Triggered by: "install", "set up", "set this up", or `/install`

Work through each step in order. Briefly explain what you're about to do before doing it. If the user is running with `--dangerously-skip-permissions`, proceed automatically but still explain each step.

### Step 1: Prerequisites

Check that we're on macOS:
```bash
uname -s  # must return "Darwin"
```

Check for Homebrew:
```bash
command -v brew
```

If Homebrew is not installed: explain that it's the macOS package manager needed to install AeroSpace. Link to https://brew.sh. Ask the user for permission before installing it with:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install AeroSpace

Check if already installed:
```bash
command -v aerospace
```

If not installed:
```bash
brew install --cask nikitabobko/tap/aerospace
```

Explain: AeroSpace is a tiling window manager for macOS — it automatically arranges windows so they don't overlap.

### Step 3: Disable Apple's Built-in Tiling

Apple's window tiling conflicts with AeroSpace — both try to manage window positions. Disable it:

```bash
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
```

### Step 4: Set Function Keys to Standard Mode

F1 is the workspace toggle key. By default macOS maps F1 to brightness control, so we need standard function key mode:

```bash
defaults write -g com.apple.keyboard.fnState -bool true
```

Media keys still work by holding Fn. If the user doesn't want to change this, offer to change the toggle key to `alt-grave` instead (edit the F1 binding in `aerospace.toml`).

### Step 5: Link the Config

First, check for conflicts:
- If `~/.aerospace.toml` exists: explain that this file-based config takes precedence over the XDG config directory. Ask to back it up (`mv ~/.aerospace.toml ~/.aerospace.toml.backup`).
- If `~/.config/aerospace` exists as a real directory (not a symlink to this repo) or as a symlink pointing somewhere else: explain and ask to back it up.

Then link this repo as the live config:
```bash
mkdir -p ~/.config
ln -sf "$(pwd)" ~/.config/aerospace
chmod +x *.sh
```

Explain: this symlink makes the repo the live config directory. Any edits here take effect on reload.

### Step 6: Set Up the Reload Command

Check if the boom alias already exists in `~/.zshrc`. If not, append it:

```bash
echo "" >> ~/.zshrc
echo "# AeroSpace config reload" >> ~/.zshrc
echo "alias boom='~/.config/aerospace/boom.sh'" >> ~/.zshrc
```

Explain: `boom` safely reloads your tiling config from any terminal after changes.

### Step 7: Grant Accessibility Permissions

This is the only step that can't be automated — macOS requires manual approval for accessibility access.

Open System Settings to the correct pane:
```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Walk the user through it:
1. Click the + button
2. Navigate to Applications
3. Find and select AeroSpace
4. Click Open

Wait for the user to confirm before proceeding.

### Step 8: App Discovery

Follow the App Discovery procedure below to scan installed apps, compare against the config, and present recommendations.

### Step 9: Launch

Start AeroSpace:
```bash
open -a AeroSpace
```

Wait for it to become responsive:
```bash
aerospace list-workspaces --all
```

Reload the config:
```bash
aerospace reload-config
```

Tell the user:
- Press F1 to toggle between workspaces
- Their terminals are on workspace 1, browsers on workspace 2
- Type `boom` after any config change to reload
- Run `/scan-apps` anytime to add new apps

## App Discovery

Triggered by: First-Time Setup Step 8, or `/scan-apps` anytime

### How to scan

1. List all .app bundles:
```bash
ls /Applications/
ls ~/Applications/ 2>/dev/null
```

2. For each .app, get its bundle ID:
```bash
mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"
```
If mdls returns nothing (common for some apps):
```bash
osascript -e 'id of app "AppName"'
```

3. Read `aerospace.toml` and collect all existing `if.app-id` values

4. Identify apps that are installed but not in any rule

### How to categorize

Use these heuristics for unconfigured apps:

**Workspace 1** (terminals & editors):
Terminal emulators, code editors, IDEs.
Examples: Xcode, Zed, Sublime Text, Nova, Warp, Rio, JetBrains apps (IntelliJ, PyCharm, WebStorm, etc.)

**Workspace 2** (browsers):
Web browsers.
Examples: Opera, Vivaldi, Orion, Zen Browser, Wavebox, SigmaOS, Sidekick

**Auto-float** (don't tile well):
System utilities, password managers, creative tools, VPN clients, screen recorders, menubar-only apps, settings/preferences apps, hardware config apps, small single-purpose windows, AI assistants.
Examples: Raycast, Alfred, 1Password, Bartender, iStat Menus, Adobe apps, Figma, Sketch, OBS

**No rule needed** (default tiling works fine):
Standard windowed apps — chat, notes, email, music, document editors, project management.
Examples: Slack, Discord, Messages, Notes, Notion, Obsidian, Spotify, Mail

### How to present

Show the user a clear summary:
- **Already configured:** [list]
- **Recommended for Workspace 1:** [list with bundle IDs and reasoning]
- **Recommended for Workspace 2:** [list with bundle IDs and reasoning]
- **Recommended to auto-float:** [list with bundle IDs and reasoning]
- **No change needed:** [list]

Ask the user if they want to apply these, modify any, or skip.

### How to apply

For each approved app, append a rule to the appropriate section of `aerospace.toml`. The file has clear section markers:
- Line containing `# Terminals & Editors` → workspace 1 rules
- Line containing `# Browsers` → workspace 2 rules
- Line containing `# Auto-float` → floating rules

TOML syntax for each rule:
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'move-node-to-workspace 1'
```

For auto-float:
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'layout floating'
```

After editing, run `boom` (or `aerospace reload-config`) to apply.

## Uninstall

Triggered by: "uninstall", "remove", or `/uninstall`

Before removing anything, check the current system state — only undo what was actually set up.

1. **Remove config symlink** (only if it points to this repo):
```bash
# Verify it's our symlink first
readlink ~/.config/aerospace
rm ~/.config/aerospace
```

2. **Remove boom alias from ~/.zshrc:**
Find and remove the `alias boom=` line and its `# AeroSpace config reload` comment.

3. **Restore function keys to media mode:**
```bash
defaults write -g com.apple.keyboard.fnState -bool false
```

4. **Re-enable Apple's tiling:**
```bash
defaults write com.apple.WindowManager GloballyEnabled -bool true
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true
```

5. Tell the user: to fully remove AeroSpace, run:
```bash
brew uninstall --cask nikitabobko/tap/aerospace
```

6. Tell the user: remove AeroSpace from **System Settings → Privacy & Security → Accessibility**

7. Tell the user: this repo is still on disk and safe to delete if desired

## Customization Reference

**Find a bundle ID:**
```bash
mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"
# or
osascript -e 'id of app "AppName"'
```

**Add an app rule** — append to the appropriate section in `aerospace.toml`:
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'move-node-to-workspace 1'    # 1 for editors, 2 for browsers
# or: run = 'layout floating'      # for apps that don't tile well
```

**Change keybindings** — edit the `[mode.main.binding]` section in `aerospace.toml`

**Reload after changes** — type `boom` in any terminal, or press Opt+Shift+; then Esc

**Detailed guides:** see `docs/` for [Keybindings](docs/KEYBINDINGS.md), [Customization](docs/CUSTOMIZATION.md), and [Troubleshooting](docs/TROUBLESHOOTING.md)
