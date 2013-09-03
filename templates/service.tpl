#!/bin/sh

#
# (>>>FILE<<<)     
#
# chkconfig: 2345 90 05
# description: (>>>POINT<<<)
# probe: true

# Source function library.
. /etc/init.d/functions

# 本服务的配置文件
if [ ! -f /etc/sysconfig/(>>>FILE<<<) ]; then
    exit 0
fi

. /etc/sysconfig/(>>>FILE<<<) 

#判断配置参数的正确性
#[ "${NETWORKING}" = "no" ] && exit 0

debug ()
{
    [ "$DEBUG" = "yes" ] && echo "$*"
}

start ()
{
	echo -n  "start (>>>FILE<<<)"
	echo
}

stop ()
{
	echo -n "stop (>>>FILE<<<)"
	echo
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
		;;
	status)
		;;
    restart)
        stop
        start
		;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit 0
