#!/bin/bash

echo "----------------------------------------------"
echo "Total CPU usage"
while true; do
    IDLE=$(top -n 1 |  awk '/Cpu/{print $8}')
    [[ "$IDLE" = *id* ]] || break
done
echo Used cpu : $(echo 100 ${IDLE} | awk '{print $1 - $2}') %


# Total memory usage (Free vs Used including percentage)

echo "----------------------------------------------"
echo "Total memory usage (Free vs Used including percentage)"

MEMORY_USED_READABLE=$(free -h -t | awk '/Total:/{print $3}')
MEMORY_FREE_READABLE=$(free -h -t | awk '/Total:/{print $4}')
TOTAL_MEMORY=$(free -t | awk '/Total:/{print $2}')
MEMORY_USED=$(free -t | awk '/Total:/{print $3}')
MEMORY_FREE=$(free -t | awk '/Total:/{print $4}')
echo "Memory Used : " $MEMORY_USED_READABLE $MEMORY_USED "("$(echo $MEMORY_USED $TOTAL_MEMORY | awk '{printf "%.2f",($1 / $2)*100}')"%)"
echo "Memory free : " $MEMORY_FREE_READABLE $MEMORY_FREE "("$(echo $MEMORY_FREE $TOTAL_MEMORY | awk '{printf "%.2f",($1 / $2)*100}')"%)"


# # Total disk usage (Free vs Used including percentage)
echo "----------------------------------------------"
echo "Total disk usage (Free vs Used including percentage)"

function DF_on_mount {
        local MOUNT=$1
        local DISK_USED_READABLE=$(df -h --total $MOUNT| awk '/total/{print $3}')
        local DISK_FREE_READABLE=$(df -h --total $MOUNT| awk '/total/{print $4}')
        local TOTAL_DISK_READABLE=$(df -h --total $MOUNT| awk '/total/{print $2}')
        local TOTAL_DISK=$(df --total $MOUNT| awk '/total/{print $2}')
        local DISK_USED=$(df --total $MOUNT| awk '/total/{print $3}')
        local DISK_FREE=$(df --total $MOUNT| awk '/total/{print $4}')
        [ -z "$MOUNT" ] && MOUNT="Global"
        echo "------" $MOUNT "-------"
        echo "Total Disk : " $TOTAL_DISK_READABLE
        echo "Disk Used : " $DISK_USED_READABLE "("$(echo $DISK_USED $TOTAL_DISK | awk '{printf "%.2f", ($1 / $2)*100}')%")"
        echo "Disk free : " $DISK_FREE_READABLE "("$(echo $DISK_FREE $TOTAL_DISK | awk '{printf "%.2f", ($1 / $2)*100}')%")"
    
}

DF_on_mount

DISK_TO_PARSE=(/ /tmp)

for i in "${DISK_TO_PARSE[@]}"
do 
    echo "$i"
    df -h --total $i
    DF_on_mount $i
done

# Top 5 processes by CPU usage
echo "----------------------------------------------"
echo "Top 5 processes by CPU usage"

ps -eo pid,tty,time,cmd,%mem,%cpu --sort=-%cpu | head -6

# Top 5 processes by memory usage
echo "----------------------------------------------"
echo "Top 5 processes by memory usage"

ps -eo pid,tty,time,cmd,%mem,%cpu --sort=-%mem | head -6


# Stretch goal: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.

# uptime

echo "----------------------------------------------"
echo "Up time"
echo "----------------------------------------------"
uptime

#OS Type
echo "----------------------------------------------"
echo "OS Type with different command"
echo "----------------------------------------------"

uname
uname -s

# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # ...
        echo "Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "Mac OSX"
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "windows cygwin"
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "MibGW"
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
        echo "not possible"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
        echo "freebsd"
else
        # Unknown.
        echo "unknown"
fi
