# Dotfiles

Personal development environment configuration for macOS.

## Prerequisites

- macOS
- [Homebrew](https://brew.sh) installed
- This repo cloned to `~/.dotfiles`

## Installation

Run the bootstrap script:

```bash
~/.dotfiles/bootstrap.py
```

This installs Brewfile packages, stows configurations, sets up Node via
fnm, installs VSCode extensions, and applies macOS defaults. It is
idempotent — safe to re-run.

A few one-time manual steps (iTerm color preset, `.gitconfig.local`,
`.zshrc.local`) are listed at the end of bootstrap output.

### Manual alternative

```bash
brew bundle                                 # required packages
brew bundle --file=Brewfile.extras          # optional extras
python3 stow.py                             # symlink configs
```

## Repository structure

| Path              | Purpose                                              |
|-------------------|------------------------------------------------------|
| `bootstrap.py`    | One-shot machine setup                               |
| `stow.py`         | Symlink manager (Python wrapper around GNU Stow)     |
| `Brewfile`        | Required Homebrew packages                           |
| `Brewfile.extras` | Optional packages (personal machines)                |
| `aerospace/`      | AeroSpace tiling window manager config               |
| `claude/`         | Claude Code (CLAUDE.md, settings, commands)          |
| `git/`            | Git config + global ignore                           |
| `jetbrains/`      | JetBrains IDE settings                               |
| `nvim/`           | Neovim configuration                                 |
| `macos/`          | `defaults.sh` system preferences + iTerm color preset |
| `tmux/`           | Tmux config + helper functions                       |
| `vscode/`         | VS Code settings, keybindings, extension list        |
| `zsh/`            | Zsh config (aliases, prompt, plugins)                |

## Configuration patterns

### Stow symlink model

`stow.py` uses GNU Stow to mirror each package's contents into `$HOME`.
Files in `~/.dotfiles/<package>/` become symlinks at the corresponding
location under `~/`. **Edit the files in this repo, never at the symlink
target** — the target is the link, the source is here.

Editing an existing symlinked file works immediately. Adding new files
requires restow:

```bash
python3 stow.py -r <package>
```

Restow unstows then re-stows. It's safe as long as you only edit files
in this repo: the symlinks point back here, so removing and recreating
them doesn't touch the source. If you've modified a file via its symlink
target, the modification is already in this repo (the target *is* the
link), so restow won't lose data.

### Mixed config + runtime state

Some applications (Claude Code, VSCode) write runtime state — caches,
sessions, cookies, indexes — into the same directory tree as their
curated config. Stow's default tree-folding optimization would land all
that runtime junk inside the dotfiles repo.

Such packages are listed in `stow.py`'s `NO_FOLD_PACKAGES`. Stow uses
`--no-folding` for them, creating real intermediate directories with
per-file symlinks — runtime writes land in the real directory, outside
the repo.

### Machine-specific overrides

Anything secret or per-machine (signing keys, identity, credentials)
lives in `*.local` files, gitignored via `**/*.local*`:

| Dotfile        | Override file        | Use                                      |
|----------------|----------------------|------------------------------------------|
| `~/.gitconfig` | `~/.gitconfig.local` | `[user]` block (name, email, signing)    |
| `~/.zshrc`     | `~/.zshrc.local`     | Per-machine shell config                 |

These are sourced/included automatically when present.

## Operations

### Add a new package

1. Create `~/.dotfiles/<pkg>/` mirroring the target structure (e.g.
   `<pkg>/.config/foo/foo.toml` → `~/.config/foo/foo.toml`).
2. Add the name to `PACKAGES` in `stow.py` if it should install by default.
3. If the target app writes runtime state into its config dir, also add
   the name to `NO_FOLD_PACKAGES` in `stow.py`.
4. Run `python3 stow.py <pkg>`.

### Update on an existing machine

```bash
cd ~/.dotfiles
git pull
~/.dotfiles/bootstrap.py    # idempotent
```

### Unstow a package

```bash
python3 stow.py -u <pkg>
```

### List package status

```bash
python3 stow.py -l
```

The output tags each package:

- `[stowed]` — at least one file from the package is symlinked into `~/`
- `[recommended]` — included in the default install (`PACKAGES` in `stow.py`)

A package may be available but neither stowed nor recommended; those are
optional and can be stowed individually with `python3 stow.py <pkg>`.

## Cheatsheet

### Zsh

| Command       | Action                                |
|---------------|---------------------------------------|
| `v`           | Open Neovim                           |
| `py`/`python` | Python 3                              |
| `pva`         | Activate `.venv`                      |
| `..`          | `cd ..`                               |
| `ws`          | `cd ~/workspace`                      |
| `dot`         | `cd ~/.dotfiles`                      |
| `l`           | List all (eza, dirs first)            |
| `ld`          | List directories only                 |
| `lf`          | List files only                       |
| `cheat`       | Open this README in Neovim            |
| `mkcd <dir>`  | `mkdir -p` + `cd`                     |
| `dstart`      | Start Colima (Docker runtime)         |
| `dstop`       | Stop Colima                           |
| `dev [name]`  | Attach or create tmux dev session     |
| `devkill`     | Kill a tmux session via fzf           |
| `jj`          | Insert → vi normal mode               |

### Tmux

Prefix: `Ctrl+Space`.

| Key                  | Action                                      |
|----------------------|---------------------------------------------|
| `prefix \`           | Vertical split (current path)               |
| `prefix -`           | Horizontal split (current path)             |
| `Ctrl+h/j/k/l`       | Navigate panes (Vim-aware)                  |
| `prefix h/j/k/l`     | Resize pane (5 cells)                       |
| `prefix S`           | Create new named session                    |
| `prefix r`           | Reload config                               |
| `prefix b` / `B`     | Mark pane / swap with marked                |
| `prefix v` / `V`     | Mark pane / join to current window          |
| `prefix o`           | Break pane to new window                    |
| `prefix H` / `L`     | Move window left / right                    |
| `Shift+Left/Right`   | Swap window with neighbor                   |
| `prefix Ctrl+s`      | Save session (resurrect)                    |
| `prefix Ctrl+r`      | Restore session                             |
| `prefix I`           | Install plugins (TPM)                       |
| `prefix [`           | Enter copy mode                             |

Copy mode uses Vim keys: `v` start selection, `y` yank, `/` search, `q` exit.

### Neovim

Leader: `Space`. LocalLeader: `\`.

#### General

| Key      | Action                  |
|----------|-------------------------|
| `jj`     | Insert → Normal         |
| `<Esc>`  | Clear search highlight  |

#### File and project navigation

| Key                  | Action                              |
|----------------------|-------------------------------------|
| `<leader>sf`         | Find files                          |
| `<leader>sg`         | Live grep (project)                 |
| `<leader>s/`         | Live grep (open buffers)            |
| `<leader>sw`         | Grep word under cursor              |
| `<leader>s.`         | Recent files                        |
| `<leader>sr`         | Resume last search                  |
| `<leader>sh`         | Help tags                           |
| `<leader>sk`         | Keymaps                             |
| `<leader>sn`         | Search Neovim config                |
| `<leader>/`          | Fuzzy-find in current buffer        |
| `<leader><leader>`   | Buffer picker                       |
| `<C-n>`              | Toggle file explorer (left)         |
| `<leader>e`          | Floating file explorer              |
| `<leader>b`          | Toggle buffer list (left)           |
| `s` / `S`            | Flash jump / treesitter jump        |
| `<C-s>` (cmdline)    | Toggle Flash search                 |

#### LSP

| Key            | Action                              |
|----------------|-------------------------------------|
| `gd`           | Go to definition                    |
| `gD`           | Go to declaration                   |
| `gI`           | Go to implementation                |
| `gr`           | Go to references                    |
| `K`            | Hover documentation                 |
| `<C-k>`        | Signature help                      |
| `<leader>rn`   | Rename                              |
| `<leader>ca`   | Code action                         |
| `<leader>lr`   | References (Telescope)              |
| `<leader>ls`   | Document symbols                    |
| `<leader>lS`   | Workspace symbols                   |
| `<leader>th`   | Toggle inlay hints                  |

#### Diagnostics

| Key                | Action                           |
|--------------------|----------------------------------|
| `]d` / `[d`        | Next / previous diagnostic       |
| `<leader>cd`       | Diagnostic float at cursor       |
| `<leader>sd`       | Diagnostics (Telescope)          |
| `<leader>q`        | Diagnostics (Trouble)            |
| `<leader>xx`       | Diagnostics — project (Trouble)  |
| `<leader>xX`       | Diagnostics — buffer (Trouble)   |
| `<leader>xs`       | Document symbols (Trouble)       |
| `<leader>xl`       | LSP defs/refs/impls (Trouble)    |
| `<leader>xL`       | Location list (Trouble)          |
| `<leader>xQ`       | Quickfix list (Trouble)          |

#### Code

| Key                  | Action                              |
|----------------------|-------------------------------------|
| `<leader>cf`         | Format buffer / selection           |
| `gcc` / `gc{motion}` | Toggle line / motion comment        |
| `gbc`                | Toggle block comment                |
| `cs"'`               | Change surround `"` → `'`           |
| `ds"`                | Delete surrounding `"`              |
| `ysiw"`              | Surround word with `"`              |

#### Git

| Key                  | Action                              |
|----------------------|-------------------------------------|
| `<leader>gs`         | Git status (Telescope)              |
| `<leader>gc`         | Git commits                         |
| `<leader>gb`         | Git branches                        |
| `<leader>gd`         | Diffview (vs HEAD)                  |
| `<leader>gD`         | Diffview close                      |
| `<leader>gh`         | File history (current file)         |
| `<leader>gH`         | File history (project)              |
| `]c` / `[c`          | Next / previous hunk                |
| `<leader>hs` / `hr`  | Stage / reset hunk                  |
| `<leader>hS` / `hR`  | Stage / reset buffer                |
| `<leader>hu`         | Undo stage hunk                     |
| `<leader>hp`         | Preview hunk                        |
| `<leader>hb`         | Blame line (full)                   |
| `<leader>hd` / `hD`  | Diff this / vs `~`                  |
| `<leader>tb`         | Toggle inline blame                 |
| `<leader>td`         | Toggle deleted                      |
| `ih` (text-object)   | Select hunk                         |

### AeroSpace

| Key                   | Action                                     |
|-----------------------|--------------------------------------------|
| `Alt+h/j/k/l`         | Focus left/down/up/right                   |
| `Alt+Shift+h/j/k/l`   | Move window left/down/up/right             |
| `Alt+Shift+v`         | Join with up                               |
| `Alt+Shift+s`         | Join with left                             |
| `Alt+Ctrl+h` / `l`    | Resize width −/+ 50                        |
| `Alt+Ctrl+j` / `k`    | Resize height +/− 50                       |
| `Alt+r`               | Resize mode (`h/j/k/l`; `Shift` = ×4)      |
| `Alt+0-9`             | Switch to workspace                        |
| `Alt+Shift+0-9`       | Move window to workspace                   |
| `Alt+f`               | Toggle floating/tiling                     |
| `Alt+Shift+f`         | Fullscreen                                 |
| `Alt+t`               | Force tiling layout                        |
| `Alt+/`               | Tiles layout (auto-orient)                 |
| `Alt+,`               | Accordion layout (auto-orient)             |
| `Alt+e`               | Balance window sizes                       |
| `Alt+Shift+q`         | Close window                               |
| `Alt+Shift+r`         | Reload config                              |

#### Workspace assignments

| Workspace | App            |
|-----------|----------------|
| 0         | iTerm2         |
| 1         | Chrome         |
| 2         | Claude Desktop |
| 3         | Obsidian       |
| 5         | Discord        |
| 9         | VSCode         |

Floating: Finder, Preview, System Settings, Steam.

### VS Code

Vim mode is active in editor. Vim leader: `Space`.

#### Terminal

| Key               | Action                              |
|-------------------|-------------------------------------|
| ``Ctrl+` ``       | Toggle maximized terminal           |
| ``Cmd+` ``        | Toggle terminal panel               |
| `Ctrl+Space \`    | Split terminal vertically           |
| `Ctrl+Space -`    | Split terminal horizontally         |
| `Ctrl+h/l`        | Focus prev/next terminal pane       |
| `Ctrl+j/k`        | Focus next/prev terminal            |
| `Ctrl+Space x`    | Kill terminal                       |
| `Ctrl+Space c`    | New terminal                        |
| `Ctrl+Space m`    | Toggle panel maximize               |
| `Ctrl+Space z`    | Toggle editor group maximize        |

#### Editor groups

| Key                    | Action                                       |
|------------------------|----------------------------------------------|
| `Ctrl+Space \`         | Split editor right                           |
| `Ctrl+Space -`         | Split editor down                            |
| `Ctrl+h/l`             | Focus left/right group (Vim normal mode)     |
| `Ctrl+j/k`             | Focus below/above group                      |
| `Ctrl+Space o`         | Move editor to next group                    |
| `Ctrl+Space Shift+O`   | Move editor to previous group                |
| `Ctrl+Space x`         | Close editor                                 |

#### Sidebar / panels

| Key          | Action                              |
|--------------|-------------------------------------|
| `Cmd+b`      | Toggle sidebar                      |
| `Cmd+1`      | Explorer                            |
| `Cmd+2`      | Search                              |
| `Cmd+3`      | Debug                               |
| `Cmd+4`      | Testing                             |
| `Cmd+5`      | Containers                          |
| `Cmd+6`      | AWS                                 |
| `Cmd+7`      | Postgres                            |
| `Cmd+8`      | GitHub Pull Requests                |
| `Cmd+9`      | GitHub Actions                      |
| `Cmd+0`      | Claude Code panel                   |
| `Cmd+r`      | Recent workspaces                   |
| `Ctrl+Tab`   | Quick-switch recent file            |

#### Vim-mode LSP & git

| Key                    | Action                  |
|------------------------|-------------------------|
| `gd`                   | Go to definition        |
| `gr`                   | Go to references        |
| `gi`                   | Go to implementation    |
| `K` (Shift+K)          | Hover                   |
| `Cmd+d`                | Open file diff          |
| `Ctrl+Space Shift+G`   | Git commit              |
