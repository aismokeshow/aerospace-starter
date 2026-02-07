# AeroSpace Starter

This is the user's AeroSpace tiling window manager config. This folder is the command center — the user comes here and asks Claude Code to make changes. They should never need to edit files manually.

## How This Works

- `~/.config/aerospace` is a symlink pointing to this folder
- AeroSpace reads `aerospace.toml` from this folder as its live config
- Edits to files here take effect after running `boom` (or `aerospace reload-config`)
- The 4 shell scripts (toggle.sh, push-window.sh, rescue.sh, boom.sh) are called by AeroSpace keybindings via `exec-and-forget` — they can't be inlined because AeroSpace requires external scripts for multi-step logic

## The Two-Workspace Philosophy

- **Workspace 1** — terminals and editors (where you write code)
- **Workspace 2** — browsers (where you look things up)
- **F1** toggles between them, **F2** pushes a window across
- Apps that don't tile well auto-float (Finder, System Settings, utilities, etc.)
- Everything else tiles on whichever workspace it opens on

## Project Files

| File | What it does |
|---|---|
| `aerospace.toml` | The config — keybindings, gaps, window padding, and all app-routing rules |
| `toggle.sh` | F1 handler — toggles between workspace 1 and 2 |
| `push-window.sh` | F2 handler — pushes focused window to the other workspace |
| `rescue.sh` | Opt+Shift+R handler — re-tiles lost/offscreen windows |
| `boom.sh` | Config reloader — validates and restarts AeroSpace safely |
| `docs/SETUP.md` | Manual setup guide (for users not using Claude Code) |
| `docs/KEYBINDINGS.md` | Full keybinding reference |
| `docs/CUSTOMIZATION.md` | How to add apps, change keys, add workspaces |
| `docs/TROUBLESHOOTING.md` | Common problems and fixes |

## aerospace.toml Structure

The config file has these sections in order:

1. **Header** — config version, start-at-login, normalization settings
2. **`[exec.env-vars]`** — PATH for Homebrew (covers both Apple Silicon and Intel)
3. **`[gaps]`** — window gaps (inner and outer padding, default 8px)
4. **`[mode.main.binding]`** — primary keybindings (F1, F2, Opt+vim keys, etc.)
5. **`[mode.service.binding]`** — service mode (Esc to reload, B to balance)
6. **Window detection rules** — `[[on-window-detected]]` blocks:
   - Section marked `# Terminals & Editors → workspace 1`
   - Section marked `# Browsers → workspace 2`
   - Section marked `# Auto-float — apps that don't tile well`
   - Sub-section `# macOS system apps that don't tile well`
   - Sub-section `# Common utilities`

### Where to insert new app rules

- **Workspace 1 apps:** Add after the last `run = 'move-node-to-workspace 1'` block, before the `# Browsers → workspace 2` comment
- **Workspace 2 apps:** Add after the last `run = 'move-node-to-workspace 2'` block, before the `# Auto-float` comment
- **Auto-float apps:** Add at the end of the file

### TOML syntax for app rules

Assign to a workspace:
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'move-node-to-workspace 1'
```

Auto-float:
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'layout floating'
```

Always leave a blank line between `[[on-window-detected]]` blocks.

### How to find bundle IDs

```bash
mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"
```

If mdls returns `(null)`:
```bash
osascript -e 'id of app "AppName"'
```

## Keybindings Reference

| Key | Action | Script |
|---|---|---|
| F1 | Toggle workspace 1 ↔ 2 | toggle.sh |
| F2 | Push window to other workspace | push-window.sh |
| Opt+H/J/K/L | Focus left/down/up/right | — |
| Opt+Shift+H/J/K/L | Move window | — |
| Opt+W | Cycle focus next | — |
| Opt+- / Opt+= | Shrink / grow | — |
| Opt+/ | Toggle horizontal ↔ vertical | — |
| Opt+F | Toggle floating / tiling | — |
| Opt+Shift+R | Rescue lost windows | rescue.sh |
| Opt+Shift+; | Enter service mode | — |
| Service: Esc | Reload config + exit | — |
| Service: B | Balance sizes + exit | — |

Keybindings are in `[mode.main.binding]` and `[mode.service.binding]` in `aerospace.toml`.

## Reloading

After any config change:
- Type `boom` in any terminal (runs boom.sh)
- Or press Opt+Shift+; then Esc (service mode → reload)
- Or run `aerospace reload-config` directly

## Troubleshooting Quick Reference

- **Windows not tiling:** Check Accessibility permissions (System Settings → Privacy & Security → Accessibility → AeroSpace must be on)
- **F1 doesn't work:** Standard function keys not enabled. Run: `defaults write -g com.apple.keyboard.fnState -bool true`
- **Windows fight/snap weirdly:** Apple tiling still on. Run: `defaults write com.apple.WindowManager GloballyEnabled -bool false`
- **Config change didn't apply:** Run `boom` or `aerospace reload-config`
- **AeroSpace unresponsive:** Run `boom` — it handles restart automatically
- **Windows disappeared / blank tiles:** Press Opt+Shift+R to rescue. Avoid Cmd+M (native minimize) — it causes ghost tiles.

