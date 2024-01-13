#!/bin/sh

conection=$(/usr/sbin/ifconfig eth0 | grep "inet " | awk '{print $2}')

if [ "conection" = "eth0" ]; then
        echo "%{F#ffffff}  %{F#ffffff}$(/usr/sbin/ifconfig eth0 | grep "inet " | awk '{print $2}')%{u-}"
else
        echo "%{F#ffffff}  Sin internet"
fi
