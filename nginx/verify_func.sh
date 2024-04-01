#!/bin/bash
# shellcheck disable=SC1090
source <(curl -sSL https://code.kubectl.net/devops/build-project/raw/branch/main/func/log.sh)
source <(curl -sSL https://code.kubectl.net/devops/build-project/raw/branch/main/func/command_exists.sh)

function verify_nginx_configuration() {
  log "nginx" "Verify the nginx configuration file that docker-compose starts"
  local service_name=$1

  if [ -z "$service_name" ]; then
    log "nginx" "service_name is empty, then exit"
    exit 1
  fi

  local output
  if command_exists docker-compose; then
    log "nginx" "use docker-compose"
    output=$(docker-compose run -it --rm "$service_name" nginx -t | tail -n 2 | grep 'nginx:')
  else
    log "nginx" "use docker compose plugin"
    output=$(docker compose run -it --rm "$service_name" nginx -t | tail -n 2 | grep 'nginx:')
  fi

  if [ -z "$output" ]; then
    log "nginx" "output is empty. Unknown Configuration"
    return 1
  fi
  # template

  #nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
  #nginx: configuration file /etc/nginx/nginx.conf test is successful

  #nginx: [emerg] unknown directive "xworker_processes" in /etc/nginx/nginx.conf:1
  #nginx: configuration file /etc/nginx/nginx.conf test failed

  local reason
  reason=$(echo "$output" | sed -n '1p')
  local status
  status=$(echo "$output" | sed -n '2p')

  if echo "$status" | grep -q "successful"; then
    log "nginx" "$status"
    return 0
  elif echo "$status" | grep -q "failed"; then
    log "nginx" "$reason"
    return 1
  else
    log "nginx" "Unknown Configuration"
    return 1
  fi

}
