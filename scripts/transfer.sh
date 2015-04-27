#!/usr/bin/env bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

echo `date`

files=(  asia.zone.gz
         biz.zone.gz
         mobi.zone.gz
         name.zone.gz
         net.zone.gz
         org.zone.gz
         pro.zone.gz
         us.zone.gz
         com.zone.gz
)

for i in "${files[@]}"
do
   echo $i
   scp -i /home/contact16/23182_private_rsa.pem contact16@cheetah.sd.c66.me:~/$i /home/contact16/zones/
done


