# shellcheck disable=SC2155
function log() {
  local remark="$1"
  local msg="$2"
  if [ -z "$remark" ]; then
    remark="unknown remark"
  fi
  if [ -z "$msg" ]; then
    msg="unknown message"
  fi
  local now=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "$now - [ $remark ] $msg"
}