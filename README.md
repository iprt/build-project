# build project

<!-- TOC -->

* [build project](#build-project)
    * [functions](#functions)
        * [log func](#log-func)
        * [command_exists func](#command_exists-func)
        * [detect ssh port](#detect-ssh-port)
    * [build gradle's project](#build-gradles-project)
    * [build maven's project](#build-mavens-project)
    * [build golang's project](#build-golangs-project)
    * [docker](#docker)
        * [build docker's image (and push)](#build-dockers-image-and-push)
        * [remove docker's image](#remove-dockers-image)
        * [install docker](#install-docker)
    * [linux](#linux)
        * [bashrc](#bashrc)
    * [develop](#develop)
        * [config maven](#config-maven)

<!-- TOC -->

## functions

### log func

```shell
source <(curl -sSL https://code.kubectl.net/devops/build-project/raw/branch/main/func/log.sh)

log "hello" "world"
```

### command_exists func

```shell
source <(curl -sSL https://code.kubectl.net/devops/build-project/raw/branch/main/func/command_exists.sh)

if command_exists docker ; then
    echo "command docker exists"
fi
```

### detect ssh port

```shell
ssh_port="$(bash <(https://code.kubectl.net/devops/build-project/raw/branch/main/func/ssh_port.sh)"
echo "ssh port is $ssh_port"
```

## build gradle's project

build gradle's project by docker

```shell
bash <(curl https://code.kubectl.net/devops/build-project/raw/branch/main/gradle/build.sh) \
  -c <cache_volume> \
  -i <gradle_image> \
  -x <gradle_command>
```

- `-c`: gradle缓存: 使用`docker volume`挂载
- `-i`: gradle的镜像
- `-x`: gradle的命令
    - e.g. : `gradle clean build -x test`

## build maven's project

build maven's project by docker

```shell
bash <(curl https://code.kubectl.net/devops/build-project/raw/branch/main/gradle/build.sh) \
  -c <cache_volume> \
  -i <maven_image> \
  -s <path/to/settings.xml> \
  -x <maven_command>
```

- `-c`: maven缓存
- `-i`: maven镜像
- `-s`: maven `settings.xml` 在本地的路径
- `-x`: maven执行的命令
    - e.g. : `mvn clean install -Dmaven.test.skip=true`

## build golang's project

build golang's project by docker

```shell
bash <(curl https://code.kubectl.net/devops/build-project/raw/branch/main/golang/build.sh) \
  -c <cache_volume> \
  -i <gradle_image> \
  -x <gradle_command>
```

- `-c`: golang缓存: 使用`docker volume`挂载
- `-i`: golang的镜像
- `-x`: golang的命令
    - e.g. : `go build -v -o application`

## docker

### build docker's image (and push)

> by Dockerfile

```shell
bash <(curl https://code.kubectl.net/devops/build-project/raw/branch/main/gradle/build.sh) \
  -i <image_name> \
  -v <image_tag> \
  -r <re_tag_false> \
  -t <new_tag> \
  -p <push_flag>
```

- `-i`: 构建的镜像名称
- `-v`: 构建的镜像版本
- `-r`: 对于存在的镜像是否重新tag `true | false`
- `-t`: 对于存在的镜像，重新tag的版本
- `-p`: 是否push到仓库中

### remove docker's image

参考 [for.sh](.example/for.sh)

- `-i`: 镜像的名称
- `-s`: 删除的策略：默认策略 `contain_latest`
    - `contain_latest` 保留 `latest` 镜像，删除其他镜像
    - `remove_none` 删除 `none` 的镜像
    - `all`: 删除所有镜像

### install docker

**debian系** 安装 docker

```shell
bash <(curl -SL https://code.kubectl.net/devops/build-project/raw/branch/main/docker/install/install_apt.sh) SRC
````

- SRC: 源 (`docker` 官方源 / `tsinghua` 清华源 / `aliyun` 阿里云)

## linux

### bashrc

debian

```shell
bash <(curl -SL https://code.kubectl.net/devops/build-project/raw/branch/main/linux/system/bashrc/init_debian.sh)
```

## develop

### config maven

config maven `settings.xml`

```shell
bash <(curl -SL https://code.kubectl.net/devops/build-project/raw/branch/main/maven/config.sh)
```
