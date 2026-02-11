# Customization

You've been using the defaults. Now make it yours.

The fastest way to change anything is through Claude Code — type a slash command and describe what you want. If you're not using Claude Code, expand the manual sections below each heading.

## Add an app to a workspace

Type `/scan-apps` to auto-detect all your installed apps and configure them in bulk, or `/customize` to route a specific app (e.g., "put Slack on workspace 1").

<details>
<summary><strong>Manual</strong></summary>

Find the app's bundle ID:

```bash
mdls -name kMDItemCFBundleIdentifier /Applications/YourApp.app
```

If the app isn't in `/Applications` or `mdls` returns nothing:

```bash
osascript -e 'id of app "YourApp"'
```

**Without the terminal:** Right-click the app in Finder → **Show Package Contents** → open `Contents/Info.plist` → search for `CFBundleIdentifier`.

Add a rule to `aerospace.toml`:

```toml
[[on-window-detected]]
if.app-id = 'com.example.yourapp'
run = 'move-node-to-workspace 1'
```

Reload: `boom` or **Opt+Shift+;** then **Esc**.

</details>

## Make an app float

Type `/customize` and tell it which app to float (e.g., "make Spotify float").

<details>
<summary><strong>Manual</strong></summary>

Same bundle ID lookup as above, different command:

```toml
[[on-window-detected]]
if.app-id = 'com.example.yourapp'
run = 'layout floating'
```

Some apps just don't tile well — preferences windows, media players, anything with a fixed size. Float them and move on.

</details>

## Change a keybinding

Type `/customize` and describe the keybinding you want (e.g., "change workspace toggle to alt-backtick"). It fetches the latest AeroSpace docs to get the syntax right.

<details>
<summary><strong>Manual</strong></summary>

Edit the `[mode.main.binding]` section in `aerospace.toml`. See the [AeroSpace keybinding docs](https://nikitabobko.github.io/AeroSpace/guide#binding) for syntax.

</details>

## Add a third workspace

Type `/customize` — describe the workspace and which apps go there (e.g., "add workspace 3 for chat apps like Slack and Discord").

<details>
<summary><strong>Manual</strong></summary>

AeroSpace supports as many workspaces as you want. Add bindings in `[mode.main.binding]` and route apps with `move-node-to-workspace 3`. The [AeroSpace workspace docs](https://nikitabobko.github.io/AeroSpace/guide#tree) cover the details.

</details>

---

**Something not working after a change?** Type `/troubleshoot` in Claude Code — or check [Troubleshooting](TROUBLESHOOTING.md).
