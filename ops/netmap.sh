#!/bin/bash
host="172.16.1."
for i in `seq 1 254`
do
if ping -w 2 -c 1 172.16.1.$i | grep "100%" > /dev/null;then
echo "$host$i is not reachable"
else
echo "$host$i is reachable"
fi
done
# Windows bat
# for /L %i in (1,1,254) do ping -n 1 -w 60 192.168.0.%i | find  "回复" >> resultip.txt