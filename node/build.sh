#!/bin/bash
# shellcheck disable=SC1090 disable=SC2086 disable=SC2028
[ -z $ROOT_URI ] && source <(curl -sSL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh) && export ROOT_URI=$ROOT_URI

source <(curl -sSL $ROOT_URI/func/log.sh)
source <(curl -sSL $ROOT_URI/func/ostype.sh)
source <(curl -sSL $ROOT_URI/func/command_exists.sh)

log "node build" ">>> start <<<"
function end() {
  log "node build" ">>> end <<<"
}

image=""
build=""
build_dir=""

function tips() {
  log_info "tips" "-d node's build directory"
  log_info "tips" "-i node's docker image"
  log_info "tips" "-x node's build command"
}

while getopts ":i:x:d:" opt; do
  case ${opt} in
  d)
    log_info "get opts" "process's build_dir; build_dir is: $OPTARG"
    build_dir=$OPTARG
    ;;
  i)
    log_info "get opts" "process's image; docker's image is: $OPTARG"
    image=$OPTARG
    ;;
  x)
    log_info "get opts" "process's command; node's command is: $OPTARG"
    build=$OPTARG
    ;;
  \?)
    log_info "get opts" "Invalid option: -$OPTARG"
    tips
    end
    exit 1
    ;;
  :)
    log_info "get opts" "Invalid option: -$OPTARG requires an argument"
    tips
    end
    exit 1
    ;;
  esac
done

function validate_param() {
  local key=$1
  local value=$2
  if [ -z "$value" ]; then
    log_error "validate_param" "parameter $key is empty, then exit"
    tips
    end
    exit 1
  else
    log_info "validate_param" "parameter $key : $value"
  fi
}

validate_param "image" "$image"
validate_param "build" "$build"

if [ -z "$build_dir" ]; then
  log_info "build_dir" "build_dir is empty then use current directory"
  build_dir="$(pwd)"
elif [ ! -d "$build_dir" ]; then
  log_error "build_dir" "build_dir is not a valid paths"
  exit 1
fi

if command_exists docker; then
  log_info "command_exists" "docker command exists"
else
  log_error "command_exists" "docker command does not exist"
  end
  exit 1
fi

log_info "build" "========== build node's project in docker =========="

if is_windows; then
  log_info "build" "build in windows"
  log_info "build" "docker run --rm -u root -v $build_dir:/opt/app/node  -w /opt/app/node $image $build"
  export MSYS_NO_PATHCONV=1
  docker run --rm -u root \
    -v "$build_dir":/opt/app/node \
    -w /opt/app/node \
    "$image" \
    $build
else
  log_info "build" "build in linux"
  log_info "build" "docker run --rm -u root --network=host -v $build_dir:/opt/app/node  -w /opt/app/node $image $build"
  docker run --rm -u root \
    --network=host \
    -v "$build_dir":/opt/app/node \
    -w /opt/app/node \
    "$image" \
    $build
fi

end
