#!/bin/bash
bash <(curl -SL https://code.kubectl.net/devops/build-project/raw/branch/main/docker/install/install_apt_tpl.sh) \
  "ubuntu" \
  "https://download.docker.com"
