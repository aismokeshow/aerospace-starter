# Opinionated AeroSpace Window Tiling Starter for macOS by AISMOKESHOW
### Two workspaces. One key. Done.

An opinionated tiling setup for macOS. Terminals on workspace 1, browsers on workspace 2, F1 to toggle. No SIP hacks, no skhd, no 200-line config.

If you've gone down the yabai rabbit hole, wrestled with Amethyst's defaults, or tried Apple's built-in tiling and thought "who is this even for" — just stop. This is the one. Even if you've tried AeroSpace before and bounced off it, that's probably because you overcomplicated it. Start here instead.

![AeroSpace Starter](images/aerospace-ais-readme-v2.jpg)

## How It Works

- **Workspace 1** is for terminals and editors — Ghostty, Kitty, VS Code, Cursor, and more
- **Workspace 2** is for browsers — Chrome, Firefox, Arc, Safari, Brave, Edge
- **F1** toggles between them. **F2** pushes a window across.
- Windows tile themselves — no manual dragging or resizing needed
- Change the config, type `boom`, everything reloads

## Get Started

> [!TIP]
> **Fastest path: use [Claude Code](https://claude.ai/claude-code)**
>
> ```bash
> git clone https://github.com/aismokeshow/aerospace-starter.git
> cd aerospace-starter
> claude --dangerously-skip-permissions
> ```
> Then type `install`. Claude handles Homebrew, AeroSpace, config linking,
> macOS settings, and scans your apps to customize the config. The only
> manual step is granting Accessibility permissions in System Settings.
>
> You can also type `/install`, `/scan-apps`, or `/uninstall` at any time.

<details>
<summary><strong>Manual setup (without Claude Code)</strong></summary>

```bash
# 1. Install AeroSpace
brew install --cask nikitabobko/tap/aerospace

# 2. Clone this repo
git clone https://github.com/aismokeshow/aerospace-starter.git
cd aerospace-starter

# 3. Link as your AeroSpace config
mkdir -p ~/.config
ln -sf "$PWD" ~/.config/aerospace
chmod +x *.sh

# 4. Add the reload command to your shell
echo "alias boom='~/.config/aerospace/boom.sh'" >> ~/.zshrc
source ~/.zshrc
```

Then follow the [Setup Guide](docs/SETUP.md) to flip three macOS settings.

</details>

## Keybindings

| Key | Action |
|---|---|
| **F1** | Toggle workspace 1 ↔ 2 |
| **F2** | Push window to other workspace |
| **Opt+H/J/K/L** | Focus left/down/up/right |
| **Opt+Shift+H/J/K/L** | Move window left/down/up/right |
| **Opt+Shift+R** | Rescue lost windows |

**Opt is the Option (⌥) key.** That's just day one — there's more in the [full keybindings](docs/KEYBINDINGS.md).

<details>
<summary><strong>Where do my apps go?</strong></summary>

**Workspace 1** — terminals & editors
Ghostty, Terminal, iTerm2, Kitty, Alacritty, WezTerm, VS Code, Cursor

**Workspace 2** — browsers
Chrome, Firefox, Arc, Safari, Brave, Edge

**Auto-float** — apps that don't tile well
Finder, System Settings, Calculator, Preview, Activity Monitor,
1Password, Raycast, CleanShot X, Adobe apps, and more

Everything else tiles by default. Use `/scan-apps` in Claude Code
to add your specific apps, or see [Customization](docs/CUSTOMIZATION.md).

</details>

## Keep Going

- **[Setup Guide](docs/SETUP.md)** — two minutes of macOS settings, then you're done forever
- **[Keybindings](docs/KEYBINDINGS.md)** — day-one keys, power-user keys, and where your apps land
- **[Customization](docs/CUSTOMIZATION.md)** — add your apps, change your keys, make it yours
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** — something broke? it's probably a one-liner

## License

AeroSpace Starter is released under the [MIT License](LICENSE).

---

<p align="center"><sub>built by <a href="https://www.aismokeshow.com/">aismokeshow</a> · where there's boom, there's smoke</sub></p>
