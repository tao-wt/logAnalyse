#!/bin/bash
# writer SY60216
# 脚本功能:nohup.out日志文件的备份,3参数：日志文件 保留多少次的备份 日志文件保留的行数
# 		bash clearLog.sh /fullpath/filename bakTimes bakLines

IFS=$' \t\n'
OLDPATH="$PATH"
PATH=/bin:/usr/bin:/sbin/
export PATH

pathfile=$1
bakTimes=$2
bakLines=$3

logBackDelte(){
	local countfiles=0
	local countlines=0
	if [ ! -d "${pathfile%nohup.out}logBackup" ];then
		mkdir ${pathfile%nohup.out}logBackup
	fi
	countlines=$(wc -l $pathfile | awk '{print $1}')
	if [ $countlines -gt $bakLines ];then
		cp $pathfile ${pathfile%nohup.out}logBackup/nohup_$(date +%Y%m%d%H%M).out && {
			sed -i "1,$((countlines-bakLines))d" $pathfile
		}
	fi
	pushd  ${pathfile%nohup.out}logBackup
		countfiles=$(ls -t1 | wc -l )
		if [ $countfiles -gt $bakTimes ];then
			ls -t1 | tail -$((countfiles-bakTimes)) | xargs -n1 -i rm -f {}
		fi
	popd
}

dTime=$(date +%Y%m%d%H%M)
echo $dTime start...
logBackDelte
echo $dTime finish...

