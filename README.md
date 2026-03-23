#### KALI-LIKE Theme for Oh-My-Zsh

![Preview](screenshots/kali-like-zsh.png)

Kali-Like is a [oh-my-zsh](https://ohmyz.sh/) theme that looks like Kali Linux default zsh theme.
Kali-Like can be installed on any linux distribution and isn't Kali Linux dependent.

## Features

- Two-line or one-line prompt (toggle with `Ctrl+P`)
- VCS support (git, svn, hg, bzr) via `vcs_info` with staged/unstaged indicators
- Async VCS info to avoid prompt lag in large repositories
- SSH and tmux session indicators
- Docker/container detection
- Nix shell indicator
- Kubernetes context display
- Python virtual environment display (venv, virtualenv, conda)
- Command execution duration (shown when exceeding a configurable threshold)
- Return code indicator (red cross on failure)
- Dark/light theme with auto-detection
- Syntax highlighting with theme-aware colors
- Auto-download of `zsh-syntax-highlighting` and `zsh-autosuggestions` plugins
- Fully configurable colors (256-color palette)

## Installation

1. `wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme`
2. `vim ~/.zshrc`
3. Set `ZSH_THEME="current_theme"` to `ZSH_THEME="kali-like"`


## Options

All options are defined at the top of the theme file.

### Plugins

Kali-Like uses `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins.
If they are not found, they are downloaded automatically into `~/.zsh/`.

| Variable | Default | Description |
|---|---|---|
| `USE_SYNTAX_HIGHLIGHTING` | `yes` | Enable zsh-syntax-highlighting |
| `AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN` | `yes` | Auto-download if not found |
| `USE_ZSH_AUTOSUGGESTIONS` | `yes` | Enable zsh-autosuggestions |
| `AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN` | `yes` | Auto-download if not found |

### Prompt layout

| Variable | Default | Description |
|---|---|---|
| `PROMPT_ALTERNATIVE` | `twoline` | `twoline` or `oneline`. Toggle at runtime with `Ctrl+P` |
| `NEWLINE_BEFORE_PROMPT` | `yes` | Print a blank line before each prompt |
| `PROMPT_DASH_COUNT` | `3` | Number of `─` characters after the initial `┌─` |

### Theme mode

| Variable | Default | Description |
|---|---|---|
| `THEME_MODE` | `auto` | `auto` (detect terminal background), `dark`, or `light` |

Auto-detection uses the `$COLORFGBG` environment variable (supported by most terminals). If detection fails, defaults to `dark`.

### Colors

Colors are specified as 256-color palette indices. Run `spectrum_ls` in your terminal to browse all available colors.
Color names (`white`, `cyan`, `yellow`, etc.) are also accepted where noted.

The values below are the defaults for dark mode. Light mode automatically overrides them with darker variants for readability on light backgrounds.

| Variable | Default (dark) | Description |
|---|---|---|
| `FGPROMPT_USER` | `027` | `user@host` color (normal user) |
| `FGPROMPT_ROOT` | `196` | `root@host` color |
| `FRAMEPROMPT_USER` | `073` | Frame characters color (`┌`, `└─`, brackets) for normal user |
| `FRAMEPROMPT_ROOT` | `027` | Frame characters color for root |
| `VCSPROMPT_COLOR` | `067` | VCS branch info color (git, svn, hg, bzr) |
| `VENVPROMPT_COLOR` | `white` | Virtual environment name color (color name or index) |
| `SSHPROMPT_COLOR` | `yellow` | SSH indicator color |
| `TMUXPROMPT_COLOR` | `cyan` | Tmux indicator color |
| `DOCKERPROMPT_COLOR` | `033` | Docker/container indicator color |
| `NIXPROMPT_COLOR` | `105` | Nix shell indicator color |
| `K8SPROMPT_COLOR` | `069` | Kubernetes context indicator color |
| `CMDTIME_COLOR` | `220` | Command duration color |
| `PATHPROMPT_COLOR` | `terminal_default` | Path color — use `terminal_default` for the terminal's default foreground color, or any color name/index |

### Command duration

| Variable | Default | Description |
|---|---|---|
| `SHOW_CMD_DURATION` | `yes` | Show command execution time in RPROMPT |
| `CMDTIME_THRESHOLD` | `3` | Minimum seconds before duration is displayed |

### Async VCS

| Variable | Default | Description |
|---|---|---|
| `ASYNC_VCS_INFO` | `yes` | Run VCS info asynchronously to avoid prompt lag |

## Environment indicators

The prompt automatically detects and displays the following environments:

| Indicator | Detection method | Description |
|---|---|---|
| `SSH` | `$SSH_CONNECTION` | Remote SSH session |
| `tmux` | `$TMUX` | Inside a tmux session |
| `container` | `/.dockerenv`, `/run/.containerenv`, `$container` | Docker or Podman container |
| `nix` | `$IN_NIX_SHELL`, `$NIX_STORE` | Nix shell environment |
| `k8s context` | `kubectl config current-context` | Active Kubernetes context (only if `kubectl` is installed) |
| `venv/conda` | `$VIRTUAL_ENV`, `$CONDA_DEFAULT_ENV` | Python virtual environment |

## VCS support

The theme uses zsh's built-in `vcs_info` framework, which supports:
- **Git** — branch, staged (`+`), unstaged (`!`), and current action (rebase, merge, etc.)
- **SVN** — current revision
- **Mercurial (hg)** — branch
- **Bazaar (bzr)** — branch

## Font
By default, Kali Linux uses FiraCode as default terminal font.
You can [install](https://github.com/tonsky/FiraCode/wiki/Installing) it on your distro for a better Kali Look'n'Feel ...

## License
MIT [Cyril Lamy](https://github.com/clamy54)
