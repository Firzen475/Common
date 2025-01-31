## openvpn
```shell

# Установка https://openwrt.org/ru/doc/howto/vpn.openvpn
# Лучше всего делать init в /etc/openvpn/

#создание ключа tls-crypt-v2

openvpn --genkey tls-crypt-v2-server > /etc/openvpn/pki/ta.key

openvpn --tls-crypt-v2 /etc/openvpn/pki/ta.key  --genkey tls-crypt-v2-client > /etc/openvpn/pki/private/ta_note.key




# Клиентские сертификаты
cd /etc/openvpn/
easyrsa build-client-full note nopass




```

```
client
dev tun
proto udp
remote [ip] 1194

<ca>
    cat /etc/openvpn/pki/ca.crt 
</ca>
<cert>
    cat /etc/openvpn/pki/issued/note.crt
</cert>
<key>
    cat /etc/openvpn/pki/private/note.key
</key>
<tls-crypt-v2>
    cat /etc/openvpn/pki/private/ta_note.key
</tls-crypt-v2>

```