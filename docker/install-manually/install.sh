#!/bin/bash
# shellcheck disable=SC2164 disable=SC2086 disable=SC1090
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

if [ -z $ROOT_URI ]; then
  source <(curl -SL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
else
  echo "\033[0;32mROOT_URI=$ROOT_URI\033[0m"
fi
source <(curl -sSL $ROOT_URI/func/log.sh)

arch=$1
version=$2

if [ -z $arch ]; then
  arch="x86_64"
fi

if [ -z $version ]; then
  version="27.3.1"
fi

function download_and_move() {
  rm -rf docker-$version.tgz docker/
  log_info "print" "arch = $arch; version=$version"
  curl https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/static/stable/$arch/docker-$version.tgz -o docker-$version.tgz
  tar zxvf docker-$version.tgz
  mv docker/* /usr/bin/
  rm -rf docker docker-$version.tgz
}

function config_systemd() {
  log_info "systemd" "config docker.service"
  curl $ROOT_URI/docker/install-manually/systemd/docker.service -o /usr/lib/systemd/system/docker.service

  log_info "systemd" "config docker.socket"
  curl $ROOT_URI/docker/install-manually/systemd/docker.socket -o /usr/lib/systemd/system/docker.socket

  log_info "systemd" "config containerd.service"
  curl $ROOT_URI/docker/install-manually/systemd/containerd.service -o /usr/lib/systemd/system/containerd.service

  log_info "systemd" "mkdir -p /etc/systemd/system/docker.service.d"
  mkdir -p /etc/systemd/system/docker.service.d
}

cd /tmp
groupadd docker
download_and_move
config_systemd
systemctl daemon-reload
