#!/bin/env bash
# writer SY20216
# 脚本功能：获取系统参数信息，配合nohup可放于后台执行; 须3个参数(argv1:端口,argv2:输出的文件,argv3:pid)
# usage： 
#			bash getInfo.sh port "path/fileName" pid

IFS=$' \t\n'
func=$1
outfile=$2
ipid=$3
if [ -f "$outfile" ]
then
	rm -f $outfile
fi

while true
do
	top -b -d 0 -n 1 -p $ipid >>$outfile
	top -b -d 0 -n 1 -p $ipid
	num=$(netstat -anp | grep $func | grep ES	LISHED | grep java | wc -l) 
	echo ES	LISHED of $1 is: $num
	echo ES	LISHED of $1 is: $num  >>$outfile
	echo ------------------------------------------------------------------------------------------------- >>$outfile
	echo -------------------------------------------------------------------------------------------------
	sleep 2s
done
