#!/bin/zsh

#############################################################################
#                                                                           #
#                    KALI-LIKE THEME for Oh-My-Zsh                          #
#                                                                           #
#############################################################################
#                                                                           #
#  For better "kali-like" experience, use FiraCode font for your terminal   #
#  and install zsh-syntax-highlighting and zsh-autosuggestions packages     #
#                                                                           #
#############################################################################
#                                                                           #
# CREDITS :                                                                 #
# Some parts of this code was directly ripped from Kali Linux .zshrc        #
#                                                                           #
#############################################################################
# (C) 2023-2026 Cyril LAMY under the MIT License                            #
#############################################################################

#####   OPTIONS     #####

USE_SYNTAX_HIGHLIGHTING=yes
AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN=yes

USE_ZSH_AUTOSUGGESTIONS=yes
AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN=yes

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

# Theme mode: "auto" (detect terminal background), "dark", or "light"
THEME_MODE=auto

# Colors for the prompt (256-color palette indices)
# Run 'spectrum_ls' in your terminal to see all available colors
# These are the default (dark) colors; light mode overrides them below
FGPROMPT_USER=027
FGPROMPT_ROOT=196
FRAMEPROMPT_USER=073
FRAMEPROMPT_ROOT=027
VENVPROMPT_COLOR=white
VCSPROMPT_COLOR=067
SSHPROMPT_COLOR=yellow
TMUXPROMPT_COLOR=cyan
DOCKERPROMPT_COLOR=033
NIXPROMPT_COLOR=105
K8SPROMPT_COLOR=069
CMDTIME_COLOR=220
# Show command execution time if it exceeds CMDTIME_THRESHOLD seconds
SHOW_CMD_DURATION=yes
CMDTIME_THRESHOLD=3
# Async vcs_info: avoid prompt lag in large repositories
ASYNC_VCS_INFO=yes
# PATHPROMPT_COLOR: color of the ~/path in the prompt
#   "terminal_default" : use the terminal's default foreground color
#   color name         : e.g. white, cyan, yellow, red, green, blue, magenta
#   256-color index    : e.g. 073, 220 (run 'spectrum_ls' to browse)
PATHPROMPT_COLOR=terminal_default
# Number of ─ characters after the initial ┌─
PROMPT_DASH_COUNT=3

#### END OF OPTIONS #####

# Resolve theme mode
_resolved_theme_mode="$THEME_MODE"
if [[ "$_resolved_theme_mode" == auto ]]; then
    _resolved_theme_mode=dark
    if [[ -n "$COLORFGBG" ]]; then
        # COLORFGBG format: "fg;bg" — bg >= 8 means light background
        local _bg_color="${COLORFGBG##*;}"
        if [[ "$_bg_color" =~ '^[0-9]+$' ]] && (( _bg_color >= 8 )); then
            _resolved_theme_mode=light
        fi
    fi
fi

# Override colors for light terminal backgrounds
if [[ "$_resolved_theme_mode" == light ]]; then
    FGPROMPT_USER=025
    FGPROMPT_ROOT=160
    FRAMEPROMPT_USER=030
    FRAMEPROMPT_ROOT=025
    VENVPROMPT_COLOR=053
    VCSPROMPT_COLOR=024
    SSHPROMPT_COLOR=166
    TMUXPROMPT_COLOR=030
    DOCKERPROMPT_COLOR=025
    NIXPROMPT_COLOR=055
    K8SPROMPT_COLOR=025
    CMDTIME_COLOR=130
    [[ "$PATHPROMPT_COLOR" == terminal_default ]] && PATHPROMPT_COLOR=terminal_default
fi

setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt share_history       # all sessions share the same history files

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

setopt hist_verify            # show command with history expansion to user before running it

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:*' unstagedstr '%F{red}!%f'

