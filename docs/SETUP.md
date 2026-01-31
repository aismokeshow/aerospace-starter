# Setup Guide

You need AeroSpace installed and the repo cloned first — if you haven't done that, start with the [Quick Start](../README.md#quick-start).

Now make macOS cooperate.

## 1. Turn off Apple's tiling

It conflicts. Go to **System Settings → Desktop & Dock → Windows** and turn off all four toggles.

## 2. Grant Accessibility permissions

**System Settings → Privacy & Security → Accessibility** → add AeroSpace.

## 3. Enable standard function keys

We use F1 as the toggle key because it's the easiest key to hit without looking and nothing important uses it. By default macOS maps it to brightness, so flip one setting:

**System Settings → Keyboard → Keyboard Shortcuts → Function Keys** → toggle on **Use F1, F2, etc. keys as standard function keys**

Your media keys still work — just hold **Fn** first. If you'd rather not change this, swap `f1` for something like `alt-grave` in `aerospace.toml` and skip this step.

## 4. Set up the reload command

This repo includes `boom.sh` — a script that safely restarts and reloads AeroSpace. Add this to your `~/.zshrc`:

```bash
alias boom='~/.config/aerospace/boom.sh'
```

Then `source ~/.zshrc`. Now you can type `boom` from any terminal to reload your config. You'll use this a lot.

## 5. Launch

Open AeroSpace from Applications or Spotlight. Your windows will immediately rearrange — that's the point. Terminals go to workspace 1, browsers go to workspace 2.

It starts automatically on login from now on.

**You're tiling.** Go hit F1 a few times, then check out the [full keybindings](KEYBINDINGS.md).

---

## Uninstall

```bash
rm ~/.config/aerospace                  # remove symlink
brew uninstall --cask aerospace         # remove app
```

Re-enable Apple's tiling in **System Settings → Desktop & Dock → Windows** if you want it back.
