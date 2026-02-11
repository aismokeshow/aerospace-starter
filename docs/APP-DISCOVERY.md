# App Discovery

Called by `/scan-apps` or install Step 9.

Triggered by: First-Time Setup Step 9, or `/scan-apps` anytime.

### How to scan

1. List all .app bundles in both app directories:
```bash
ls /Applications/
ls ~/Applications/ 2>/dev/null
ls /System/Applications/ 2>/dev/null
```

2. For each .app, get its bundle ID. Try these in order until one works:
```bash
mdls -name kMDItemCFBundleIdentifier "/Applications/AppName.app"
```
If mdls returns `(null)` or nothing:
```bash
osascript -e 'id of app "AppName"'
```
If osascript also fails (some apps don't register properly), read the Info.plist directly:
```bash
defaults read "/Applications/AppName.app/Contents/Info.plist" CFBundleIdentifier 2>/dev/null
```
If all three methods fail for an app, skip it and tell the user: "Couldn't determine the bundle ID for [AppName]. You can add it manually later with `/customize`."

3. Read `aerospace.toml` and collect all existing `if.app-id` values to know what's already configured.

4. Identify apps that are installed but not in any rule.

### How to categorize

Use these heuristics for unconfigured apps:

**Workspace 1** (terminals & editors):
Terminal emulators, code editors, IDEs.
Examples: Xcode, Zed, Sublime Text, Nova, Warp, Rio, JetBrains apps (IntelliJ, PyCharm, WebStorm, etc.)

**Workspace 2** (browsers):
Web browsers.
Examples: Opera, Vivaldi, Orion, Zen Browser, Wavebox, SigmaOS, Sidekick

**Auto-float** (don't tile well):
System utilities, password managers, creative tools, VPN clients, screen recorders, menubar-only apps, settings/preferences apps, hardware config apps, small single-purpose windows, AI assistants.
Examples: Raycast, Alfred, 1Password, Bartender, iStat Menus, Adobe apps, Figma, Sketch, OBS

**Apple system apps guidance** — most `/System/Applications/` apps should auto-float. The config already includes the most common ones (Finder, System Settings, Calculator, Activity Monitor, Preview, FaceTime, Photos, Maps, App Store, Calendar, Contacts, Reminders, Home, Passwords, and several utilities). For any remaining Apple system apps found during scan: apps with custom/non-standard window chrome (e.g., Weather, Stocks, News, TV, Podcasts, Books, Freeform) generally tile acceptably but may look odd — categorize them as "No rule needed" unless the user reports problems. The Clock, Shortcuts, Font Book, and Migration Assistant apps should auto-float.

**No rule needed** (default tiling works fine):
Standard windowed apps — chat, notes, email, music, document editors, project management.
Examples: Slack, Discord, Messages, Notes, Notion, Obsidian, Spotify, Mail

### How to present

Show the user a clear summary grouped by category:
- **Already configured:** [list]
- **Recommended for Workspace 1:** [list with bundle IDs and one-line reasoning]
- **Recommended for Workspace 2:** [list with bundle IDs and one-line reasoning]
- **Recommended to auto-float:** [list with bundle IDs and one-line reasoning]
- **No change needed:** [list]

Present the summary, then apply the recommendations.

### How to apply

For each approved app, add a `[[on-window-detected]]` block to `aerospace.toml`.

Insert workspace 1 apps after the last existing workspace 1 rule (before the `# Browsers → workspace 2` comment).
Insert workspace 2 apps after the last existing workspace 2 rule (before the `# Auto-float — apps that don't tile well` comment).
Insert auto-float apps at the end of the file.

Each rule is a TOML block (similar to an INI file):
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'move-node-to-workspace 1'
```

For auto-float:
```toml
[[on-window-detected]]
if.app-id = 'com.example.bundleid'
run = 'layout floating'
```

After editing, reload and **validate** the config:
```bash
aerospace reload-config 2>&1
```
Or run `boom` if the alias is set up. **Check the output for TOML parse errors.** If `aerospace reload-config` reports a syntax error (e.g., "expected value, found newline" or "invalid TOML"), read the error message to identify the line number, fix the malformed TOML in `aerospace.toml`, and reload again. Do not proceed until the reload succeeds cleanly.
