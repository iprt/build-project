#!/bin/bash
# shellcheck disable=SC1090
source <(curl -sSL https://code.kubectl.net/devops/build-project/raw/branch/main/func/log.sh)

function stop_systemd_service() {
  local service_name=$1
  log "systemd" "stop systemd service: $service_name"
  if systemctl -l | grep -q "$service_name"; then
    systemctl stop "$service_name"
    return 0
  else
    log "systemd" "service does not exist : $service_name"
    return 1
  fi
}

function start_systemd_service() {
  local service_name=$1
  log "systemd" "start systemd service: $service_name"
  #  if systemctl -l -a | grep -q "$service_name"; then
  #    systemctl restart "$service_name"
  #    return 0
  if [ -f "/usr/lib/systemd/system/$service_name.service" ] || [ -f "/usr/lib/systemd/system/$service_name" ]; then
    systemctl restart "$service_name"
    return 0
  else
    log "systemd" "service does not exist : $service_name"
    return 1
  fi
}
