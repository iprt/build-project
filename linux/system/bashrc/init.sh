#!/bin/bash
# shellcheck disable=SC1090 disable=SC2086 disable=SC2154
# source <(curl -SL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
ROOT_URI=https://code.kubectl.net/devops/build-project/raw/branch/main

source <(curl -SL $ROOT_URI/func/log.sh)
source <(curl -SL $ROOT_URI/func/detect_os.sh)

log_info "bashrc" "init bashrc"

file="$HOME/.bashrc"

if [ -f $file ]; then
  log_warn "bashrc" "try delete"
  sed -i '/^#9d5049f5-3f12-4004-9ac8-196956e91184/,/#58efd70b-e5be-4d58-856a-5807ed05b29d/d' $file
fi

function init_apt_bashrc() {
  log "bashrc" "append bashrc"
  cat <<EOF >>$file
#9d5049f5-3f12-4004-9ac8-196956e91184

# You may uncomment the following lines if you want \`ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "\$(dircolors)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "\$(dircolors -b ~/.dircolors)" || eval "\$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias lla='ls -ahlF --group-directories-first -X'
alias ll='ls -hlF --group-directories-first -X'
alias la='ls -A --group-directories-first -X'
alias l='ls -CF --group-directories-first -X'
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

export PS1="\$PS1\[\e]1337;CurrentDir="'\$(pwd)\a\]'

#58efd70b-e5be-4d58-856a-5807ed05b29d

EOF

  cat $file
}

function init_yum_bashrc() {
  log_warn "bashrc" "TODO append bashrc"
}

if [ "$os_base_name" == "Ubuntu" ] || [ "$os_base_name" == "Debian" ]; then
  init_apt_bashrc
else
  init_yum_bashrc
fi
