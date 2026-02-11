---
description: Diagnose and fix AeroSpace problems — runs a full checklist automatically
---

Use the troubleshoot-aerospace agent to diagnose and fix this issue.

Pass along the user's problem description. If they didn't describe a
specific problem, the agent will run a full diagnostic checklist.

If the troubleshoot-aerospace agent is not available, run these checks directly:

1. Is AeroSpace running? `pgrep -x AeroSpace`
2. Is the config symlink intact? `readlink ~/.config/aerospace`
3. Does it point to a directory with aerospace.toml?
   `ls ~/.config/aerospace/aerospace.toml`
4. Are Accessibility permissions granted?
   `aerospace list-workspaces --all` (hangs or errors = missing)
5. Are standard function keys enabled?
   `defaults read -g com.apple.keyboard.fnState` (should be 1)
6. Is Apple tiling disabled? (macOS 13+ only — check `sw_vers -productVersion` first)
   `defaults read com.apple.WindowManager GloballyEnabled` (should be 0)
7. Is the config valid? `aerospace reload-config` (check for errors)
8. Is the boom alias set up? Detect shell with `basename "$SHELL"`, then check the corresponding rc file (`~/.zshrc` for zsh, `~/.bashrc` for bash, `~/.config/fish/config.fish` for fish) for `alias boom`

Read `aerospace.toml` for config errors. Read `.claude/CLAUDE.hub.md`
for the troubleshooting quick reference section.

Match diagnostic results to the user's symptoms. Apply the fix,
then re-run the relevant diagnostic check to verify it worked.

If the problem can't be diagnosed, link to:
- Starter config issues: https://github.com/aismokeshow/aerospace-starter/issues
- AeroSpace upstream: https://github.com/nikitabobko/AeroSpace/issues
