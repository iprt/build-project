#!/bin/bash
# shellcheck disable=SC1090 disable=SC2086
source <(curl -SL https://gitlab.com/iprt/shell-basic/-/raw/main/basic.sh)

bash <(curl -SL $ROOT_URI/docker/install/install_apt_tpl.sh) \
  "ubuntu" \
  "https://mirrors.intellij.tech/container/docker-ce"
