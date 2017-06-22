#!/bin/bash
# writer SY60216
# 脚本功能:设置日志清理策略，须加一个配置文件参数
# 		bash setConf.sh /path/configLog

IFS=$' \t\n'
OLDPATH="$PATH"
PATH=/bin:/usr/bin:/sbin/
export PATH
# echo $1
configLog=$1

readconfig(){
	local startLine=""
	local endLine="";local result=""
	startLine=$1
	endLine=$2
	result=$(sed -n "$startLine,${endLine}p" $configLog | grep $3 | awk -F= '{print $2}')
	if [ ! $result ];then
		if [ $3 = "minute" -o $3 = "hours" -o $3 = "day" -o $3 = "month" -o $3 = "week" ]
		then
			result="*"
		fi
	fi
}

getConfig(){
	local filename="";local minute="";local hours="";local day="";local month="";local week="";local backuptimes="";local clearcmd=""
	local startLine="";local endLine="";local backupLines=""
	filename=$1
	if grep "^\[$2\]" $configLog >/dev/null
	then
		startLine=$(nl -b a $configLog | grep "\[$2\]" | awk '{print $1}')
		endLine=$(nl -b a $configLog | grep "${2}end" | awk '{print $1}')
	elif grep "^\[$3\]" $configLog >/dev/null
	then
		startLine=$(nl -b a $configLog | grep "\[$3\]" | awk '{print $1}')
		endLine=$(nl -b a $configLog | grep "${3}end" | awk '{print $1}')
	else
		echo configLog file:$filename have error,please check!
		return 1
	fi
	minute=$(sed -n "$startLine,${endLine}p" $configLog | grep minute | awk -F= '{print $2}')
	hours=$(sed -n "$startLine,${endLine}p" $configLog | grep hours | awk -F= '{print $2}')
	day=$(sed -n "$startLine,${endLine}p" $configLog | grep day | awk -F= '{print $2}')
	month=$(sed -n "$startLine,${endLine}p" $configLog | grep month | awk -F= '{print $2}')
	week=$(sed -n "$startLine,${endLine}p" $configLog | grep week | awk -F= '{print $2}')
	backupTimes=$(sed -n "$startLine,${endLine}p" $configLog | grep backupTimes | awk -F= '{print $2}')
	backupLines=$(sed -n "$startLine,${endLine}p" $configLog | grep backupLines | awk -F= '{print $2}')
	# setconfig $filename "$minute" "$hours" "$day" "$month" "$week" "$backupTimes" "$backupLines"
	(crontab -l;echo "$minute" "$hours" "$day" "$month" "$week" /bin/bash clearLog.sh $filename "$backupTimes" "$backupLines")
}

setconfig(){
	filename=$1;minute=$2;hours=$3;day=$4;month=$5;week=$6;backupTimes=$7;
	if test $# -eq 8
	then
		clearcmd=$8
		echo "$minute" "$hours" "$day" "$month" "$week" clearLog_run.sh $filename "$backupTimes" "$backupLines"
	else
		echo "$minute" "$hours" "$day" "$month" "$week" clearLog_run.sh $filename "$backupTimes"
	fi
}

for i in $(find /opt/innerapp -mindepth 2 -maxdepth 2 -name nohup.out)
do
	modnode=$(echo $i | awk -F/ '{print $4}')
	modname=$(echo $modnode | awk -F_ '{print $1}')
	# echo $i
	getConfig "$i" $modnode $modname
	# if getConfig "$i" $modnode $modname
	# then
		# echo $i $modnode $modname have some error.
	# fi
done

