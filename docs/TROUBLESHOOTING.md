# Troubleshooting

Something's weird. Let's fix it fast.

**Windows aren't tiling / AeroSpace seems dead:**
Check that Accessibility permissions are granted ([Setup step 2](SETUP.md#2-grant-accessibility-permissions)). Restart AeroSpace: `aerospace quit` then reopen it, or run `boom`.

**F1 doesn't toggle workspaces:**
You probably didn't enable standard function keys ([Setup step 3](SETUP.md#3-enable-standard-function-keys)). Also check that no other app is capturing F1.

**Windows snap weirdly or fight with AeroSpace:**
Apple's built-in tiling is still on. Go back to [Setup step 1](SETUP.md#1-turn-off-apples-tiling).

**Config change didn't take effect:**
Run `boom` or press **Opt+Shift+;** then **Esc** to reload. AeroSpace doesn't hot-reload on file save.

**AeroSpace is unresponsive:**
```bash
aerospace quit
open -a AeroSpace
```

Or just `boom` — it handles this automatically.

---

**Still stuck?** If it's a config issue, open an issue on this [starter repo](https://github.com/aismokeshow/aerospace-starter/issues). For AeroSpace itself, try the [AeroSpace repo](https://github.com/nikitabobko/AeroSpace/issues) — Nikita is responsive and the community is helpful.
