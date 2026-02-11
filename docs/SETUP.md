# Setup Guide

> **Using Claude Code?** Type `/install` — it handles Homebrew, AeroSpace, config linking, macOS settings, and app scanning. The only manual step is granting Accessibility permissions when prompted. Everything below is the manual path for users not using Claude Code.

You need AeroSpace installed and the repo cloned first — if you haven't done that, start with the [Install section](../README.md#install).

Now make macOS cooperate.

## 1. Turn off Apple's tiling

It conflicts. Go to **System Settings → Desktop & Dock → Windows** and turn off all the tiling and snapping toggles.

Or via terminal:
```bash
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
```

## 2. Grant Accessibility permissions

**System Settings → Privacy & Security → Accessibility** → add AeroSpace.

## 3. Enable standard function keys

We use F1 as the toggle key because it's the easiest key to hit without looking and nothing important uses it. By default macOS maps it to brightness, so flip one setting:

**System Settings → Keyboard → Keyboard Shortcuts → Function Keys** → toggle on **Use F1, F2, etc. keys as standard function keys**

Or via terminal:
```bash
defaults write -g com.apple.keyboard.fnState -bool true
```

Your media keys still work — just hold **Fn** first. If you'd rather not change this, swap `f1` for something like `alt-backtick` (the `` ` `` key, top-left corner) in `aerospace.toml` and skip this step.

## 4. Set up the reload command

This repo includes `boom.sh` — a script that safely restarts and reloads AeroSpace. Add an alias to your shell config:

**zsh** (macOS default) — add to `~/.zshrc`:
```bash
alias boom='~/.config/aerospace/boom.sh'
```

**bash** — add to `~/.bashrc`:
```bash
alias boom='~/.config/aerospace/boom.sh'
```

**fish** — add to `~/.config/fish/config.fish`:
```fish
alias boom '~/.config/aerospace/boom.sh'
```

Then reload your shell config (e.g., `source ~/.zshrc`). Now you can type `boom` from any terminal to reload your config. You'll use this a lot.

## 5. Launch

Open AeroSpace from Applications or Spotlight. Your windows will immediately rearrange — that's the point. Terminals go to workspace 1, browsers go to workspace 2.

It starts automatically on login from now on.

**You're tiling.** Go hit F1 a few times, then check out the [full keybindings](KEYBINDINGS.md).

---

## Uninstall

> **Using Claude Code?** Type `/uninstall` — it checks your system state and only reverses what was actually set up (symlinks, aliases, macOS settings). Everything below is the manual removal path.

```bash
[ -L ~/.config/aerospace ] && rm ~/.config/aerospace || rm -rf ~/.config/aerospace  # remove symlink or directory
brew uninstall --cask nikitabobko/tap/aerospace   # remove app
```

Restore macOS settings:
```bash
defaults write -g com.apple.keyboard.fnState -bool false
# Only run these three if on macOS 13 (Ventura) or later:
defaults write com.apple.WindowManager GloballyEnabled -bool true
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true
```

Remove the boom alias from your shell config (`~/.zshrc` for zsh, `~/.bashrc` for bash, `~/.config/fish/config.fish` for fish) and remove AeroSpace from **System Settings → Privacy & Security → Accessibility**.
