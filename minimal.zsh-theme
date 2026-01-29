## Minimal Zsh theme with Git and Vi mode indicators

autoload -U colors && colors
setopt prompt_subst

PR_CHAR_L="${MINIMAL_PROMPT_CHAR_LEFT:-"❯"}"
PR_CHAR_R="${MINIMAL_PROMPT_CHAR_RIGHT:-"❮"}"
PR_CHAR_VI_L="${MINIMAL_PROMPT_CHAR_VI_LEFT:-"❮"}"
PR_CHAR_VI_R="${MINIMAL_PROMPT_CHAR_VI_RIGHT:-"❯"}"

PR_GREEN="%{$fg[green]%}"
PR_RED="%{$fg[red]%}"
PR_BLUE="%{$fg[blue]%}"
PR_CYAN="%{$fg[cyan]%}"
PR_YELLOW="%{$fg[yellow]%}"
PR_MAGENTA="%{$fg[magenta]%}"
PR_DEFAULT="%{$fg[${MINIMAL_ACCENT_COLOR:-green}]%}"
PR_RESET="%{$reset_color%}"

function prompt_user() {
    local sshconn
    local pr_user

    (( EUID == 0 )) && pr_user=$PR_RED || pr_user=$PR_DEFAULT
    [[ -n "$SSH_CONNECTION" ]] && sshconn+="${pr_user}%n${PR_RESET}@%m "
    echo "${sshconn}%(!.$PR_RED.$PR_RESET)${PR_CHAR_L}${PR_RESET}"
}

function prompt_jobs() {
    echo "%(1j.${PR_BLUE}.${PR_RESET})${PR_CHAR_L}${PR_RESET}"
}

function prompt_status() {
    echo "%(0?..${PR_CYAN}[${PR_RESET}%?${PR_CYAN}] ${PR_RESET})"
}

function prompt_path() {
    echo "%{[38;5;244m%}%2~%{$reset_color%}"
}

function git_branch_name() {
    local branch_name="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

    [[ -n $branch_name ]] && echo "$branch_name"
}

function git_repo_status() {
    local rs="$(git status --porcelain -b)"

    if $(echo "$rs" | grep -v '^##' &> /dev/null); then # is dirty
      echo "$PR_RED"
    elif $(echo "$rs" | grep '^## .*diverged' &> /dev/null); then # has diverged
      echo "$PR_RED"
    elif $(echo "$rs" | grep '^## .*behind' &> /dev/null); then # is behind
      echo "$PR_YELLOW"
    elif $(echo "$rs" | grep '^## .*ahead' &> /dev/null); then # is ahead
      echo "$PR_RESET"
    else # is clean
      echo "$PR_DEFAULT"
    fi
}

function prompt_git() {
    local bname=$(git_branch_name)
    local infos

    if [[ -n $bname ]]; then
      infos="$(git_repo_status)${bname}${PR_RESET}"
      echo " $infos"
    fi
}

function prompt_vimode() {
    local ret=""
    local pr_char

    case $KEYMAP in
      vicmd)
        ret+="$PR_MAGENTA"
        pr_char="$PR_CHAR_VI_L"
        ;;
      *)
        ret+="$PR_DEFAULT"
        pr_char="$PR_CHAR_L"
        ;;
    esac

    ret+="${pr_char}${PR_RESET}"

    echo "$ret"
}

function prompt_vimode_right() {
    local rsep=""

    case $KEYMAP in
      vicmd)
        rsep="${PR_MAGENTA}${PR_CHAR_VI_R}${PR_RESET}"
        ;;
      *)
        rsep="${PR_DEFAULT}${PR_CHAR_R}${PR_RESET}"
        ;;
    esac

    echo "$rsep"
}

function zle-line-init zle-line-finish zle-keymap-select {
    zle reset-prompt
    zle -R
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

PROMPT='$(prompt_user)$(prompt_jobs)$(prompt_vimode) '
RPROMPT='$(prompt_vimode_right) $(prompt_status)$(prompt_path)$(prompt_git)'

# vim: ft=zsh
