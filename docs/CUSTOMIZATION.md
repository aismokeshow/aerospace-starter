# Customization

You've been using the defaults. Now make it yours.

## Add an app to a workspace (by default)

Find its bundle ID:

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

## Make an app float (by default)

Same pattern, different command:

```toml
[[on-window-detected]]
if.app-id = 'com.example.yourapp'
run = 'layout floating'
```

Some apps just don't tile well — preferences windows, media players, anything with a fixed size. Float them and move on.

## Change a keybinding

Edit the `[mode.main.binding]` section in `aerospace.toml`. See the [AeroSpace keybinding docs](https://nikitabobko.github.io/AeroSpace/guide#binding) for syntax.

## Add a third workspace

AeroSpace supports as many workspaces as you want. Add bindings in `[mode.main.binding]` and route apps with `move-node-to-workspace 3`. The [AeroSpace workspace docs](https://nikitabobko.github.io/AeroSpace/guide#tree) cover the details.

## Using Claude Code

If you use [Claude Code](https://docs.anthropic.com/en/docs/claude-code), it's a great way to customize this config without learning TOML syntax. Point it at this repo and ask it to add apps, change keybindings, or adjust layouts. The config is also straightforward to edit by hand.

---

**Something not working after a change?** Check [Troubleshooting](TROUBLESHOOTING.md).
