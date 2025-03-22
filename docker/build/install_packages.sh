#!/bin/sh
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
set -eu

n=0
max=2
export DEBIAN_FRONTEND=noninteractive

until [ $n -gt $max ]; do
  set +e
  (
    apt-get update -qq &&
      apt-get install -y --no-install-recommends "$@"
  )
  CODE=$?
  set -e
  if [ $CODE -eq 0 ]; then
    break
  fi
  if [ $n -eq $max ]; then
    exit $CODE
  fi
  echo "apt failed, retrying"
  n=$(($n + 1))
done
apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
