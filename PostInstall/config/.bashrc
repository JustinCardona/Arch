#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Aliases
alias ls='ls --color=auto'
alias la='ls -al --color=auto'
alias clean='paru --noconfirm -c; paru --noconfirm -Sc; sudo journalctl --vacuum-time=1weeks;rm -rf ~/Downloads/*; rm -rf ~/.cache/*'
alias todo='cat ~/School/toDoList'
alias con='source /opt/anaconda/bin/activate root'
alias coff='source /opt/anaconda/bin/deactivate root'
