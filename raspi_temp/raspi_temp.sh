#!/bin/sh

raw=`cat /sys/class/thermal/thermal_zone0/temp`
temp=`echo "scale=3; $raw / 1000" | bc`

printf $temp
