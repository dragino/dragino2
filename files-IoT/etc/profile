#!/bin/sh
[ -f /etc/banner ] && cat /etc/banner

export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH=$PATH:/user/bin:/user/sbin:/user/usr/bin:/user/usr/sbin
export LD_LIBRARY_PATH=/lib:/usr/lib:/user/lib:/user/usr/lib:/user/usr/lib/asterisk:/user/usr/lib/asterisk/modules
export HOME=$(grep -e "^${USER:-root}:" /etc/passwd | cut -d ":" -f 6)
export HOME=${HOME:-/root}
export PS1='\u@\h:\w\$ '

[ -x /bin/more ] || alias more=less
[ -x /usr/bin/vim ] && alias vi=vim || alias vim=vi

[ -z "$KSH_VERSION" -o \! -s /etc/mkshrc ] || . /etc/mkshrc

[ -x /usr/bin/arp ] || arp() { cat /proc/net/arp; }
[ -z /bin/ldd ] || ldd() { LD_TRACE_LOADED_OBJECTS=1 $*; }
