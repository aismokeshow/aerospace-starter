# Install Procedure

Called by `/install` — Step 0 (origin verification) runs first from CLAUDE.md.

> **Already set up?** If `.installed` exists in this directory, or if AeroSpace is installed and the symlink exists (`~/.config/aerospace` → this repo), tell the user everything is already configured and offer to run `/scan-apps` to check for new apps.

Work through each step in order. Explain what you're about to do and why before doing it. Assume the user has never used a terminal or tiling window manager before.

### Step 1: Verify macOS and Fingerprint the System

This only works on macOS. Check:
```bash
uname -s
```
Must return `Darwin`. If not, stop and tell the user this is macOS-only.

Now capture the system environment. All subsequent steps reference these values.

**macOS version:**
```bash
sw_vers -productVersion
```
Extract the major version number (the part before the first dot — e.g., `15` from `15.3.1`, `13` from `13.6.4`). Store it — Step 4 needs it.

**Architecture:**
```bash
uname -m
```
`arm64` = Apple Silicon. `x86_64` = Intel. This determines the Homebrew prefix in Step 2b.

**Login shell:**
```bash
basename "$SHELL"
```
Result is `zsh`, `bash`, or `fish`. Use this table for all rc/profile file operations in Steps 2 and 7:

| Shell | RC file (aliases, interactive config) | Profile file (PATH, login env) |
|-------|--------------------------------------|-------------------------------|
| zsh   | `~/.zshrc`                           | `~/.zprofile`                 |
| bash  | `~/.bashrc`                          | `~/.bash_profile`             |
| fish  | `~/.config/fish/config.fish`         | `~/.config/fish/config.fish`  |

If `$SHELL` is empty or not one of the above, default to zsh (macOS default since Catalina).

### Step 2: Verify Xcode Command Line Tools

**Precondition:** Step 1 passed.
**Goal:** Ensure the C toolchain and system headers are available (Homebrew requires them).

```bash
xcode-select -p 2>/dev/null
```

If this fails, tell the user:

> **One thing first.** Your Mac needs Apple's developer tools installed (don't worry — it's just a standard system component, not the full Xcode app).
>
> 1. Copy and paste this into your terminal, then hit Enter:
>
> ```
> xcode-select --install
> ```
>
> 2. A popup will appear — click **"Install"** and wait for it to finish
> 3. Come back here and say **"done"**

**Wait for user confirmation before continuing.**

### Step 2b: Check for Homebrew

**Precondition:** Step 2 passed (Xcode CLT available).
**Goal:** Ensure Homebrew is available. Homebrew requires sudo, which Claude Code cannot provide — the user must install it themselves if it's not already present.

Check if already installed:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null || echo "missing"
```

If missing, tell the user exactly this (copy-paste friendly, beginner-safe):

> **One quick thing I need your help with.** Homebrew (the macOS package manager) needs your password to install, and I can't type passwords for you. This is the only manual step in the whole process.
>
> **Here's what to do:**
>
> 1. Open a new terminal window next to this one (⌘N)
> 2. Copy and paste this entire line, then hit Enter:
>
> ```
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```
>
> 3. Type your Mac password when asked (you won't see it as you type — that's normal)
> 4. Wait for it to finish (1-3 minutes)
> 5. Come back here and say **"done"**
>
> That's it — I'll handle everything else from there.

**Wait for user confirmation before continuing.** Do not proceed on silence or ambiguous responses. Only continue when the user explicitly confirms Homebrew is installed.

After Homebrew is confirmed, verify it's reachable:

```bash
/opt/homebrew/bin/brew --version 2>/dev/null || /usr/local/bin/brew --version 2>/dev/null
```

To persist Homebrew across terminal sessions, append the eval line to the user's **profile file** (from the shell table in Step 1) — but first check if it's already there (prevents duplicates on re-runs):
- zsh: `grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || echo 'eval "$(brew shellenv)"' >> ~/.zprofile`
- bash: `grep -q 'brew shellenv' ~/.bash_profile 2>/dev/null || echo 'eval "$(brew shellenv)"' >> ~/.bash_profile`
- fish: `grep -q 'brew shellenv' ~/.config/fish/config.fish 2>/dev/null || echo 'eval (brew shellenv)' >> ~/.config/fish/config.fish`

**Important:** Claude Code's Bash tool does not persist shell state between commands. `eval "$(brew shellenv)"` only affects the current command. For all subsequent `brew` commands in this procedure, **always use the absolute path**: `/opt/homebrew/bin/brew` (Apple Silicon) or `/usr/local/bin/brew` (Intel), based on the architecture from Step 1.

### Step 3: Install AeroSpace

AeroSpace is a tiling window manager — it automatically arranges your windows so they don't overlap, and lets you switch between groups of windows with a single key.

Check if already installed (the CLI may not be in PATH until the app has launched once, so check the .app bundle too):
```bash
ls /Applications/AeroSpace.app 2>/dev/null || command -v aerospace 2>/dev/null
```

If neither is found, install it. Use the absolute brew path from Step 2b if `brew` is not in PATH:
```bash
brew install --cask nikitabobko/tap/aerospace
```

After install, clear the macOS Gatekeeper quarantine flag (prevents "can't be opened" errors on first launch):
```bash
xattr -cr /Applications/AeroSpace.app 2>/dev/null
```

### Step 4: Disable Apple's Built-in Window Tiling

Apple's built-in window tiling only exists on **macOS 13 (Ventura) and later**. Check the macOS major version from Step 1.

**If macOS major version >= 13:**

macOS has its own window tiling feature. It conflicts with AeroSpace — both try to control where windows go. We need to turn Apple's version off.

```bash
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
```

> Note: `EnableTilingByEdgeDrag` and `EnableTilingOptionAccelerator` were introduced in macOS 15 (Sequoia). On earlier versions these keys are harmless no-ops — safe to run unconditionally.

These are macOS preference commands. They disable:
- The automatic window tiling when you drag windows to screen edges
- The Option-key-drag tiling shortcut
- The global window manager that fights with AeroSpace

Restart the Dock process so WindowManager picks up the changes immediately:
```bash
killall Dock
```
The Dock will relaunch automatically within a second.

Verify:
```bash
defaults read com.apple.WindowManager GloballyEnabled
```
Should output `0`.

**If macOS major version < 13:** skip this step. Tell the user: "Your macOS version doesn't have Apple's built-in window tiling, so there's nothing to disable. Skipping."

### Step 5: Set Function Keys to Standard Mode

F1 is the main key in this setup — it toggles between your two workspaces. But by default, macOS uses F1 for brightness control.

```bash
defaults write -g com.apple.keyboard.fnState -bool true
```

This makes F1 through F12 work as regular function keys. Your brightness, volume, and other media controls still work — you just hold the Fn key first.

Verify:
```bash
defaults read -g com.apple.keyboard.fnState
```
Should output `1`.

**If the user doesn't want to change this:** offer to change the workspace toggle key from `f1` to `alt-backtick` (the `` ` `` key in the top-left of your keyboard, held with Option) in `aerospace.toml` instead.

