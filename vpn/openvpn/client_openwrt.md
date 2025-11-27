
## Настройка obfs4proxy client

```shell

opkg update
opkg install obfs4proxy

mkdir -p /var/lib/obfs4proxy/

# Сертификат obfs4proxy
# cert=XXXX;
# iat-mode=0
nano /etc/openvpn/socks-proxy-auth

# Тут вся магия с динамическим портом и перезапуском клиента openwrt
nano /etc/init.d/obfs4

```



<details>
  <summary>/etc/init.d/obfs4</summary>

```shell
#!/bin/sh
### BEGIN INIT INFO
# Provides:          obfs4
# Required-Start:    $network $remote_fs $syslog
# Required-Stop:     $network $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:     0 1 6
# Short-Description: obfs4proxy service
# Description:       Service for obfs4proxy managed transport
### END INIT INFO

NAME=obfs4
DAEMON=/usr/bin/obfs4proxy
PIDFILE=/var/run/$NAME.pid
LOGFILE=/var/lib/obfs4proxy/obfs4proxy.log
STATE_DIR=/var/lib/obfs4proxy
OVPN_CONF=/etc/openvpn/client.ovpn
SOCKET_AUTH=/etc/openvpn/socks-proxy-auth

# Environment variables
export TOR_PT_MANAGED_TRANSPORT_VER=1
export TOR_PT_CLIENT_TRANSPORTS=obfs4
export TOR_PT_STATE_LOCATION=$STATE_DIR

# Create state directory if not exists
mkdir -p $STATE_DIR

update_openvpn_config() {
    local port=$1
    # Создаем в `еменн kй  dайл дл o новой кон dиг c `а fии
    local temp_conf=$(mktemp)

    #  ~б `аба b kваем  dайл кон dиг c `а fии OpenVPN
    while IFS= read -r line; do
        if [[ "$line" =~ ^socks-proxy\ 127.0.0.1 ]]; then
            echo "socks-proxy 127.0.0.1 $port $SOCKET_AUTH"
        else
            echo "$line"
        fi
    done < "$OVPN_CONF" > "$temp_conf"

    #  wамен oем о `игинал lн kй  dайл
    mv "$temp_conf" "$OVPN_CONF"

    #  =е `езап c aкаем OpenVPN
    /etc/init.d/openvpn restart client
}
case "$1" in
    start)
        echo "Starting $NAME..."
        if [ -f $PIDFILE ]; then
            echo "$NAME is already running."
            exit 1
        fi

        $DAEMON -enableLogging true -logLevelStr DEBUG > $LOGFILE 2>&1 &
        echo $! > $PIDFILE

        sleep 5
        PORT=$(grep -oE 'CMETHOD obfs4 socks5 127.0.0.1:[0-9]+' "$LOGFILE" | tail -1 | cut -d':' -f2)

        if [ -n "$PORT" ]; then
            echo "Detected obfs4 port: $PORT"
            update_openvpn_config "$PORT"
        else
            echo "Failed to detect obfs4 port"
            exit 1
        fi
        ;;
    stop)
        echo "Stopping $NAME..."
        if [ ! -f $PIDFILE ]; then
            echo "$NAME is not running."
            exit 1
        fi

        kill $(cat $PIDFILE)
        rm -f $PIDFILE
        ;;
    status)
        if [ -f $PIDFILE ]; then
            PID=$(cat $PIDFILE)
            if ps -p $PID > /dev/null; then
                echo "$NAME is running (pid $PID)"
                exit 0
            else
                echo "$NAME pid file exists but process is not running"
                exit 1
            fi
        else
            echo "$NAME is not running"
            exit 3
        fi
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    *)
        echo "Usage: /etc/init.d/$NAME {start|stop|status|restart}"
        exit 1
        ;;
esac

exit 0

```

</details>