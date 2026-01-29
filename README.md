M_N_M_L
=======

Damn son! Show me teh codez!!
=============================
[zinit](https://github.com/zdharma-continuum/zinit):
```
zinit light bitcrush/minimal
```

[Zgen](https://github.com/tarjoilija/zgen):
```
zgen load bitcrush/minimal minimal
```

[Antigen](https://github.com/zsh-users/antigen):
```
antigen theme bitcrush/minimal minimal
```

[Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh):
```
cd path/to/ohmyzsh/custom/themes
wget https://raw.github.com/bitcrush/minimal/master/minimal.zsh-theme
```
And set `ZSH_THEME="minimal"` somewhere in .zshrc.
Note that there is already a theme named *minimal* but themes under *custom*
folder should take precedence. If not, you can always rename to
`minimal-custom.zsh-theme` and set `ZSH_THEME="minimal-custom"`.

Or, since it doesn't rely on any framework, you can always grab and source it.

Configuration variables
=======================
To configure the prompt, you can set the following variables in your `.zshrc` or `.zshenv` before loading the theme:
- `MINIMAL_PROMPT_CHAR_LEFT` (default: `❯`) -- character of the separator for the left prompt
- `MINIMAL_PROMPT_CHAR_RIGHT` (default: `❮`) -- character of the separator for the right prompt
- `MINIMAL_PROMPT_CHAR_VI_LEFT` (default: `❮`) -- character of the separator for the left prompt when in vi command mode
- `MINIMAL_PROMPT_CHAR_VI_RIGHT` (default: `❯`) -- character of the separator for the right prompt when in vi command mode
- `MINIMAL_ACCENT_COLOR` (default: `green`) -- default accent color for the prompt separators (possible values are: `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`)

What does it shows?
===================
Let's breakdown the left prompt (from left to right):
- SSH connection:
        - user@hostname if logged in via SSH
- User privilege:
	- red if root.
	- green if not.
- Background jobs:
	- blue if 1 or more jobs in background.
	- reset if 0 jobs.
- Keymap indicator:
	- magenta if in main or vi insert mode
	- green if in vi command mode

On the right prompt:
- Separator
- Exit Code:
	- reset if last command returned 0.
	- display the code if the last command did not return 0.
- The two last diretory from `pwd`.
- The git branch name only when you are in a git repo.
	Its color shows different statues:
	- red if is dirty or has diverged from origin
	- yellow if is behind
	- white if is ahead
	- green if none of the above

LICENSE
=======
MIT (see LICENSE file)