configure_prompt() {
    zstyle ':vcs_info:*' formats "%{$FG[$VCSPROMPT_COLOR]%}[%b%c%u%{$FG[$VCSPROMPT_COLOR]%}] %{$reset_color%}"
    zstyle ':vcs_info:*' actionformats "%{$FG[$VCSPROMPT_COLOR]%}[%b|%a%c%u%{$FG[$VCSPROMPT_COLOR]%}] %{$reset_color%}"

    if [[ $UID == 0 || $EUID == 0 ]]; then
        FGPROMPT="$FG[$FGPROMPT_ROOT]"
        FRAMEPROMPT="$FG[$FRAMEPROMPT_ROOT]"
    else
        FRAMEPROMPT="$FG[$FRAMEPROMPT_USER]"
        FGPROMPT="$FG[$FGPROMPT_USER]"
    fi

    local dashes=${(l:$PROMPT_DASH_COUNT::─:)}
    local ssh_indicator=''
    local tmux_indicator=''
    local docker_indicator=''
    local nix_indicator=''
    [[ -n "$SSH_CONNECTION" ]] && ssh_indicator="─(%F{$SSHPROMPT_COLOR}SSH$FRAMEPROMPT)"
    [[ -n "$TMUX" ]] && tmux_indicator="─(%F{$TMUXPROMPT_COLOR}tmux$FRAMEPROMPT)"
    [[ -f /.dockerenv || -f /run/.containerenv || -n "$container" ]] && docker_indicator="─(%F{$DOCKERPROMPT_COLOR}container$FRAMEPROMPT)"
    [[ -n "$IN_NIX_SHELL" || -n "$NIX_STORE" ]] && nix_indicator="─(%F{$NIXPROMPT_COLOR}nix$FRAMEPROMPT)"

    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'$FRAMEPROMPT┌─'$dashes$ssh_indicator$tmux_indicator$docker_indicator$nix_indicator$'$(if [[ -n $VIRTUAL_ENV ]]; then echo "─(%F{$VENVPROMPT_COLOR}$(basename $VIRTUAL_ENV)$FRAMEPROMPT)"; elif [[ -n $CONDA_DEFAULT_ENV ]]; then echo "─(%F{$VENVPROMPT_COLOR}$CONDA_DEFAULT_ENV$FRAMEPROMPT)"; fi)$(if whence -p kubectl &>/dev/null; then local _ctx=$(kubectl config current-context 2>/dev/null); [ -n "$_ctx" ] && echo "─(%F{$K8SPROMPT_COLOR}$_ctx$FRAMEPROMPT)"; fi)\(%B$FGPROMPT%n@%m%b$FRAMEPROMPT)-[%B$([ "$PATHPROMPT_COLOR" = "terminal_default" ] && echo "%F{reset}" || echo "%F{$PATHPROMPT_COLOR}")%(6~.%-1~/…/%4~.%5~)%b$FRAMEPROMPT]${vcs_info_msg_0_}\n$FRAMEPROMPT└─%(?.%B%(#.%F{red}#.$FGPROMPT$).%F{red}✘ %B%(#.%F{red}#.$FGPROMPT$))%b%F{reset} '
            RPROMPT='${_cmd_duration_msg}'
            ;;
        oneline)
            PROMPT=$'$([ -n "$SSH_CONNECTION" ] && echo "%F{$SSHPROMPT_COLOR}SSH%F{reset} ")$([ -n "$TMUX" ] && echo "%F{$TMUXPROMPT_COLOR}tmux%F{reset} ")$([ -f /.dockerenv ] || [ -f /run/.containerenv ] || [ -n "$container" ] && echo "%F{$DOCKERPROMPT_COLOR}container%F{reset} ")$([ -n "$IN_NIX_SHELL" ] || [ -n "$NIX_STORE" ] && echo "%F{$NIXPROMPT_COLOR}nix%F{reset} ")%B$FGPROMPT%n@%m%b%F{reset}:%B$([ "$PATHPROMPT_COLOR" = "terminal_default" ] && echo "%F{reset}" || echo "%F{$PATHPROMPT_COLOR}")%~%b${vcs_info_msg_0_}%F{reset}$(if whence -p kubectl &>/dev/null; then local _ctx=$(kubectl config current-context 2>/dev/null); [ -n "$_ctx" ] && echo " %F{$K8SPROMPT_COLOR}[$_ctx]%F{reset}"; fi)%(?.%(#.#.$).%F{red}✘%F{reset}) '
            RPROMPT='${_cmd_duration_msg}'
            ;;
    esac

    [[ "$NEWLINE_BEFORE_PROMPT" == yes ]] && PROMPT=$'\n'"$PROMPT"
}

configure_prompt

# async vcs_info: run in background and signal parent to refresh prompt
_kali_async_vcs_tmpfile="/tmp/.kali_vcs_info_$$"

_kali_async_vcs() {
    vcs_info
    printf '%s' "${vcs_info_msg_0_}" > "$_kali_async_vcs_tmpfile"
    kill -USR1 $$ 2>/dev/null
}

