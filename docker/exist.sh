#!/bin/bash
# shellcheck disable=SC1090 disable=SC2154 disable=SC2086 disable=SC2028
[ -z $ROOT_URI ] && source <(curl -sSL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh) && export ROOT_URI=$ROOT_URI
# ROOT_URI=https://dev.kubectl.net

source <(curl -sSL $ROOT_URI/func/log.sh)
source <(curl -sSL $ROOT_URI/func/command_exists.sh)

if command_exists docker; then
  log "command_exists" "docker 命令存在"
else
  log "command_exists" "docker 命令不存在"
  exit 1
fi
