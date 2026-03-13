#!/bin/bash

#cd() {
#    if [ -n "$1" ]; then
#        builtin cd "$@" && ls
#    else
#        builtin cd ~ && ls
#    fi
#}

# Automatically mkdir and then cd to it
mkdircd() {
    mkdir -p "$1" && cd "$1"
}

# Extracts any archive(s) (if unp isn't installed)
extract() {
    for archive in "$@"; do
        if [ -f "$archive" ]; then
            case $archive in
            *.tar.bz2) tar xvjf $archive ;;
            *.tar.gz) tar xvzf $archive ;;
            *.bz2) bunzip2 $archive ;;
            *.rar) rar x $archive ;;
            *.gz) gunzip $archive ;;
            *.tar) tar xvf $archive ;;
            *.tbz2) tar xvjf $archive ;;
            *.tgz) tar xvzf $archive ;;
            *.zip) unzip $archive ;;
            *.Z) uncompress $archive ;;
            *.7z) 7z x $archive ;;
            *) echo "don't know how to extract '$archive'..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

explorer() {
    nautilus "$@" &
}

# Define the vpn function
vpn() {
    case "$1" in
    connect)
        snx <~/.snxrc.password
        ;;
    disconnect)
        snx -d
        ;;
    reconnect)
        snx -d
        sleep 2
        snx <~/.snxrc.password
        ;;
    *)
        echo "Usage: vpn {connect|disconnect|reconnect}"
        return 1
        ;;
    esac
}

# Bash completion for vpn function
_vpn_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="connect disconnect reconnect"

    if [[ "$cur" == -* ]]; then
        return
    fi

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F _vpn_completions vpn

# ifconig
ifconfig() {
    if [[ $1 == "eth" ]]; then
        /usr/sbin/ifconfig | awk '/^eno0/,/^$/'
    elif [[ $1 == "wlan" || $1 == "wifi" ]]; then
        /usr/sbin/ifconfig | awk '/^wlp0/,/^$/'
    else
        /usr/sbin/ifconfig
    fi
}

# ping
ping() {
    # Process args
    local i=0
    local options=""
    local host=""
    for arg; do
        i=$(($i + 1))
        if [ "$i" -lt "$#" ]; then
            options="${options} ${arg}"
        else
            host="${arg}"
        fi
    done

    # Find host
    local hostname=$(awk -v \
        host="$host" \
        '$1=="Host" {for(i=2;i<=NF;i++) if($i==host) {found=1; next}}
  found && $1=="HostName" {print $2; exit}' \
        ~/.ssh/config)

    if [ -z "$hostname" ]; then
        hostname="$host"
    fi

    # Run ping
    /usr/bin/ping $options $hostname
}

complete -W "$(grep '^[[:space:]]*Host[[:space:]]' ~/.ssh/config | awk '{for(i=2;i<=NF;i++) print $i}')" ping

# Aliasing `apt` to `nala` apt frontend
apt() {
    # Try command without sudo first
    /usr/bin/nala "$@" 2>/dev/null
    local exit_code="$?"

    # If failed due to permissions, retry with sudo
    if [[ $exit_code = 1 ]]; then
        echo "Nala needs sudo to proceed..."
        sudo /usr/bin/nala "$@"
    fi
}
