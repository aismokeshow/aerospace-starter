Follow the "First-Time Setup" procedure in the project's CLAUDE.md file.
If CLAUDE.md doesn't have a "First-Time Setup" section (it may have been
swapped to the operational version), read `.claude/CLAUDE.hub.md` instead
and follow the "First-Time Setup" section there.

Work through each step in order. For each step, explain what you're about
to do and why before doing it. Assume the user has never used a terminal
or a tiling window manager before.

Pause and ask for confirmation before any step that modifies system
settings (Homebrew install, defaults write commands, symlink creation).
If the user is running with --dangerously-skip-permissions, proceed
automatically but still explain each step as you go.

If everything is already set up (AeroSpace installed, symlink exists,
config linked), tell the user and offer to run /scan-apps instead.
