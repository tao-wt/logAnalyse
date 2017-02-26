# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 # usage:
#   awk -f okloganalyse.awk inputfile
BEGIN{ 
	starttime="2017-02-13" 
	timeoutId=0 
	failId=0 
	itime=0 
	receiveId=0 
	sentId=0;queueId=0;queuesizeId=0 
	Method="" 
	Event="" 
	transtartId=0 
	tranfinishedId=0 
	realTime1="" 
	realTime2="" 
	startlines=0 
	outfile="./out/log_1" 
	outfile_2="./out/keyAndMethod" 
	outfile_3="./out/queue" 
	system("rm -rf " outfile) 
	system("rm -rf " outfile_2) 
	system("rm -rf " outfile_3) 
	if($0~/.*2017\-02\-13.*/)  startlines=NR
}
function countTime(getDate,getTime)
{ 
	datelen=split(getDate,idate,"-") 
	date=idate[datelen] 
	timel=split(getTime,itimes,":") 
	hour=itimes[1] 
	minute=itimes[2] 
	secondl=split(itimes[timel],s,".") 
	second=s[1] 
	millis=s[secondl] 
	count=date*24*60*60*1000+hour*60*60*1000+minute*60*1000+second*1000+millis 
	return count
}
{ 
	if($0~/^2017\-02\-1[3-9]\ [0-2][0-9]\:[0-5][0-9]\:/) 
	{  
		realTime1=$1;realTime2=$2; 
	} else if($0~/CinRequest\ has\ been\ received.*/) 
	{  
		Method=""  
		Event=""  
		sub(/\r/,"",$0)  
		len=split($0,A1S,"MessageKey: ")  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
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
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		itime=countTime(realTime1,realTime2)  
		printf("A1:%s[------]%s %s[------]%d[------]%s[------]%s/%s\n",++receiveId,realTime1,realTime2,itime,A1S[len],Method,Event)  
		sub(/false|true/,"",A1S[len])  
		printf("%s %s/%s\n",A1S[len],Method,Event)>>outfile_2  
		close(outfile_2)  
		printf("A1:%s %d %s\n",receiveId,itime,A1S[len])>>outfile  
		close(outfile)  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2  
		} 
	} else if($0~/TransactionCreatedEvent\ has\ been\ started.*/) 
	{  
		sub(/\r/,"",$0)  
		len=split($0,A1S," Key: ")  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		itime=countTime(realTime1,realTime2)  
		printf("B1:%s[------]%s %s[------]%d[------]%s\n",++transtartId,realTime1,realTime2,itime,A1S[len])  
		sub(/false|true/,"",A1S[len])  
		printf("B1:%s %d %s\n",transtartId,itime,A1S[len])>>outfile  
		close(outfile)  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2  
		} 
	} else if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) 
	{  
		sub(/\r/,"",$0)  
		len=split($0,A1S," Key: ")  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		itime=countTime(realTime1,realTime2)  
		printf("C1:%s[------]%s %s[------]%d[------]%s\n",++tranfinishedId,realTime1,realTime2,itime,A1S[len])  
		sub(/false|true/,"",A1S[len])  
		printf("C1:%s %d %s\n",tranfinishedId,itime,A1S[len])>>outfile  
		close(outfile)  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2  
		} 
	} else if($0~/CinResponse\ has\ been\ sent\ by.*/) 
	{  
		isPending=0  
		sub(/\r/,"",$0)  
		len=split($0,A1S,"MessageKey: ")  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/.*Pending.*/) isPending=1   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		if(isPending==0)  
		{   
			itime=countTime(realTime1,realTime2)   
			printf("D1:%s[------]%s %s[------]%d[------]%s\n",++sentId,realTime1,realTime2,itime,A1S[len])   
			sub(/false|true/,"",A1S[len])  
			 printf("D1:%s %d %s\n",sentId,itime,A1S[len])>>outfile   
			close(outfile)  
		}  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2  
		} 
	} else if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) 
	{  
		sub(/\r/,"",$0)  
		len=split($0,A1S,"MessageKey:")  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		itime=countTime(realTime1,realTime2)  
		printf("D1':%s[------]%s %s[------]%d[------]%s\n",++timeoutId,realTime1,realTime2,itime,A1S[len])  
		sub(/false|true/,"",A1S[len])  printf("D1':%s %d %s\n",timeoutId,itime,A1S[len])>>outfile  
		close(outfile)  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2;  
		} 
	} else if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) 
	{  
		sub(/\r/,"",$0)  len=split($0,A1S,"MessageKey:")  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		itime=countTime(realTime1,realTime2)  
		printf("D1'':%s[------]%s %s[------]%d[------]%s\n",++failId,realTime1,realTime2,itime,A1S[len])  
		sub(/false|true/,"",A1S[len])  
		printf("D1'':%s %d %s\n",failId,itime,A1S[len])>>outfile  
		close(outfile)  if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2;  
		} 
	} else if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) 
	{  
		print $0 >>outfile_3  
		close(outfile_3)  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2;  
		} 
	} else if($0~/CinTransactionExecutor\ queue\ size\:.*/) 
	{  
		queuesizeId++  
		for(;getline && $0!~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)  
		{   
			if($0~/CinRequest\ has\ been\ received.*/) receiveId++   
			if($0~/TransactionCreatedEvent\ has\ been\ started.*/) transtartId++   
			if($0~/TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++   
			if($0~/CinResponse\ has\ been\ sent\ by.*/) sentId++   
			if($0~/Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++   
			if($0~/Transaction\ FROM\ client\ Send\ Failed.*/) failId++   
			if($0~/CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++   
			if($0~/CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++  
		}  
		if($0~/^2017\-02\-[0-2][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)  
		{   
			realTime1=$1;realTime2=$2;  
		} 
	}
}
END{ 
	printf ("the analyse start line is:%d\n",startlines) 
	printf("(A1) the sum of CinRequest receive packets is :%d\n",receiveId) 
	printf("(B1) the sum of TransactionCreatedEvent start packets is :%d\n",transtartId) 
	printf("(C1) the sum of TransactionCreatedEvent finished packets is :%d\n",tranfinishedId) 
	printf("(D1) the sum of CinResponse sent packets is :%d\n",sentId) 
	printf("(D1') TimeoutSum packets is :%d;(D1'') FailedSum packets is :%d\n",timeoutId,failId) 
	printf("CinTransactionOrderedWorker queue sum is :%d ;CinTransactionExecutor queue sum is :%d\n",queueId,queuesizeId)
}
