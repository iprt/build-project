#!/bin/bash
# shellcheck disable=SC1090 disable=SC2086 disable=SC2155 disable=SC2128 disable=SC2028  disable=SC2317 disable=SC2164 disable=SC2004 disable=SC2154
[ -z $ROOT_URI ] && source <(curl -sSL https://gitlab.com/iprt/shell-basic/-/raw/main/build-project/basic.sh)
echo -e "\033[0;32mROOT_URI=$ROOT_URI\033[0m"
# ROOT_URI=https://dev.kubectl.net

source <(curl -SL $ROOT_URI/func/log.sh)
source <(curl -SL $ROOT_URI/devops/teamcity/install_func.sh)

log_info "teamcity" "install multiple agents in one server"

if ! prepare; then
  log_error "teamcity" "prepare failed"
  exit 1
fi

if ! download_teamcity_agent; then
  log_error "teamcity" "download teamcity agent failed"
  exit 1
fi

function install_multi_teamcity_agent() {
  log_info "teamcity" "install multi teamcity agent"
  if [ -f "$teamcity_agent_path/buildAgentFull.zip" ]; then
    log_info "teamcity" "download teamcity agent success"
  else
    log_error "teamcity" "download teamcity agent failed"
    exit 1
  fi

  function read_num() {
    read -p "Enter the number of teamcity agents to install: " agent_num
    if [ -z $agent_num ]; then
      log_error "teamcity" "agent number is empty"
      read_num
    fi

    # check number
    if ! echo $agent_num | grep -q "^[0-9]\+$"; then
      log_error "teamcity" "agent number is not a number"
      read_num
    fi

    # >=1 , <=16
    if [ $agent_num -le 1 ] || [ $agent_num -ge 16 ]; then
      log_error "teamcity" "agent number is less than 1 or greater than 10"
      read_num
    fi
    log_info "teamcity" "agent number is $agent_num"

  }

  read_num

  function unzip_and_edit_properties() {
    # read name
    read -p "Enter the teamcity agent name: " agent_name
    if [ -z $agent_name ]; then
      log_warn "teamcity" "teamcity agent name is empty"
      agent_name=$(hostname)
    fi

    for ((i = 1; i <= $agent_num; i++)); do
      log_info "teamcity" "install teamcity agent $i"
      unzip $teamcity_agent_path/buildAgentFull.zip -d $teamcity_agent_path/agent$i

      log_info "teamcity" "edit $teamcity_agent_path/agent$i/conf/buildAgent.properties"

      cat >$teamcity_agent_path/agent$i/conf/buildAgent.properties <<EOF
## TeamCity build agent configuration file

######################################
#   Required Agent Properties        #
######################################

## The address of the TeamCity server. The same as is used to open TeamCity web interface in the browser.
## Example:  serverUrl=https://buildserver.mydomain.com:8111
serverUrl=$teamcity_server

## The unique name of the agent used to identify this agent on the TeamCity server
## Use blank name to let server generate it.
## By default, this name would be created from the build agent's host name
name=$agent_name-$i

## Container directory to create default checkout directories for the build configurations.
## TeamCity agent assumes ownership of the directory and will delete unknown directories inside.
workDir=../work

## Container directory for the temporary directories.
## TeamCity agent assumes ownership of the directory. The directory may be cleaned between the builds.
tempDir=../temp

## Container directory for agent state files and caches.
## TeamCity agent assumes ownership of the directory and can delete content inside.
systemDir=../system


######################################
#   Optional Agent Properties        #
######################################

## A token which is used to identify this agent on the TeamCity server for agent authorization purposes.
## It is automatically generated and saved back on the first agent connection to the server.
authorizationToken=


######################################
#   Default Build Properties         #
######################################
## All properties starting with "system.name" will be passed to the build script as "name"
## All properties starting with "env.name" will be set as environment variable "name" for the build process
## Note that value should be properly escaped. (use "\\" to represent single backslash ("\"))
## More on file structure: http://java.sun.com/j2se/1.5.0/docs/api/java/util/Properties.html#load(java.io.InputStream)

# Build Script Properties

#system.exampleProperty=example Value

# Environment Variables
EOF
    done
  }

  function create_teamcity_agents_systemd() {
    log_info "teamcity" "create /usr/lib/systemd/system/teamcity-agent@.service"
    cat >/usr/lib/systemd/system/teamcity-agent@.service <<EOF
[Unit]
Description=TeamCity Agent %I
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
Environment=JAVA_HOME=$JAVA_HOME
ExecStart=$teamcity_agent_path/agent%i/bin/agent.sh start
Type=forking
RemainAfterExit=yes
User=root
Group=root
SyslogIdentifier=teamcity_agent
PrivateTmp=yes
PIDFile=$teamcity_agent_path/agent%i/logs/buildAgent.pid
ExecStop=$teamcity_agent_path/agent%i/bin/agent.sh stop
RestartSec=5
Restart=on-failure
EOF
  }

  unzip_and_edit_properties
  create_teamcity_agents_systemd
}

install_multi_teamcity_agent
