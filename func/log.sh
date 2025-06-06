GREEN='\033[0;32m'      # 绿色
ORANGE='\033[38;5;208m' # 橙色
RED='\033[0;31m'        # 红色
NC='\033[0m'            # reset

function log() {
  local remark="$1"
  local msg="$2"
  if [ -z "$remark" ]; then
    remark="info"
  fi
  if [ -z "$msg" ]; then
    msg="- - - - - - -"
  fi
  # shellcheck disable=SC2155
  local now=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "$now - [INFO ] [ $remark ] $msg"
}

function log_info() {
  local remark="$1"
  local msg="$2"
  if [ -z "$remark" ]; then
    remark="info"
  fi
  if [ -z "$msg" ]; then
    msg="- - - - - - -"
  fi
  # shellcheck disable=SC2155
  local now=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "${GREEN}$now - [INFO ] [ $remark ] $msg${NC}"
}

function log_warn() {
  local remark="$1"
  local msg="$2"
  if [ -z "$remark" ]; then
    remark="warn"
  fi
  if [ -z "$msg" ]; then
    msg="- - - - - - -"
  fi
  # shellcheck disable=SC2155
  local now=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "${ORANGE}$now - [WARN ] [ $remark ] $msg${NC}"
}

function log_error() {
  local remark="$1"
  local msg="$2"
  if [ -z "$remark" ]; then
    remark="error"
  fi
  if [ -z "$msg" ]; then
    msg="- - - - - - -"
  fi
  # shellcheck disable=SC2155
  local now=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "${RED}$now - [ERROR] [ $remark ] $msg${NC}"
}

function line_break() {
  echo -e "\n"
}
