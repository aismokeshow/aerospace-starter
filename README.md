# Opinionated AeroSpace Window Tiling Starter for macOS by AISMOKESHOW
### Two workspaces. One key. Done.

An opinionated tiling setup for macOS. Terminals on workspace 1, browsers on workspace 2, F1 to toggle. No SIP hacks, no skhd, no 200-line config.

If you've tried yabai and got lost in the flags, tried Amethyst and fought the defaults, or tried Apple's built-in tiling and wondered who it was designed for — stop. This is the one.

![AeroSpace Starter](images/aerospace-ais-readme-v2.jpg)

## How It Works

- **Workspace 1** is for terminals and editors — Ghostty, Kitty, VS Code, Cursor, and more
- **Workspace 2** is for browsers — Chrome, Firefox, Arc, Safari, Brave, Edge
- **F1** toggles between them. **F2** pushes a window across.
- Windows tile themselves — no manual dragging or resizing needed
- Change the config, type `boom`, everything reloads

## Quick Start

```bash
brew install --cask nikitabobko/tap/aerospace
git clone https://github.com/aismokeshow/aerospace-starter.git
cd aerospace-starter && ln -sf "$PWD" ~/.config/aerospace
```

There are a few macOS settings you need to flip before things work right. Takes two minutes — the [Setup Guide](docs/SETUP.md) walks you through it.

## Keybindings

| Key | Action |
|---|---|
| **F1** | Toggle workspace 1 ↔ 2 |
| **F2** | Push window to other workspace |
| **Opt+H/J/K/L** | Focus left/down/up/right |
| **Opt+Shift+H/J/K/L** | Move window left/down/up/right |

**Opt is the Option (⌥) key** on Mac keyboards. That's just day one — there's more in the [full keybindings](docs/KEYBINDINGS.md).

## Keep Going

- **[Setup Guide](docs/SETUP.md)** — two minutes of macOS settings, then you're done forever
- **[Keybindings](docs/KEYBINDINGS.md)** — day-one keys, power-user keys, and where your apps land
- **[Customization](docs/CUSTOMIZATION.md)** — add your apps, change your keys, make it yours
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** — something broke? it's probably a one-liner

## License

AeroSpace Starter is released under the [MIT License](LICENSE).

---

<p align="center"><sub>built by <a href="https://www.aismokeshow.com/">aismokeshow</a> · where there's boom, there's smoke</sub></p>
