# AeroSpace Starter

This folder is your AeroSpace command center. Open Claude Code here and ask for what you want — add apps, change keybindings, troubleshoot, or tweak your layout. You never need to edit config files manually.

**Slash commands:** `/install`, `/scan-apps`, `/customize`, `/troubleshoot`, `/uninstall`

The instructions below tell Claude Code how to manage everything. You can read along if you're curious, but you don't have to.

**What's below:** A reference for every file, keybinding, and config section. Useful if you want to understand how things work — and it's what Claude Code reads when you ask it to make changes.

## Project Architecture

```
aerospace-starter/
├── CLAUDE.md                              ← Install-phase instructions (you're reading the hub replacement)
├── aerospace.toml                         ← The config — keybindings, gaps, app-routing rules
├── toggle.sh, push-window.sh, rescue.sh   ← Runtime keybinding scripts (F1, F2, Opt+Shift+R)
├── boom.sh                                ← Config reloader (what the `boom` alias calls)
├── docs/
│   ├── INSTALL-PROCEDURE.md               ← 12-step atomic install manifest
│   ├── APP-DISCOVERY.md                   ← App scanning and categorization procedure
│   ├── KEYBINDINGS.md                     ← Full keybinding reference
│   ├── CUSTOMIZATION.md                   ← How to add apps, change keys, add workspaces
│   ├── TROUBLESHOOTING.md                 ← Common problems and fixes
│   ├── SETUP.md                           ← Manual setup guide (for users without Claude Code)
│   ├── UNINSTALL.md                       ← Full uninstall procedure
│   └── cross-project-awareness.md         ← Sibling starter detection and preservation
├── .claude/
│   ├── CLAUDE.hub.md                      ← THIS FILE — operational reference
│   ├── agents/
│   │   └── install-aerospace.md           ← Install agent (orchestrates full setup)
│   ├── skills/
│   │   └── safe-merge-config/SKILL.md     ← Non-destructive config file modifier
│   └── commands/                          ← Slash command dispatchers
└── images/                                ← README hero images
```

**Agents:** The `install-aerospace` agent reads `docs/INSTALL-PROCEDURE.md` at runtime and uses the safe-merge-config skill to execute the install. It does not contain inlined procedures — it orchestrates.

**Skills:**
- `safe-merge-config` — three modes: SYMLINK (replace file with symlink), ENSURE-LINES (append missing lines), WRITE-IF-MISSING (create only if absent). Always backs up, never silently discards content.

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

## aerospace.toml Structure

The config file has these sections in order:

1. **Header** — config version, start-at-login, normalization settings
2. **`[exec.env-vars]`** — PATH for Homebrew (covers both Apple Silicon and Intel)
3. **`[gaps]`** — window gaps (inner and outer padding, default 8px)
4. **`[mode.main.binding]`** — primary keybindings (F1, F2, Opt+vim keys, etc.)
5. **`[mode.service.binding]`** — service mode (Esc to reload, B to balance, R to flatten)
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
| Service: R | Flatten workspace tree + exit | — |

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

## Companion Starters

Other aismokeshow starters may be installed alongside this one. See `docs/cross-project-awareness.md` for detection rules, artifact preservation, and integration details.

Key interactions:
- **dotfiles-starter** — if detected, the boom alias is appended to `aliases.zsh` instead of `~/.zshrc` to avoid dirtying tracked files
- **statusline-starter** — runs independently via `~/.claude/settings.json`, no config interaction

---

## First-Time Setup

Triggered by: `/install`

If AeroSpace is installed, the symlink exists (`~/.config/aerospace` → this repo), and the config is linked, tell the user everything is already configured and offer to run `/scan-apps` to check for new apps.

Otherwise, the `install-aerospace` agent handles the full setup. It reads `docs/INSTALL-PROCEDURE.md` and executes all 12 steps, using the `safe-merge-config` skill for shell config file changes.

## App Discovery

Triggered by: `/scan-apps`

Follow docs/APP-DISCOVERY.md.

## Uninstall

Triggered by: `/uninstall`

Follow docs/UNINSTALL.md.
