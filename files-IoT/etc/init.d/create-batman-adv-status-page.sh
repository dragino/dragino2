#!/bin/ash 

# Check wireless type
RADIO=`uci get wireless.radio0.type`
if [ $RADIO = "atheros" ]; then 
  WIRELESS="ath"  # atheros
else
	WIRELESS="wlan" # mac80211
fi

# Set up symbolic links to txt files from /www
touch /tmp/mesh.txt
ln -s /tmp/mesh.txt /www/mesh.txt
touch /tmp/wifi.txt
ln -s /tmp/wifi.txt /www/wifi.txt
touch /tmp/bat1.txt
ln -s /tmp/bat1.txt /www/bat1.txt
touch /tmp/bat2.txt
ln -s /tmp/bat2.txt /www/bat2.txt

# Generate the txt files every 10 seconds
# Get batman-adv info
while (true); do \
batctl o > /tmp/bat1 &&\
batctl gwl > /tmp/bat2 &&\
mv  /tmp/bat1  /tmp/bat1.txt
mv /tmp/bat2   /tmp/bat2.txt

# Get adhoc associations
echo "Station MAC Addr     Signal    2.4GHz" > /tmp/mesh.txt
iwinfo $WIRELESS'0-1' assoclist >> /tmp/mesh.txt
# Get AP associations
echo "Station MAC Addr     Signal    2.4Ghz" > /tmp/wifi.txt
iwinfo $WIRELESS'0' assoclist >> /tmp/wifi.txt

sleep 10; \
done &

