# Vibe Coder's Guide to Tiling Windows

You just installed a window manager. Your screen is about to stop being a mess of overlapping windows you lose behind each other. Here's everything you need to know.

---

## The Big Idea: Two Workspaces

Your screen now has two invisible desktops:

- **Workspace 1** — terminals, editors, IDEs (where you write code)
- **Workspace 2** — browsers (where you look things up)

One key switches between them. No dragging. No clicking. No hunting.

---

## The Only Key You Need to Learn First

**Press F1.** That's it. You're on the other workspace.

Press it again. You're back. Everything is where you left it.

Do this ten times. Get it in your fingers. The rest is optional.

---

## The Second Key

**Press F2.** It pushes the current window to the other workspace.

Browser ended up on workspace 1? Focus it, hit F2, it's on workspace 2. Done.

---

## Moving Between Windows

All window navigation uses **Opt** (Option/Alt) + vim keys:

```
Opt + H    ← focus left
Opt + J    ↓ focus down
Opt + K    ↑ focus up
Opt + L    → focus right
```

To *move* a window instead of just focusing it, add Shift:

```
Opt + Shift + H    ← push window left
Opt + Shift + J    ↓ push window down
Opt + Shift + K    ↑ push window up
Opt + Shift + L    → push window right
```

Don't know vim keys? H is left, L is right, J is down, K is up. Your fingers learn it in a day.

---

## Resizing

```
Opt + -    shrink the focused window
Opt + =    grow the focused window
```

---

## Floating vs Tiling

Some apps don't tile well — Finder, System Settings, 1Password, utilities. Those auto-float (they stay as normal windows on top of the tiled layout).

Want to manually toggle an app between floating and tiling?

```
Opt + F    toggle floating ↔ tiling
```

---

## The Rescue Key

Windows sometimes get lost — they slide offscreen or AeroSpace loses track of them. One key fixes it:

```
Opt + Shift + R    rescue all windows (re-tile everything on current workspace)
```

This also balances window sizes. It's your "something looks wrong" button.

---

## Reloading After Config Changes

Changed a keybinding? Added an app rule? You need to reload.

Three ways (all do the same thing):

```bash
boom                          # type in any terminal
```

```
Opt + Shift + ;  then  Esc    # service mode → reload
```

```bash
aerospace reload-config       # the raw command
```

`boom` is the easiest. It also restarts AeroSpace if it's unresponsive.

---

## Service Mode

Press **Opt + Shift + ;** to enter service mode. Your normal keys stop working and these take over:

| Key | What it does |
|---|---|
| Esc | Reload config and exit service mode |
| B | Balance all window sizes and exit |
| R | Flatten the workspace tree (fixes weird nesting) and exit |

Press any of those three and you're back to normal mode.

---

## What Got Changed on Your Mac

The installer made three system changes (all reversible with `/uninstall`):

1. **Apple's built-in window tiling** — turned off (it fights with AeroSpace)
2. **Function keys** — set to standard mode (F1 = F1, not brightness)
3. **Accessibility permissions** — AeroSpace needs these to move windows

Your brightness/volume keys still work — just hold Fn first.

---

## Adding New Apps

Install a new app and it's not going to the right workspace? Two options:

```
/scan-apps    Claude scans your apps and recommends rules
/customize    tell Claude what you want ("put Slack on workspace 1")
```

You never need to edit `aerospace.toml` yourself.

---

## Quick Reference

| I want to... | Do this |
|---|---|
| Switch workspaces | F1 |
| Push window to other workspace | F2 |
| Focus another window | Opt + H/J/K/L |
| Move a window | Opt + Shift + H/J/K/L |
| Resize | Opt + - / Opt + = |
| Float/unfloat a window | Opt + F |
| Fix messed up windows | Opt + Shift + R |
| Change layout direction | Opt + / |
| Reload config | `boom` |
| Enter service mode | Opt + Shift + ; |

---

## Something Broken?

Run `/troubleshoot` in Claude Code. It checks everything automatically.

Or check the quick list:

- **Windows not tiling** → Accessibility permissions missing
- **F1 does brightness** → function keys not in standard mode
- **Windows snap weirdly** → Apple's tiling is still on
- **Config change didn't work** → run `boom`

Beyond that — this setup has been vetted. Use it for a day and you won't go back to window chaos.
