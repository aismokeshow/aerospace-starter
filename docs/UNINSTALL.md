# Uninstall

Called by `/uninstall`.

Triggered by: "uninstall", "remove", or `/uninstall`

Check the current state before removing anything. Only undo what was actually set up.

1. **Remove config symlink (only if it's a symlink, not a real directory):**
```bash
if [ -L ~/.config/aerospace ]; then
    readlink ~/.config/aerospace
    rm ~/.config/aerospace
fi
```

**Restore any backed-up configs** created during install:
```bash
ls ~/.aerospace.toml.backup 2>/dev/null
ls ~/.config/aerospace.backup 2>/dev/null
```
If either exists, ask the user if they want to restore it:
- `mv ~/.aerospace.toml.backup ~/.aerospace.toml`
- `mv ~/.config/aerospace.backup ~/.config/aerospace`

2. **Remove boom alias from the user's shell config:**

Detect the login shell: `basename "$SHELL"`. Determine which file contains the boom alias — it depends on whether dotfiles-starter was present during install.

**For zsh:** Check if `~/.zshrc` is a symlink managed by dotfiles-starter:
```bash
readlink ~/.zshrc 2>/dev/null
```
If the symlink target contains `dotfiles-starter` or `zsh/.zshrc`, the boom alias was added to `aliases.zsh` in the same directory as the symlink target:
```bash
dirname "$(readlink ~/.zshrc)"
```
Check that file for the alias: `grep -q "alias boom=" "<resolved-dir>/aliases.zsh"`. If found, remove the alias and its comment from `aliases.zsh`.

If `~/.zshrc` is NOT a dotfiles-starter symlink, remove from `~/.zshrc` directly.

**For bash:** Remove from `~/.bashrc`.
**For fish:** Remove from `~/.config/fish/config.fish` (uses `alias boom ` with space, not `=`).

In all cases, remove both the `alias boom=` line (or `alias boom ` for fish) and its `# AeroSpace config reload` comment.

3. **Restore function keys to media mode:**
```bash
defaults write -g com.apple.keyboard.fnState -bool false
```

4. **Re-enable Apple's tiling (macOS 13+ only):**
Check macOS version: `sw_vers -productVersion`. If major version >= 13:
```bash
defaults write com.apple.WindowManager GloballyEnabled -bool true
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true
killall Dock
```
If major version < 13: skip — Apple's tiling wasn't disabled during install.

5. **Disable start-at-login** before quitting (prevents dangling login item errors):
```bash
aerospace reload-config 2>/dev/null
aerospace quit 2>/dev/null
```

6. Tell the user — to fully remove AeroSpace:
```bash
brew uninstall --cask nikitabobko/tap/aerospace
```

7. Tell the user: remove AeroSpace from System Settings → Privacy & Security → Accessibility. Also check System Settings → General → Login Items and remove AeroSpace if it appears there.

8. **Remove install marker** (prevents stale detection on re-clone):
```bash
rm -f .installed
```

9. Tell the user: The `~/.aismokeshow/aerospace-starter` folder (or wherever you cloned it) is still on disk. It's just a config directory now — safe to delete if you no longer want AeroSpace. If no other aismokeshow projects remain, you can also remove `~/.aismokeshow/`.
