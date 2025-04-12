#!/bin/bash
# shellcheck disable=SC1090 disable=SC2154 disable=SC2086 disable=SC2028
[ -z $ROOT_URI ] && source <(curl -sSL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
echo -e "\033[0;32mROOT_URI=$ROOT_URI\033[0m"
source <(curl -sSL $ROOT_URI/func/log.sh)
source <(curl -sSL $ROOT_URI/func/date.sh)

if [ ! -d "/etc/apt/apt.conf.d/" ]; then
  log_error "proxy_apt occurred error: directory /etc/apt/apt.conf.d/ does not exist"
  exit
fi

# remove proxy
function apt_rm_proxy() {
  log_warn "remove proxy" "rm -rf /etc/apt/apt.conf.d/proxy.conf"
  rm -rf "/etc/apt/apt.conf.d/proxy.conf"
}

apt_rm_proxy
