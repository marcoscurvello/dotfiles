#!/bin/zsh
############
### zsh script to stop sophos daemon
###
############

stop_sophos_daemon() {
    sudo kill -9 `ps -ef | awk '$2 == PROCINFO["pid"] {next} /com.sophos.endpoint.scanextension.systemextension/ {print $2}' |  head -n1` 
    sudo launchctl stop /Library/LaunchDaemons/com.avatron.airconnect.daemon.plist
    sudo launchctl unload -w /Library/LaunchDaemons/com.avatron.airconnect.daemon.plist
}


echo "Attempting stop Sophos daemon..."
stop_sophos_daemon
# echo "✓ Killing PID: `ps -ef | awk '$2 == PROCINFO["pid"] {next} /com.sophos.endpoint.scanextension.systemextension/ {print $2}' |  head -n1`"
# sleep 5

# while true; do
#     echo "Attempting stop Sophos daemon..."
#     stop_sophos_daemon
#     # echo "✓ Killing PID: `ps -ef | awk '$2 == PROCINFO["pid"] {next} /com.sophos.endpoint.scanextension.systemextension/ {print $2}' |  head -n1`"
#     # sleep 5
# done
