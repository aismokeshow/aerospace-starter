# AeroSpace Starter — Setup

> For fully automated setup, run Claude Code with `--dangerously-skip-permissions`.
> Otherwise Claude will ask before each system change — which is fine, just slower.

This will set up AeroSpace tiling window management on your Mac. Every window arranges itself automatically — terminals on one workspace, browsers on another, one key to switch between them.

You don't need to know anything about tiling window managers. Just follow along.

## First-Time Setup

Triggered by: "install", "set up", "set this up", or `/install`

Work through each step in order. Explain what you're about to do and why before doing it. Assume the user has never used a terminal or tiling window manager before. If running with `--dangerously-skip-permissions`, proceed automatically but still explain each step.

### Step 1: Verify macOS

This only works on macOS. Check:
```bash
uname -s
```
Must return `Darwin`. If not, stop and tell the user this is macOS-only.

### Step 2: Check for Homebrew

Homebrew is the macOS package manager — it lets you install apps from the terminal. Check if it's already installed:
```bash
command -v brew
```

If the command is not found, Homebrew needs to be installed. Explain what it is, link to https://brew.sh, and ask for permission before running:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After install, Homebrew may print instructions about adding it to your PATH. Follow those instructions if shown — they typically look like:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Step 3: Install AeroSpace

AeroSpace is a tiling window manager — it automatically arranges your windows so they don't overlap, and lets you switch between groups of windows with a single key.

Check if already installed:
```bash
command -v aerospace
```

If not found:
```bash
brew install --cask nikitabobko/tap/aerospace
```

### Step 4: Disable Apple's Built-in Window Tiling

macOS has its own window tiling feature. It conflicts with AeroSpace — both try to control where windows go. We need to turn Apple's version off.

```bash
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
```

These are macOS preference commands. They disable:
- The automatic window tiling when you drag windows to screen edges
- The Option-key-drag tiling shortcut
- The global window manager that fights with AeroSpace

### Step 5: Set Function Keys to Standard Mode

F1 is the main key in this setup — it toggles between your two workspaces. But by default, macOS uses F1 for brightness control.

```bash
defaults write -g com.apple.keyboard.fnState -bool true
```

This makes F1 through F12 work as regular function keys. Your brightness, volume, and other media controls still work — you just hold the Fn key first.

**If the user doesn't want to change this:** offer to change the workspace toggle key from `f1` to `alt-grave` (the backtick key with Option held) in `aerospace.toml` instead.

### Step 6: Link the Config

This repo IS the config — we just need to tell AeroSpace where to find it by creating a symlink.

**First, check for conflicts:**

Check if `~/.aerospace.toml` exists:
```bash
ls -la ~/.aerospace.toml 2>/dev/null
```
If it exists: explain that AeroSpace reads this file first, before looking in `~/.config/aerospace/`. It needs to be moved out of the way. Ask permission, then:
```bash
mv ~/.aerospace.toml ~/.aerospace.toml.backup
```

Check if `~/.config/aerospace` already exists:
```bash
ls -la ~/.config/aerospace 2>/dev/null
```
If it exists as a real directory or a symlink pointing somewhere other than this repo: explain and ask permission, then:
```bash
mv ~/.config/aerospace ~/.config/aerospace.backup
```

**Now create the symlink:**
```bash
mkdir -p ~/.config
ln -sf "$(pwd)" ~/.config/aerospace
```

**Make the scripts executable:**
```bash
chmod +x *.sh
```

Explain: `~/.config/aerospace` now points to this folder. AeroSpace reads its config from here. When you edit files in this folder, you're editing the live config.

### Step 7: Set Up the Reload Command

After making changes to the config, you need to reload AeroSpace. This repo includes `boom.sh` which does that safely. We'll add a shell alias so you can type `boom` from any terminal.

Check if the alias already exists:
```bash
grep -q "alias boom=" ~/.zshrc 2>/dev/null
```

If not found, add it:
```bash
echo "" >> ~/.zshrc
echo "# AeroSpace config reload" >> ~/.zshrc
echo "alias boom='~/.config/aerospace/boom.sh'" >> ~/.zshrc
```

### Step 8: Grant Accessibility Permissions

This is the one step that can't be automated. macOS requires you to manually grant accessibility permissions to any app that manages windows. This is a security feature.

Open System Settings directly to the right pane:
```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Walk the user through it:
1. Click the **+** button (you may need to click the lock icon first and enter your password)
2. In the file browser, go to **Applications**
3. Find **AeroSpace** and select it
4. Click **Open**
5. Make sure the toggle next to AeroSpace is turned **on**

**Wait for the user to confirm they've done this before proceeding.**

### Step 9: App Discovery

Scan the user's installed apps and configure the ones that aren't already in the config. Follow the full App Discovery procedure — it's in the hub CLAUDE.md at `.claude/CLAUDE.hub.md`, or see below in this file.

This step detects what apps the user has, figures out which workspace each belongs on (or whether it should float), shows the user a summary, and applies their choices to `aerospace.toml`.

See the **App Discovery** section at the bottom of this file for the full procedure.

### Step 10: Launch AeroSpace

```bash
open -a AeroSpace
```

Wait for it to become responsive (this can take a few seconds on first launch):
```bash
sleep 3
aerospace list-workspaces --all
```

If that command works, AeroSpace is running. Reload the config to make sure everything is applied:
```bash
aerospace reload-config
```

### Step 11: Switch to Operational Mode

The setup is complete. Now swap this install CLAUDE.md for the operational version — it turns this folder into the permanent hub for managing your tiling setup.

```bash
cp .claude/CLAUDE.hub.md CLAUDE.md
```

Tell the user:

**You're tiling.** Press F1 to toggle between workspaces. Your terminals are on workspace 1, browsers on workspace 2.

This folder is now your AeroSpace command center. Come back here and open Claude Code anytime you want to:
- Add or move apps → `/scan-apps`
- Change keybindings, gaps, or layouts → just ask
- Fix something → just describe the problem
- Remove everything → `/uninstall`

You never have to edit config files yourself. Just open Claude Code here and ask.

---

## App Discovery

Triggered by: First-Time Setup Step 9, or `/scan-apps` anytime

### How to scan

1. List all .app bundles in both app directories:
```bash
ls /Applications/
ls ~/Applications/ 2>/dev/null
ls /System/Applications/ 2>/dev/null
```

2. For each .app, get its bundle ID:
```bash
mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"
```
If mdls returns `(null)` or nothing:
```bash
osascript -e 'id of app "AppName"'
```

3. Read `aerospace.toml` and collect all existing `if.app-id` values to know what's already configured.

4. Identify apps that are installed but not in any rule.

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

Show the user a clear summary grouped by category:
- **Already configured:** [list]
- **Recommended for Workspace 1:** [list with bundle IDs and one-line reasoning]
- **Recommended for Workspace 2:** [list with bundle IDs and one-line reasoning]
- **Recommended to auto-float:** [list with bundle IDs and one-line reasoning]
- **No change needed:** [list]

Ask the user if they want to apply these, modify any, or skip.

### How to apply

For each approved app, add a `[[on-window-detected]]` block to `aerospace.toml`.

Insert workspace 1 apps after the last existing workspace 1 rule (before the `# Browsers` comment).
Insert workspace 2 apps after the last existing workspace 2 rule (before the `# Auto-float` comment).
Insert auto-float apps at the end of the file.

TOML syntax:
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

After editing, reload the config:
```bash
aerospace reload-config
```
Or run `boom` if the alias is set up.
