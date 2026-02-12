# Troubleshooting

> **Using Claude Code?** Type `/troubleshoot` — it runs a full diagnostic checklist automatically and fixes what it finds.

Common fixes. Most issues are one setting away.

**Windows aren't tiling / AeroSpace seems dead:**
Check that Accessibility permissions are granted ([Setup step 2](SETUP.md#2-grant-accessibility-permissions)). Restart AeroSpace: `aerospace quit` then reopen it, or run `boom`.

**F1 doesn't toggle workspaces:**
You probably didn't enable standard function keys ([Setup step 3](SETUP.md#3-enable-standard-function-keys)). Also check that no other app is capturing F1.

**Windows snap weirdly or fight with AeroSpace:**
Apple's built-in tiling is still on. Go back to [Setup step 1](SETUP.md#1-turn-off-apples-tiling).

**Config change didn't take effect:**
Run `boom` or press **Opt+Shift+;** then **Esc** to reload. AeroSpace doesn't hot-reload on file save.

**Config reload fails with a parse error:**
You have a TOML syntax issue in `aerospace.toml` — missing quotes, unclosed brackets, or duplicate keys. Run `aerospace reload-config` to see the exact error and line number. Fix the offending line and reload again.

**AeroSpace is unresponsive:**
```bash
aerospace quit
open -a AeroSpace
```

Or just `boom` — it handles this automatically.

---

**Windows disappeared / blank space in layout:**
AeroSpace can lose track of windows in two ways: ghost windows (minimized windows that still hold a tile slot) and lost windows (floating windows dumped off-screen to the bottom-right corner). Both are known upstream issues ([#570](https://github.com/nikitabobko/AeroSpace/issues/570), [#1615](https://github.com/nikitabobko/AeroSpace/issues/1615)).

Hit **Opt+Shift+R** to rescue — it re-tiles every window on the current workspace and rebalances the layout. If that doesn't work, try service mode: **Opt+Shift+;** then **R** to flatten the workspace tree.

To prevent ghost windows, avoid using macOS native minimize (Cmd+M). AeroSpace doesn't reliably detect minimize state changes, so the tile slot stays occupied with nothing visible in it.

---

**Still stuck?** Type `/troubleshoot` in Claude Code for a full automated diagnostic. If that doesn't solve it — config issues go to the [starter repo](https://github.com/aismokeshow/aerospace-starter/issues), AeroSpace issues go to the [AeroSpace repo](https://github.com/nikitabobko/AeroSpace/issues) — Nikita is responsive and the community is helpful.
