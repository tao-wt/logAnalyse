# analyse cmp's log 
# writer SY60216 
# 分析在间隔t内sf字符串出现的次数,最后输出总次数.
# usage:
#			awk -v t="" -v sf="string" -f awkfilename.awk inputfile

BEGIN{
	print "t:",t,"; sf:",sf
	timeSep=t*60*1000
	itime=0
	sum=0;allsum=0;
	realTime1=""
	realTime2=""
	outfile="./out/timeSep"
	#outfile_2="./out/timeInfo"
	system("mkdir out")
	system("rm -rf " outfile)
	#system("rm -rf " outfile_2)
	system("rm -rf ./out/* ")
	print "analysing......"
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
/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/ {
	itime_new=countTime($1,$2)
	if(itime_new-itime>=timeSep){
		print "==========================================================================="
		print "[",realTime1," ",realTime2,"] ~ [",$1," ",$2,"] have: ",sum
		print "[",realTime1," ",realTime2,"] ~ [",$1," ",$2,"] have: ",sum >>outfile
		close(outfile)
		itime=itime_new;sum=0;
		realTime1=$1;realTime2=$2;
	}
}
index($0,sf) {
	sum++;allsum++;
}
END{
	print "==========================================================================="
	printf("the sum of string is :%d\n",allsum)
}


