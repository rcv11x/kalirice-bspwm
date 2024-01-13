#!/bin/sh

ip_target=$(cat ~/.config/polybar/shapes/scripts/target | awk '{print $1}')
name_target=$(cat ~/.config/polybar/shapes/scripts/target | awk '{print $2}')

	if [ $ip_target ] && [ $name_target ]; then
		echo "%{F#FF0000}󰓾%{F#ffffff} $ip_target - $name_target"
	elif [ $(cat ~/.config/polybar/shapes/scripts/target | wc -w) -eq 1 ]; then
		echo "%{F#FF0000}󰓾%{F#ffffff} $ip_target"
	else
		echo "%{F#FF0000}󰓾%{u-}%{F#ffffff} No target"
	fi
