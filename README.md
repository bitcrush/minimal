M_N_M_L
=======

Damn son! Show me teh codez!!
=============================
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

What does it shows?
===================
Let's breakdown the left prompt (from left to right):
- User privilege:
	- red if root.
	- green if not.
- Background jobs:
	- blue if 1 or more jobs in background.
	- reset if 0 jobs.
- Keymap indicator:
	- magenta if in main or vi insert mode
	- green if in vi command mode
- Exit status:
	- reset if last command returned 0.
	- red if not.

On the right prompt:
- The two last diretory from `pwd`.
	- Directory names longer than 10 chars will be abbreviated if
	`MINIMAL_SHORTEN` is set to `true`.  
	eg: `01234567890ABCDEF -> 0123..CDEF`
- The git branch name only when you are in a git repo.
	Its color shows different statues:
	- red if is dirty or has diverged from origin
	- yellow if is behind
	- white if is ahead
	- green if none of the above

LICENSE
=======
MIT (see LICENSE file)
