autoload -U colors && colors

setopt prompt_subst

# PR_CHAR="❯"
PR_CHAR=">"

# prompt colors
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
done

PR_RESET="%{$reset_color%}"

RSEP="${PR_GREEN}<$PR_RESET"
LBRACKET="${PR_YELLOW}[$PR_RESET"
RBRACKET="${PR_YELLOW}]$PR_RESET"

function prompt_user() {
    echo "%(!.$PR_RED.$PR_RESET)${PR_CHAR}$PR_RESET"
}

function prompt_jobs() {
    echo "%(1j.$PR_BLUE.$PR_RESET)${PR_CHAR}$PR_RESET"
}

function prompt_status() {
    # echo "${LBRACKET}%(0?.$PR_RESET.$PR_RED)%?$PR_RESET${RBRACKET}"
    echo "%(0?.$PR_RESET.$PR_RED)%?$PR_RESET"
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
    local path_color="$PR_MAGENTA"
    local rsc="$PR_RESET"
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
      echo "$PR_RED"
    elif $(echo "$rs" | grep '^## .*diverged' &> /dev/null); then # has diverged
      echo "$PR_RED"
    elif $(echo "$rs" | grep '^## .*behind' &> /dev/null); then # is behind
      echo "$PR_YELLOW"
    elif $(echo "$rs" | grep '^## .*ahead' &> /dev/null); then # is ahead
      echo "$PR_RESET"
    else # is clean
      echo "$PR_GREEN"
    fi
}

function prompt_git() {
    local bname=$(git_branch_name)
    if [[ -n $bname ]]; then
      local infos="$(git_repo_status)${bname}$PR_RESET"
      echo " $infos"
    fi
}

function prompt_vimode(){
    local ret=""

    case $KEYMAP in
      main|viins)
        ret+="$PR_GREEN"
        ;;
      vicmd)
        ret+="$PR_MAGENTA"
        ;;
    esac

    ret+="${PR_CHAR}$PR_RESET"

    echo "$ret"
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
RPROMPT='$RSEP $(prompt_status) $(prompt_path)$(prompt_git)'

# vim: ft=zsh
