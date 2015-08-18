autoload -U colors && colors

setopt prompt_subst

# pr_char="❯"
pr_char=">"

pr_green="%{$fg[green]%}"
pr_red="%{$fg[red]%}"
pr_blue="%{$fg[blue]%}"
pr_yellow="%{$fg[yellow]%}"
pr_magenta="%{$fg[magenta]%}"
pr_reset="%{$reset_color%}"

function prompt_user() {
    local sshconn=""
    (( EUID == 0 )) && pr_user=$pr_red || pr_user=$pr_green
    [[ -n "$SSH_CONNECTION" ]] && sshconn+="${pr_user}%n${pr_reset}@%M "
    echo "${sshconn}%(!.$pr_red.$pr_reset)${pr_char}$pr_reset"
}

function prompt_jobs() {
    echo "%(1j.$pr_blue.$pr_reset)${pr_char}$pr_reset"
}

function prompt_status() {
    echo "%(0?.$pr_reset.$pr_red)%?$pr_reset"
}

function -prompt_ellipse(){
    local string=$1
    local sep="$rsc..$path_color"
    if [[ $MINIMAL_SHORTEN == true ]] && [[ ${#string} -gt 10 ]]; then
      echo "${string:0:4}$sep${string: -4}"
    else
      echo $string
    fi
}

function prompt_path() {
    local path_color="$pr_magenta"
    local rsc="$pr_reset"
    local sep="$rsc/$path_color"

    echo "$path_color$(print -P %2~ | sed s_/_${sep}_g)$rsc"
}

function git_branch_name() {
    local branch_name="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    [[ -n $branch_name ]] && echo "$branch_name"
}

function git_repo_status(){
    local rs="$(git status --porcelain -b)"

    if $(echo "$rs" | grep -v '^##' &> /dev/null); then # is dirty
      echo "$pr_red"
    elif $(echo "$rs" | grep '^## .*diverged' &> /dev/null); then # has diverged
      echo "$pr_red"
    elif $(echo "$rs" | grep '^## .*behind' &> /dev/null); then # is behind
      echo "$pr_yellow"
    elif $(echo "$rs" | grep '^## .*ahead' &> /dev/null); then # is ahead
      echo "$pr_reset"
    else # is clean
      echo "$pr_green"
    fi
}

function prompt_git() {
    local bname=$(git_branch_name)
    if [[ -n $bname ]]; then
      local infos="$(git_repo_status)${bname}$pr_reset"
      echo " $infos"
    fi
}

function prompt_vimode(){
    local ret=""

    case $KEYMAP in
      main|viins)
        ret+="$pr_green"
        pr_char=">"
        RSEP="${pr_green}<$pr_reset"
        ;;
      vicmd)
        ret+="$pr_magenta"
        pr_char="»"
        RSEP="${pr_green}«$pr_reset"
        ;;
    esac

    ret+="${pr_char}$pr_reset"

    echo "$ret"
}

function prompt_vimode_right(){
    case $KEYMAP in
      main|viins)
        rsep="${pr_green}<$pr_reset"
        ;;
      vicmd)
        rsep="${pr_magenta}«$pr_reset"
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

# PROMPT='$(prompt_user)$(prompt_jobs)$(prompt_vimode)$(prompt_status) '
PROMPT='$(prompt_user)$(prompt_jobs)$(prompt_vimode) '
RPROMPT='$(prompt_vimode_right) $(prompt_status) $(prompt_path)$(prompt_git)'

# vim: ft=zsh
