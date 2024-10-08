#!/bin/bash
# shellcheck disable=SC1090 disable=SC2086
# source <(curl -SL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
ROOT_URI=https://code.kubectl.net/devops/build-project/raw/branch/main

registry="docker.io"
image_name_list=("hello" "world")

# 使用 for 循环来遍历数组中的每个元素
for image_name in "${image_name_list[@]}"; do
  echo "remove image is : $registry/$image_name"
  bash <(curl -SL $ROOT_URI/docker/rmi.sh) \
    -i "$registry/$image_name" \
    -s "contain_latest"
done