TRAPUSR1() {
    if [[ -f "$_kali_async_vcs_tmpfile" ]]; then
        vcs_info_msg_0_="$(<"$_kali_async_vcs_tmpfile")"
        zle && zle reset-prompt
    fi
}

_kali_precmd() {
    # command duration
    if [[ "$SHOW_CMD_DURATION" == yes && -n "$_cmd_start_time" ]]; then
        local elapsed=$(( SECONDS - _cmd_start_time ))
        if (( elapsed >= CMDTIME_THRESHOLD )); then
            local mins=$(( elapsed / 60 ))
            local secs=$(( elapsed % 60 ))
            if (( mins > 0 )); then
                _cmd_duration_msg="%F{$CMDTIME_COLOR}${mins}m${secs}s%f"
            else
                _cmd_duration_msg="%F{$CMDTIME_COLOR}${secs}s%f"
            fi
        else
            _cmd_duration_msg=''
        fi
        unset _cmd_start_time
    else
        _cmd_duration_msg=''
    fi

    # vcs_info: async or sync
    if [[ "$ASYNC_VCS_INFO" == yes ]]; then
        vcs_info_msg_0_=''
        _kali_async_vcs &!
    else
        vcs_info
    fi
}

_kali_preexec() {
    _cmd_start_time=$SECONDS
}

# cleanup temp file on exit
_kali_zshexit() {
    rm -f "$_kali_async_vcs_tmpfile"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _kali_precmd
add-zsh-hook preexec _kali_preexec
add-zsh-hook zshexit _kali_zshexit

if [ "$USE_SYNTAX_HIGHLIGHTING" = yes ]; then

    syntax_highlighting=no

    # enable syntax-highlighting if avalaible

    if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        syntax_highlighting=yes
    fi

    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        syntax_highlighting=yes
    fi

    if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        syntax_highlighting=yes

    fi

    if [ "$syntax_highlighting" = no ]; then
        if [ "$AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN" = yes ]; then
            if whence -cp git &> /dev/null; then
                mkdir ~/.zsh >/dev/null 2>&1
                git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting >/dev/null 2>&1
                if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
                    . ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
                    syntax_highlighting=yes
                else
                    echo "Failed to clone zsh-syntax-highlighting plugin"
                fi
            else
                echo "git not found, plugin zsh_syntax_highlighting not installed"
            fi
        fi
    fi


    if [ "$syntax_highlighting" = yes ]; then
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=$FRAMEPROMPT_USER,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=$FRAMEPROMPT_USER,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=$FRAMEPROMPT_USER,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=$FRAMEPROMPT_USER,underline
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=$FRAMEPROMPT_USER
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=$FRAMEPROMPT_USER
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=$FRAMEPROMPT_USER,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout

        if [[ "$_resolved_theme_mode" == light ]]; then
            ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
            ZSH_HIGHLIGHT_STYLES[path]=fg=black,bold
            ZSH_HIGHLIGHT_STYLES[arg0]=fg=240
            ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=130
            ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=130
            ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=130
            ZSH_HIGHLIGHT_STYLES[comment]=fg=246
        else
            ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
            ZSH_HIGHLIGHT_STYLES[path]=fg=white,bold
            ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
            ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
            ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
            ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
            ZSH_HIGHLIGHT_STYLES[comment]=fg=240
        fi
    fi

    unset syntax_highlighting

fi

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt



# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    alias pacman='pacman --color=auto'


    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

if [ "$USE_ZSH_AUTOSUGGESTIONS" = yes ]; then

    zsh_autosuggestions=no

    # enable auto-suggestions based on completion and  history
    if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
        # change suggestion color
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
        zsh_autosuggestions=yes
    fi

    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        # change suggestion color
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
        zsh_autosuggestions=yes
    fi

    if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
        # change suggestion color
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        zsh_autosuggestions=yes
    fi

    if [ "$zsh_autosuggestions" = no ]; then
        if [ "$AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN" = yes ]; then
            if whence -cp git &> /dev/null; then
                mkdir ~/.zsh >/dev/null 2>&1
                git clone --quiet https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions >/dev/null 2>&1
                if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
                    . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
                    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
                    ZSH_AUTOSUGGEST_STRATEGY=(completion history)
                    zsh_autosuggestions=yes
                else
                    echo "Failed to clone zsh-autosuggestions plugin"
                fi
            else
                echo "git not found, plugin zsh_autosuggestions not installed"
            fi
        fi
    fi
fi


# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# hide default virtual environment
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CONDA_CHANGEPS1=false
