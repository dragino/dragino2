#!/bin/sh

# This script is called from SECN Basic config screen to get SIP registration status

env LD_LIBRARY_PATH="/lib:/usr/lib:/user/lib:/user/usr/lib:/user/usr/lib/asterisk:/user/usr/lib/asterisk/modules" \
 PATH="/bin:/sbin:/usr/bin:/usr/sbin:/user/bin:/user/sbin:/user/usr/bin:/user/usr/sbin" \
 /user/usr/sbin/asterisk -rnx "sip show registry" | grep "Registered"  > /tmp/reg-status.txt

