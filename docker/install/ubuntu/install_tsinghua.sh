#!/bin/bash
# shellcheck disable=SC1090 disable=SC2086
[ -z $ROOT_URI ] && source <(curl -sSL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh) && export ROOT_URI=$ROOT_URI
# ROOT_URI=https://dev.kubectl.net

bash <(curl -sSL $ROOT_URI/docker/install/install_apt_tpl.sh) \
  "ubuntu" \
  "https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
