#!/bin/bash
# shellcheck disable=SC1090
# source <(curl -SL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
ROOT_URI=https://code.kubectl.net/devops/build-project/raw/branch/main

array=("A" "B" "C")
for element in "${array[@]}"; do
  echo "$element"
done

echo "----"

node_image="node:22"
array=('npm install --registry=https://registry.npmmirror.com' 'npm run build')
for element in "${array[@]}"; do
  # shellcheck disable=SC2154
  echo "bash <(curl -SL $ROOT_URI/node/build.sh)" \
    -i "$node_image" \
    -x "$element"
done
