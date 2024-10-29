#!/bin/bash
# shellcheck disable=SC1090 disable=SC2154  disable=SC2086
# source <(curl -SL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
ROOT_URI=https://code.kubectl.net/devops/build-project/raw/branch/main

source <(curl -SL $ROOT_URI/func/log.sh)
source <(curl -SL $ROOT_URI/func/detect_os.sh)

log "update" "update system & prepare"

function apt_upgrade() {
  apt-get update -y
  # WARNING: apt does not have a stable CLI interface. Use with caution in scripts
  #  DEBCONF_NONINTERACTIVE_SEEN=true \
  echo '* libraries/restart-without-asking boolean true' | debconf-set-selections
  # Upgrade packages with automatic service restart NEEDRESTART_MODE=a
  DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    NEEDRESTART_MODE=a \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" --allow-downgrades --allow-remove-essential --allow-change-held-packages

  apt-get install -y sudo vim git wget net-tools jq lsof tree zip unzip
}

function other_update_todo() {
  #  yum update -y
  log_info "other" "todo ..."
}

if [ "$os_base_name" == "Ubuntu" ] || [ "$os_base_name" == "Debian" ]; then
  apt_upgrade
else
  other_update_todo
fi
