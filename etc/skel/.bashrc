#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

#### Auto-load files
[[ -e "$HOME/bash.aliases" ]] && source "$HOME/bash.aliases"
[[ -e "$HOME/bash.exports" ]] && source "$HOME/bash.exports"
[[ -e "$HOME/bash.fixes" ]] && source "$HOME/bash.fixes"
[[ -e "$HOME/bash_aliases" ]] && source "$HOME/bash_aliases"
[[ -e "$HOME/bash_exports" ]] && source "$HOME/bash_exports"
[[ -e "$HOME/bash_fixes" ]] && source "$HOME/bash_fixes"

# Print the Linux Name
uname -a
