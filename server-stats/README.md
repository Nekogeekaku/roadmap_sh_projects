# Server stats project

Coming from [roadmap.sh devops projects](https://roadmap.sh/projects/server-stats) you will find here a script than answer the different demands made.


In order to test it I used a docker image.
You can try it by doing:
```bash
docker  run  -v ./:/tmp -w /tmp -i -t  ubuntu /bin/bash server-stats.sh
```
I tried to use different methods as an exercice and I am in the procees of building a tutorial for french people that will be available [here](https://github.com/Nekogeekaku/la_pratique_du_devops) when completely published.

Any way here is a quick walkthrough for it:
```bash
while true; do
    IDLE=$(top -n 1 |  awk '/Cpu/{print $8}')
    [[ "$IDLE" = *id* ]] || break
done
echo Used cpu : $(echo 100 ${IDLE} | awk '{print $1 - $2}') %
```
This part just use the `top` command. As it possible on the docker to have a 100% idle time that create a stange behaviour I added a test.
the strange beahvior is that the space is disapearing and gives `ni,100.0 id,` 


```bash
MEMORY_USED_READABLE=$(free -h -t | awk '/Total:/{print $3}')
MEMORY_FREE_READABLE=$(free -h -t | awk '/Total:/{print $4}')
TOTAL_MEMORY=$(free -t | awk '/Total:/{print $2}')
MEMORY_USED=$(free -t | awk '/Total:/{print $3}')
MEMORY_FREE=$(free -t | awk '/Total:/{print $4}')
echo "Memory Used : " $MEMORY_USED_READABLE $MEMORY_USED "("$(echo $MEMORY_USED $TOTAL_MEMORY | awk '{printf "%.2f",($1 / $2)*100}')"%)"
echo "Memory free : " $MEMORY_FREE_READABLE $MEMORY_FREE "("$(echo $MEMORY_FREE $TOTAL_MEMORY | awk '{printf "%.2f",($1 / $2)*100}')"%)"
```

In the current case I used the basic `free` command and some tweak with `awk` to do my calculation in floating point as bash does not cover floating calculation.
`printf` hel solve the 2 decimal digits.

```bash

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
```

Here I did a function to avoid repetition. I mostly used the same principle as previously to do the calculation and print the output.

```bash
ps -eo pid,tty,time,cmd,%mem,%cpu --sort=-%cpu | head -6
ps -eo pid,tty,time,cmd,%mem,%cpu --sort=-%mem | head -6
```

You can get the processes by using the top command but here again I used and another classic command called `ps`

Nothing to notice here appart the `head -6` which will give you th top 5 processes as the header line count as one.

For the extra I simply added an uptime command an different ways to get the OS type with the original source I go the command from.

Enjoy.