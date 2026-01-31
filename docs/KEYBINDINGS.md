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

---

## App Routing

Apps are automatically sent to the right workspace on launch:

- **Workspace 1 (Dev):** Ghostty, Terminal, iTerm2, Kitty, Alacritty, WezTerm, VS Code, Cursor
- **Workspace 2 (Browser):** Chrome, Firefox, Arc, Safari, Brave, Edge

Apps that don't tile well — CleanShot, Photoshop, Illustrator, Premiere Pro, ProtonVPN, and several others — float by default. You can toggle any window between floating and tiling with **Opt+F**. Everything else opens on whichever workspace you're on.

**Want to change any of this?** See [Customization](CUSTOMIZATION.md). For the full AeroSpace keybinding reference, see the [official docs](https://nikitabobko.github.io/AeroSpace/guide#key-mapping).
