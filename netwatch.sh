#!/bin/bash

# Get the gateway IP from the default route
GW=$(ip route | awk '/default/ {print $3; exit}')

# Loop forever
while true; do
	if ! ping -c 2 -W 2 "$GW" > /dev/null; then
		echo "$(date) - gateway down, restarting networking"
		systemctl restart networking
		sleep 30
	else
		echo "$(date) - gatweay ping OK"
	fi
	sleep 30
done	
