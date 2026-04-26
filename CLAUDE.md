# Dotfiles Repository

GNU Stow-managed dotfiles. Each top-level directory is a stow package whose contents mirror `$HOME`.

## Critical: Stow Symlink Model

- Files in `~/.dotfiles/<package>/` are symlinked into `~/` — always edit files here, never at the symlink target
- Editing an existing symlinked file works immediately; adding new files requires restowing: `python3 stow.py -r <package>`
- New packages must be registered in `StowManager.PACKAGES` in `stow.py`

## Stow Tree-Folding

By default, stow symlinks whole directories when a target dir contains only files from one package — so the *directory* is the symlink, and the files inside it aren't. Two consequences:

- **Inspecting symlinks:** Use `Path.resolve()` to follow the chain to the source. `is_symlink()` on an individual file returns `False` if only an ancestor directory is the link.
- **Opting out:** Apps that write runtime state (caches, sessions, cookies) into their config directory need per-file symlinks so writes don't land inside this repo. Opt those packages out via `NO_FOLD_PACKAGES` in `stow.py`; stow will use `--no-folding` for them.

## Critical: Sensitive Data

- Machine-specific or sensitive config (credentials, signing keys, user identity) goes in `*.local` files, which are gitignored via `**/*.local*`
- Example: `~/.gitconfig` includes `~/.gitconfig.local` for `[user]` — never put identity or secrets in tracked files

## The `claude/` Package is Self-Referential

The `claude/` package stows into `~/.claude/`. It contains Claude Code's own user-level CLAUDE.md and settings.json. Edits to `claude/.claude/CLAUDE.md` change Claude's global instructions across all projects.

## Stow Ignore

Packages with `.stow-local-ignore` exclude files from symlink creation. Check this file before adding new files to a package — they may be silently excluded.

## Keep README in Sync

`README.md` documents specific user-visible details: zsh aliases, tmux/nvim/aerospace keybindings, workspace assignments, the repository structure table, and the cheatsheet. After any change that touches these, review and update the affected sections — the cheatsheet drifts fast otherwise and stale bindings are worse than missing ones.
