#!/bin/sh -x

# /etc/init.d/set-mesh-gw-mode.sh
# This script configures batman-adv correctly on startup
# It sets up bridge loop avoidance mode and mesh gateway mode on startup

/usr/sbin/batman-adv restart

# Enable Bridge Loop Avoidance mode
/usr/sbin/batctl bl 1
sleep 5

# Get the MPGW setting from /etc/config/secn
MPGW=`uci get secn.mpgw.mode`

# Set up mesh gateway mode
if [ $MPGW = "OFF" ]; then
  /usr/sbin/batctl gw off
  uci set batman-adv.bat0.gw_mode=off
  fi

if [ $MPGW = "SERVER" ]; then
  /usr/sbin/batctl gw server
  uci set batman-adv.bat0.gw_mode=server
  fi

if [ $MPGW = "SERVER-1Mb" ]; then
  /usr/sbin/batctl gw server 1mbit
  uci set batman-adv.bat0.gw_mode='server 1mbit'
  fi

if [ $MPGW = "SERVER-2Mb" ]; then
  /usr/sbin/batctl gw server 2mbit
  uci set batman-adv.bat0.gw_mode='server 2mbit'
  fi

if [ $MPGW = "SERVER-5Mb" ]; then
  /usr/sbin/batctl gw server 5mbit
  uci set batman-adv.bat0.gw_mode='server 5mbit'
  fi

if [ $MPGW = "SERVER-10Mb" ]; then
  batctl gw server 10mbit
  uci set batman-adv.bat0.gw_mode='server 10mbit'
  fi

if [ $MPGW = "CLIENT" ]; then
  /usr/sbin/batctl gw client
  uci set batman-adv.bat0.gw_mode=client
  fi

uci commit batman-adv

# Add bat0 to bridge now that it is configured and bl is enabled
brctl addif br-lan bat0

###
