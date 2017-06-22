# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#	awk -f loganalyse.awk inputfile
BEGIN{
	starttime="2017-02-13"
	creatSum=0 
	removeSum=0 
	realTime1="" 
	realTime2="" 
	establishdCmd="netstat -aplno | awk '$0~/9086/ && $0~/ESTABLISHED/' | wc -l" 
	closewaitCmd="netstat -aplno | awk '$0~/9086/ && $0~/CLOSE_WAIT/' | wc -l" 
	if ($0~/.*2017\-02\-13.*/)  
		startlines=NR
}
{ 
	if (NR>=startlines)
	{
		if($0~/^2017\-02\-1[3-9]\ [0-2][0-9]\:[0-5][0-9]\:/)   
		{
			realTime1=$1;realTime2=$2;next
		}  
		if ($0~/.*New\ UserProxy\ has\ been\ created.*/)  
		{
			creatSum+=1  
			printf("%s-->time:%s %s line:%d %s\n",creatSum,realTime1,realTime2,NR,$0)
		}  
		else if($0~/.*UserProxy\ has\ been\ removed.*/)  
		{   
			removeSum+=1   
			printf("%d-->time:%s %s line:%d %s\n",removeSum,realTime1,realTime2,NR,$0)  
		} 
	}
}
END{ 
	establishdCmd | getline establishdSum 
	close(establishdCmd) 
	closewaitCmd | getline closewaitSum 
	close(closewaitCmd) 
	printf ("the analyse start line is:%d\n",startlines) 
	printf("the sum of connect creat is :%d\n",creatSum) 
	printf("the sum of connect remove is :%d\n",removeSum) 
	printf("establishdSum is :%d ;closewaitSum is :%d\n",establishdSum,closewaitSum)
}
