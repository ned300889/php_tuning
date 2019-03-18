#!/bin/bash

:'

PHP:
maxclients = (Total RAM - Memory used for Linux, DB, etc.) / process size
maxclients = (8192MB - 4096MB) / 55MB = 74

; pre-spawn processes
pm = dynamic
pm.max_children         ( (8192 - 4096 for apache) / process size)
pm.start_servers        (cpu cores * 4)
pm.min_spare_servers    (cpu cores * 2)
pm.max_spare_servers    (cpu cores * 4)
;pm.max_requests         1000
pm.process_idle_timeout = 10s;

; processes spawned on demand
pm = ondemand
pm.max_children = 5
pm.process_idle_timeout = 10s;
pm.max_requests = 500

'

RAM="$(grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc)"
PHPPID="$(ps aux | grep "php-fpm: master process" | awk 'FNR == 2 {print $2}')"
PROCESSSIZETOTALPHP="$(pmap -x "${PHPID}" | awk 'END {print $3}' | xargs -I {} echo "scale-4; {}/1024^2" | bc)"
APACHEID="$(ps aux| awk '/apach[e]/{total+=$4}END{print total}')"
MAXCLIENTS="$(eval expr ${RAM} / ${PROCESSSIZETOTALPHP})"
MAXCLIENTS2="$(( $RAM * 0.057))"
PM="dynamic"
MAXCHILDREN=expr $RAM * $APACHEID
CPU="$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')"
MINSPARE="$(expr $CPU * 4)"
MAXSPARE="$(expr $CPU * 2)"



echo "######## For pre-spawn processes ##########"
echo "### maxclients              = $MAXCLIENTS"
echo "### pm                      = $PM"
echo "### pm.maxchildren          = $MAXCHILDREN"
echo "### pm.start_servers        = $MINSPARE"
echo "### pm.min_spare_servers    = $MAXSPARE"
echo "### pm.max_spare_servers    = $MINSPARE"
echo "####### For processes spawned on demand##### "
echo "### pm.process_idle_timeout = 10s"
echo "### pm                      = ondemand"
echo "### pm.max_children         = 5"
echo "### pm.process_idle_timeout = 10s;"
echo "### pm.max_requests         = 500"







