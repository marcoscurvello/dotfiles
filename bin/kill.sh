#!/bin/zsh
############
### zsh script to kill sophos scan process
###
############

kill_sophos_net_extension() {
#   sudo kill -9 `ps -ef | awk '$2 == PROCINFO["pid"] {next} /com.sophos.endpoint.networkextension/ {print $2}' | head -n1` 
    sudo kill -9 `ps -ef | awk '$2 == PROCINFO["pid"] {next} /com.sophos.endpoint.scanextension.systemextension/ {print $2}' |  head -n1` 
}

while true; do
    echo "Attempting to kill Sophos scanextension..."
    kill_sophos_net_extension
    echo "✓ Killing PID: `ps -ef | awk '$2 == PROCINFO["pid"] {next} /com.sophos.endpoint.scanextension.systemextension/ {print $2}' |  head -n1`"
    sleep 5
done
