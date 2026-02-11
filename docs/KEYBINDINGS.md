# Keybindings

Everything you need to know about what your hands do. **Opt is the Option (⌥) key** on Mac keyboards.

## Day One — Just These

You can run this setup with four keys.

| Key | Action |
|---|---|
| **F1** | Toggle between workspace 1 and 2 |
| **F2** | Push focused window to the other workspace |
| **Opt+H/J/K/L** | Focus left/down/up/right (vim-style) |
| **Opt+Shift+H/J/K/L** | Move a window left/down/up/right |

## Week Two — You'll Want These

Additional bindings for layout control and service mode.

| Key | Action |
|---|---|
| **Opt+W** | Cycle focus to next window |
| **Opt+-** / **Opt+=** | Shrink / grow window |
| **Opt+/** | Toggle horizontal ↔ vertical tiles |
| **Opt+F** | Toggle floating / tiling |
| **Opt+Shift+;** | Enter service mode |
| **Service: Esc** | Reload config + exit |
| **Service: B** | Balance window sizes + exit |
| **Service: R** | Flatten workspace tree + exit |

**Service mode** is a secondary key layer. Press **Opt+Shift+;** to enter it — the keys above become active until you press one, then you're back to normal. It keeps infrequent commands out of the way without using extra keybindings.

---

## App Routing

Apps are automatically sent to the right workspace on launch:

- **Workspace 1 (Dev):** Ghostty, Terminal, iTerm2, Kitty, Alacritty, WezTerm, VS Code, Cursor
- **Workspace 2 (Browser):** Chrome, Firefox, Arc, Safari, Brave, Edge

Some apps don't work well in a tiled layout — they have fixed-size windows, popup interfaces, or aren't designed to share screen space. These float by default: Finder, System Settings, 1Password, Raycast, Adobe apps, and others. You can toggle any window between floating and tiling with **Opt+F**. Everything else opens on whichever workspace you're on.

**Want to change any of this?** Type `/customize` in Claude Code — it fetches the latest AeroSpace docs and handles the syntax for you. Or see [Customization](CUSTOMIZATION.md) for the manual approach. Full AeroSpace keybinding reference: [official docs](https://nikitabobko.github.io/AeroSpace/guide#key-mapping).
