#!/bin/bash

alias reload="exec bash"

# neovim
alias vim="nvim"
alias vi="vim"

# editting bash files
alias brc="vim ~/.bashrc"
alias baliases="vim ~/.bash_aliases"
alias bfunctions="vim ~/.bash_functions"
alias benvs="vim ~/.bash_envs"

alias clip="wl-copy"
alias bat="batcat"
alias cat="batcat --theme base16"

# cd utils
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias 2..="..."
alias ....='cd ../../..'
alias 3..="...."
alias .....='cd ../../../..'
alias 4..="....."

alias h="history | grep "

alias whatismyip="curl ipinfo.io"

# Laravel / PHP
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# Python
alias venv-create="python3 -m venv .venv"
alias venv-activate="source .venv/bin/activate"
alias venv-deactivate="source .venv/bin/deactivate"

# ifconfig
alias ipconfig="ifconfig"

# pwgen
alias password-generator="pwgen -y 25"
alias genpassword="pwgen -y 25"

# timg (terminal image)
alias timg="timg -p kitty"
