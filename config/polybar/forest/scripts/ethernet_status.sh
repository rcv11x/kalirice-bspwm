#!/bin/sh

conn=$(/usr/sbin/ifconfig eth0 | grep "inet " | awk '{print $2}')

if [ -n "$conn" ]; then
        echo "%{F#009EFF}󰈀 %{u-}%{F#FFFFFF}$conn%{u-}"
else
	echo "%{F#FF0000}󰈀%{u-}%{F#ffffff} Sin internet"
fi
