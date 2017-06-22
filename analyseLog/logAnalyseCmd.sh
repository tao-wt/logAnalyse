#!/bin/bash
date
hwclock --show
hwclock --set --date="2017-02-14 16:43:00"
hwclock --hctosys
hwclock --show
date
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sort -k3 -k2 ./out/log_1 >./out/log_1_sort
sort -k3 -k2 ./out/log_2 >./out/log_2_sort
sort -k1 keyAndMethod_2 | awk '{print $1}' | uniq >key_2
awk -F: -v num=0 -v max=0 -v min=19999 -v sum=0 '{num++;sum+=$2;if($2>max){max=$2} if(min>$2){min=$2}} END{print "max=",max ;print "min=",min ;print"ava=",sum/num }' queue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