Full troubleshooting: `docs/TROUBLESHOOTING.md`

---

## First-Time Setup

Triggered by: "install", "set up", "set this up", or `/install`

If this setup has already been completed (the symlink exists, AeroSpace is installed), tell the user everything is already configured and offer to run `/scan-apps` to check for new apps.

Work through each step in order. Explain what you're about to do and why before doing it. Assume the user has never used a terminal or tiling window manager before. If running with `--dangerously-skip-permissions`, proceed automatically but still explain each step.

### Step 1: Verify macOS

```bash
uname -s
```
Must return `Darwin`. If not, stop — this is macOS-only.

### Step 2: Check for Homebrew

```bash
command -v brew
```

If not found: explain it's the macOS package manager needed to install AeroSpace. Link to https://brew.sh. Ask permission, then:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After install, Homebrew may print PATH instructions. Follow them — typically:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Step 3: Install AeroSpace

```bash
command -v aerospace
```

If not found:
```bash
brew install --cask nikitabobko/tap/aerospace
```

### Step 4: Disable Apple's Built-in Window Tiling

Apple's tiling conflicts with AeroSpace — both try to control window positions.

```bash
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
```

### Step 5: Set Function Keys to Standard Mode

F1 is the workspace toggle. macOS defaults it to brightness.

```bash
defaults write -g com.apple.keyboard.fnState -bool true
```

Media keys still work with Fn held. If the user doesn't want this, offer to change the toggle key to `alt-grave` instead.

### Step 6: Link the Config

Check for conflicts first:
- `~/.aerospace.toml` — if exists, back up (`mv ~/.aerospace.toml ~/.aerospace.toml.backup`)
- `~/.config/aerospace` — if exists as real directory or wrong symlink, back up

Then:
```bash
mkdir -p ~/.config
ln -sf "$(pwd)" ~/.config/aerospace
chmod +x *.sh
```

### Step 7: Set Up the Reload Command

```bash
grep -q "alias boom=" ~/.zshrc 2>/dev/null
```

If not found:
```bash
echo "" >> ~/.zshrc
echo "# AeroSpace config reload" >> ~/.zshrc
echo "alias boom='~/.config/aerospace/boom.sh'" >> ~/.zshrc
```

### Step 8: Grant Accessibility Permissions

Can't be automated — macOS security restriction.

```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Walk user through: click +, find AeroSpace in Applications, add it, make sure toggle is on. **Wait for user confirmation.**

### Step 9: App Discovery

Follow the App Discovery procedure below.

### Step 10: Launch

```bash
open -a AeroSpace
sleep 3
aerospace list-workspaces --all
aerospace reload-config
```

Tell user to press F1 to test.

## App Discovery

Triggered by: First-Time Setup Step 9, or `/scan-apps` anytime

### How to scan

1. List all .app bundles:
```bash
ls /Applications/
ls ~/Applications/ 2>/dev/null
ls /System/Applications/ 2>/dev/null
```

2. For each .app, get its bundle ID:
```bash
mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"
```
Fallback:
```bash
osascript -e 'id of app "AppName"'
```

3. Read `aerospace.toml` and collect all existing `if.app-id` values.

4. Identify installed apps not in any rule.

### How to categorize

**Workspace 1** (terminals & editors): Terminal emulators, code editors, IDEs.
Examples: Xcode, Zed, Sublime Text, Nova, Warp, Rio, JetBrains apps

**Workspace 2** (browsers): Web browsers.
Examples: Opera, Vivaldi, Orion, Zen Browser, Wavebox, SigmaOS, Sidekick

**Auto-float** (don't tile well): System utilities, password managers, creative tools, VPN clients, screen recorders, menubar-only apps, settings apps, hardware config apps, small windows, AI assistants.
Examples: Raycast, Alfred, 1Password, Bartender, iStat Menus, Adobe apps, Figma, Sketch, OBS

**No rule needed** (default tiling works): Standard windowed apps — chat, notes, email, music, docs, project management.
Examples: Slack, Discord, Messages, Notes, Notion, Obsidian, Spotify, Mail

### How to present

Show grouped summary:
- **Already configured:** [list]
- **Recommended for Workspace 1:** [list with bundle IDs and reasoning]
- **Recommended for Workspace 2:** [list with bundle IDs and reasoning]
- **Recommended to auto-float:** [list with bundle IDs and reasoning]
- **No change needed:** [list]

Ask user to approve, modify, or skip.

### How to apply

Insert rules into the correct section of `aerospace.toml`:
- Workspace 1 → before `# Browsers → workspace 2`
- Workspace 2 → before `# Auto-float — apps that don't tile well`
- Auto-float → end of file

After editing, reload: `aerospace reload-config` or `boom`.

## Uninstall

Triggered by: "uninstall", "remove", or `/uninstall`

Check the current state before removing anything. Only undo what was actually set up.

1. **Remove config symlink** (only if it's a symlink pointing to this repo):
```bash
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

5. Tell the user — to fully remove AeroSpace:
```bash
brew uninstall --cask nikitabobko/tap/aerospace
```

6. Tell the user: remove AeroSpace from System Settings → Privacy & Security → Accessibility

7. Tell the user: this repo folder is still on disk and safe to delete if desired
