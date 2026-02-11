# Cross-Project Awareness

Read this before modifying shell configuration files during install.

Other aismokeshow starter packs may already be installed. Before appending to rc files or modifying Claude Code settings, check for these artifacts and handle them correctly.

Only act on projects that are detected as installed. If a project is not detected, skip it entirely.

---

## 1. dotfiles-starter

Modern modular zsh configuration that replaces `~/.zshrc` with a symlink.

**Detection:**
- `~/.zshrc` is a symlink (check with `[ -L ~/.zshrc ]`)
- The symlink target path contains `dotfiles-starter` (check with `readlink ~/.zshrc`)

**Impact:**
- Appending to `~/.zshrc` writes through the symlink and dirties a tracked git file in the dotfiles-starter repo.

**Action if detected:**
- Resolve the symlink target: `readlink ~/.zshrc`
- Find `aliases.zsh` in the same directory as the symlink target (e.g., if target is `~/.aismokeshow/dotfiles-starter/zsh/.zshrc`, look for `~/.aismokeshow/dotfiles-starter/zsh/aliases.zsh`)
- Append the boom alias to `aliases.zsh` instead of `~/.zshrc`
- Inform the user: "Your `~/.zshrc` is managed by dotfiles-starter, so the boom alias was added to `aliases.zsh` instead."

**Action if NOT detected:**
- Append to `~/.zshrc` normally (existing Step 7 behavior).

---

## 2. statusline-starter

SMOKE two-line statusline for Claude Code.

**Detection:**
- `~/.claude/statusline-smoke.py` exists

**Action:**
- Informational only. No interaction with aerospace config or shell files.
- No action required during install.

---

## 3. curator-starter

Project curator agent for sourcing Claude Code tips and content.

**Detection:**
- `~/.claude/agents/project-curator.md` exists

**Action:**
- No interaction with aerospace config or shell files. Informational only.

---

## 4. extreme-ownership

Extreme Ownership skill for Claude Code.

**Detection:**
- `~/.claude/skills/extreme-ownership/SKILL.md` exists

**Action:**
- No interaction with aerospace config or shell files. Informational only.
