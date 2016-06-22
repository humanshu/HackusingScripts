#!/bin/bash
while [ true ] ;do
freeMemmory=`free -m |awk 'NR==3 {print $4}'`

if [ $freeMemmory -lt 800 ] && [ $freeMemmory -gt 600 ]; then
echo "Free memory is below 800MB." | /bin/mail -s "Low memory alert!!" user@test.com

fi
sleep 10
done