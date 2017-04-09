# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#			awk -v s="01-20 9:45:56.111" -v e="2-28 13:45:25.000" -f awkfilename.awk inputfile

BEGIN{
	print "st:",st,"en:",en
	stlen=split(st,sta," ")
	timeStart=countTime(sta[slten-1],sta[stlen])
	enlen=split(en,ena," ")
	timeEnd=countTime(ena[enlen-1],ena[enlen])
	itime=0
	receiveId=0
	realTime1=""
	realTime2=""
	outfile="./out/timeoutLog"
	outfile_2="./out/methodaevent"
	system("rm -rf " outfile)
	system("rm -rf " outfile_2)
	system("rm -rf ./out/* ")
	print "请等待..."
}
function countTime(getDate,getTime)
{
	datelen=split(getDate,idate,"-")
	mouth=idate[datelen-1]
	date=idate[datelen]
	timel=split(getTime,itimes,":")
	hour=itimes[1]
	minute=itimes[2]
	secondl=split(itimes[timel],s,".")
	second=s[1]
	millis=s[secondl]
	count=(mouth-1)*30*24*60*60*1000+date*24*60*60*1000+hour*60*60*1000+minute*60*1000+second*1000+millis
	return count
}
function iAnalyse(ivar)
{
}
{
	if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
	{
		realTime1=$1;realTime2=$2;
		itime=countTime(realTime1,realTime2)
		if(itime>timeEnd) exit
	}
	else if($0~/^CinRequest\ has\ been\ received.*/ && itime>timeStart && itime<timeEnd)
	{
		print "================================="
		print realTime1,realTime2
		Method=""
		Event=""
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^Method.*/) 
			{
				sub(/\r/,"",$0)
				lenS=split($0,A1SS," : ")
				Method=A1SS[lenS]
				
			}
			if($0~/^Event.*/) 
			{
				sub(/\r/,"",$0)
				lenS=split($0,A1SS," : ")
				lenSS=split(A1SS[lenS],A1SSS,"|")
				lenSSS=split(A1SSS[2],A1SSSS,")")
				Event=A1SSSS[2]
				
			}
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
		}
		printf("%s %s/%s\n",++receiveId,Method,Event)>>outfile
		close(outfile)
		printf("%s %s/%s\n",receiveId,Method,Event)
		MAE=Method "/" Event
		if(MAE in array)
		{
			array[MAE]+=1
		}
		else
		{
			array[MAE]=1
		}
		for(name in array)
			print name,array[name] >outfile_2
		close(outfile_2)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
			itime=countTime(realTime1,realTime2)
			if(itime>timeEnd) exit
		}
	}
}
END{
	print "================================="
	printf("the sum of Transaction FROM client send Timeout packets is :%d\n",receiveId)
	for(name in array)
		print name,array[name]
}


