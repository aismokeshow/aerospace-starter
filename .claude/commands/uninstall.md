---
description: Clean removal — reverses all install changes
---

Follow docs/UNINSTALL.md.

Before removing anything, check the current system state:
- Verify ~/.config/aerospace is a symlink pointing to this repo
- Detect the user's shell (`basename "$SHELL"`) and check for the boom alias in the corresponding rc file (`~/.zshrc` for zsh, `~/.bashrc` for bash, `~/.config/fish/config.fish` for fish)
- Check macOS version (`sw_vers -productVersion`) — only read WindowManager defaults if major version >= 13
- Check current defaults values for fnState

Only remove what was actually set up. Explain each change before making it.