### Step 6: Link the Config

This repo IS the config — we just need to tell AeroSpace where to find it by creating a symlink.

**First, check for conflicts:**

Check if `~/.aerospace.toml` exists:
```bash
ls -la ~/.aerospace.toml 2>/dev/null
```
If it exists: explain that AeroSpace will report an ambiguity error if it finds config in both `~/.aerospace.toml` and `~/.config/aerospace/`. Back it up:
```bash
mv ~/.aerospace.toml ~/.aerospace.toml.backup
```

Check if `~/.config/aerospace` already exists:
```bash
ls -la ~/.config/aerospace 2>/dev/null
```
If it exists as a real directory or a symlink pointing somewhere other than this repo: back it up:
```bash
mv ~/.config/aerospace ~/.config/aerospace.backup
```

**Now create the symlink:**

First verify the repo path is valid (it should contain `aerospace.toml`):
```bash
ls "<absolute-path-to-this-repo>/aerospace.toml"
```
If this fails, the path is wrong — double-check it before continuing.

```bash
mkdir -p ~/.config
ln -sfn "<absolute-path-to-this-repo>" ~/.config/aerospace
```
Use the absolute path to this repo directory (the directory containing aerospace.toml). The `-n` flag is critical — without it, `ln -sf` on an existing real directory creates a symlink *inside* the directory instead of replacing it.

**Make the scripts executable:**
```bash
chmod +x <repo-path>/*.sh
```
Use the same absolute repo path as above.

Explain: `~/.config/aerospace` now points to this folder. AeroSpace reads its config from here. When you edit files in this folder, you're editing the live config.

### Step 7: Set Up the Reload Command

After making changes to the config, you need to reload AeroSpace. This repo includes `boom.sh` which does that safely. We'll add a shell alias so you can type `boom` from any terminal.

**First, read docs/cross-project-awareness.md** for context on how this project interacts with other aismokeshow starters.

Use the login shell detected in Step 1 to determine the rc file.

**Check for dotfiles-starter symlink (zsh/bash only):**

Before appending to the rc file, check if it's a symlink managed by another project:
```bash
readlink ~/.zshrc
```
(Or `readlink ~/.bashrc` for bash users.)

If the rc file IS a symlink and the target path contains `dotfiles-starter` or `zsh/.zshrc`:
1. Resolve the symlink target directory:
   ```bash
   dirname "$(readlink ~/.zshrc)"
   ```
2. Check if `aliases.zsh` exists in that directory:
   ```bash
   ls "$(dirname "$(readlink ~/.zshrc)")/aliases.zsh" 2>/dev/null
   ```
3. If found, use that `aliases.zsh` as the append target instead of `~/.zshrc`. This prevents dirtying the tracked `.zshrc` file — the dotfiles-starter `.zshrc` already sources `aliases.zsh`, so the alias will be picked up automatically.

