#!/bin/sh

# Verificar si tun0 existe

if /usr/sbin/ifconfig | grep -q "tun0"; then
    interface="tun0"
    vpn_ip=$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}' | tr -d ':')
else
    interface=""
fi

if [ "$interface" = "tun0" ]; then
    echo "%{F#0DDD00} %{u-}%{F#ffffff}$vpn_ip%{u-}"
else
    echo "%{F#0DDD00} %{u-}%{F#ffffff}Disconnected"
fi
