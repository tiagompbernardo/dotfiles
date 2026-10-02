# dotfiles

Personal dotfiles. One Git repository, synced into `$HOME` with
[GNU Stow](https://www.gnu.org/software/stow/).

## How it works

The repository mirrors the home directory. Each top-level directory is a
Stow package.

| Package | Target |
|---|---|
| `foot/` | `~/.config/foot/` |
| `nvim/` | `~/.config/nvim/` |
| `opencode/` | `~/.config/opencode/skills/` |
| `tmux/` | `~/.config/tmux/` |
| `zsh/` | `~/.zshrc` |

The `extras/` directory holds files that are not synced. Copy them by hand.

## Install

1. Install GNU Stow with your system package manager. The package is named
   `stow`. See <https://www.gnu.org/software/stow/>.

2. Clone the repository anywhere under your home directory.

   ```bash
   git clone git@github.com:tiagompbernardo/dotfiles.git ~/Projects/dotfiles
   ```

3. Link the files. On a machine that already has configs, use `--adopt`. Stow
   moves each existing file into the repository and then creates the link.

   ```bash
   ~/Projects/dotfiles/install.sh --adopt
   ```

   On a fresh machine, or to update an existing install, run the script
   without arguments.

   ```bash
   ~/Projects/dotfiles/install.sh
   ```

`--adopt` overwrites the repository file with the live file. Run `git diff`
after the first install and check the result.

## Per-tool notes

Most tools need only the symlink. Some need more.

### foot

- Symlink only.
- The config is self-contained. It has no theme include.
- Foot reads the config in new windows. Open a new window to apply a change.

### nvim

- Symlink only.
- On the first start, `lazy.nvim` installs the plugins. This needs network
  access. The file `lazy-lock.json` pins the plugin versions.

### opencode

- Symlink only. This package tracks the skills under
  `~/.config/opencode/skills/`.
- Restart opencode to load a new skill.

### tmux

- Symlink only.
- The plugins are not part of the repository. After the first install, install
  the plugin manager.

  ```bash
  mkdir -p ~/.config/tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
  ```

  Then start tmux and press `C-a I` to install the plugins.
- The server config is at `extras/tmux-server.conf`. Copy it to `~/.tmux.conf`
  on a server. It uses the `C-b` prefix, so it does not clash with the local
  `C-a` prefix when one tmux runs inside the other.

### zsh

- Symlink to `~/.zshrc`.
- Open a new shell to apply a change.

## Change the configuration

The installed files are symlinks into the repository. Edit the file in the
repository. The change reaches the home directory at once. Some tools need a
reload.

| Tool | Reload |
|---|---|
| foot | Open a new window |
| tmux | `C-a q` |
| nvim | Restart nvim |
| zsh | Open a new shell |

## Add a new tool

1. Create the package directory, for example `bat/.config/bat/config`.
2. Add the name to the `packages` list in `install.sh`.
3. Run `./install.sh --adopt`.