If the rc file is NOT a symlink, or the symlink doesn't point to dotfiles-starter, or `aliases.zsh` doesn't exist — use the rc file directly (the original behavior).

Store the chosen target file path for the steps below.

**Check if the alias already exists:**

For zsh or bash — check the chosen target file:
```bash
grep -q "alias boom=" <target-file> 2>/dev/null
```

For fish:
```bash
grep -q "alias boom " ~/.config/fish/config.fish 2>/dev/null
```

**If not found, add it:**

Use the safe-merge-config skill in ENSURE-LINES mode to add the boom alias to the chosen file.

For **zsh** or **bash** — append to the chosen target file (either `aliases.zsh` or the rc file):
```bash
echo "" >> <target-file>
echo "# AeroSpace config reload" >> <target-file>
echo "alias boom='~/.config/aerospace/boom.sh'" >> <target-file>
```

For **fish** (`~/.config/fish/config.fish`):
```bash
mkdir -p ~/.config/fish
echo "" >> ~/.config/fish/config.fish
echo "# AeroSpace config reload" >> ~/.config/fish/config.fish
echo "alias boom '~/.config/aerospace/boom.sh'" >> ~/.config/fish/config.fish
```

Note: fish uses `alias boom '...'` (space, not `=`).

### Step 8: Grant Accessibility Permissions

This is the one step that can't be automated. macOS requires you to manually grant accessibility permissions to any app that manages windows. This is a security feature.

Open System Settings directly to the right pane:
```bash
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Walk the user through it:
1. Click the **+** button (macOS will prompt for your password or Touch ID to authorize the change)
2. In the file browser, go to **Applications**
3. Find **AeroSpace** and select it
4. Click **Open**
5. Make sure the toggle next to AeroSpace is turned **on**

**Wait for the user to confirm they've done this before proceeding.**

### Step 9: App Discovery

Scan the user's installed apps and configure the ones that aren't already in the config.

This step detects what apps the user has, figures out which workspace each belongs on (or whether it should float), shows the user a summary, and applies their choices to `aerospace.toml`.

Follow docs/APP-DISCOVERY.md.

### Step 10: Launch AeroSpace

```bash
open -a AeroSpace
```

Wait for it to become responsive (first launch can take 5-10 seconds):
```bash
for i in 1 2 3 4 5 6 7 8 9 10; do sleep 1; aerospace list-workspaces --all 2>/dev/null && break; done
```

If the loop finishes without output, AeroSpace is not responsive:
- Check AeroSpace is running: `pgrep -x AeroSpace`
- If not running, launch again: `open -a AeroSpace` and retry the loop
- If still failing after a second attempt, Accessibility permissions weren't granted — go back to Step 8

Reload the config to make sure everything is applied:
```bash
aerospace reload-config 2>&1
```
**Check the output.** If it reports a TOML parse error, the config has a syntax problem — read the error message, fix the offending line in `aerospace.toml`, and reload again. Do not proceed until the reload succeeds.

### Step 11: Switch to Operational Mode

The setup is complete. Now swap this install CLAUDE.md for the operational version — it turns this folder into the permanent hub for managing your tiling setup.

```bash
cp .claude/CLAUDE.hub.md CLAUDE.md
```

Note: this changes a tracked file. If you run `git status`, you'll see CLAUDE.md as modified — that's expected.

Write a marker file so future agents can detect this is an active install (even if `.git` was removed in Step 12):

```bash
date -u '+%Y-%m-%dT%H:%M:%SZ' > .installed
```

### Step 12: Clean Up Packaging (Optional)

The repo was the delivery mechanism — now strip it down to just the config.

**Before proceeding, warn the user:** "This step removes git history and packaging files. After this, you won't be able to `git pull` updates — you'd need to re-clone from scratch. If you want to keep the ability to pull future updates, say 'skip'. Otherwise, say 'continue'."

**Wait for explicit confirmation. If the user says skip, move on to the final message.**

```bash
rm -rf <repo-path>/images
rm -f <repo-path>/LICENSE <repo-path>/.gitignore
rm -rf <repo-path>/.git
```

Replace the GitHub README with a minimal operational one:

```bash
cat > <repo-path>/README.md << 'EOF'
# AeroSpace Config

Your tiling window manager lives here. Open Claude Code in this folder to manage it.

`/scan-apps` · `/customize` · `/troubleshoot` · `/uninstall`

MIT — [aismokeshow](https://www.aismokeshow.com/) · [aerospace-starter](https://github.com/aismokeshow/aerospace-starter)
EOF
```

Tell the user:

**You're tiling.** Press F1 to toggle between workspaces. Your terminals are on workspace 1, browsers on workspace 2.

This folder is now your AeroSpace command center. Come back here and open Claude Code anytime you want to:
- Add or move apps → `/scan-apps`
- Change keybindings, gaps, or layouts → `/customize`
- Fix something → `/troubleshoot`
- Remove everything → `/uninstall`

You never have to edit config files yourself. Just open Claude Code here and ask.
