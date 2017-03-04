# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#			awk -f okloganalyse.awk inputfile

BEGIN{
	timeoutId=0
	failId=0
	itime=0
	receiveId=0
	sentId=0;queueId=0;queuesizeId=0
	Method=""
	Event=""
	transtartId=0;SendFailId=0;TTimeoutId=0
	tranfinishedId=0
	realTime1=""
	realTime2=""
	outfile="./out/log_1"
	outfile_2="./out/keyAndMethod_1"
	outfile_3="./out/queue"
	system("rm -rf " outfile)
	system("rm -rf " outfile_2)
	system("rm -rf " outfile_3)
	CinResponsereceivedId=0
	RespstartId=0
	RespsendId=0
	notCinMes=0;sendhError=0
	sendCMto=0
	RespfinishId=0
	RecievedoutrespId=0
	outfile_4="./out/log_2"
	outfile_5="./out/keyAndMethod_2"
	system("rm -rf " outfile_4)
	system("rm -rf " outfile_5)
	outfile_6="./out/allout"
	system("rm -rf " outfile_6)
	system("rm -rf ./out/* ")
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
function iAnalyse(ivar)
{
	
}
{
	if($0~/^2017\-02\-1[3-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
	{
		realTime1=$1;realTime2=$2;
	}
	else if($0~/^CinRequest\ has\ been\ received.*/)
	{
		Method=""
		Event=""
		ChainId=""
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey: ")
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
			if($0~/^ChainId.*/) 
			{
				sub(/\r/,"",$0)
				lenId=split($0,A1C,")")
				ChainId=A1C[lenId]
				
			}
			if($0~/^CinRequest\ has\ been\ received.*/)receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("A1:%s[------]%s %s[------]%d[------]%s[------]%s/%s[------]%s\n",++receiveId,realTime1,realTime2,itime,A1S[len],Method,Event,ChainId)
		sub(/false|true/,"",A1S[len])
		printf("%s %s_%s %s\n",A1S[len],Method,Event,ChainId)>>outfile_2
		close(outfile_2)
		printf("A1:%s %d %s %s_%s\n",receiveId,itime,A1S[len],Method,Event)>>outfile
		close(outfile)
		MAE=Method "_" Event
		if((MAE=="Message_01" || MAE=="Logon_02") && ChainId!="")
		{
			#if(!(ChainId in iarray))
			#{
				iarray[ChainId]=MAE
			#}
		}
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2
		}
	}
	else if($0~/^TransactionCreatedEvent\ has\ been\ started.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S," Key: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("B1:%s[------]%s %s[------]%d[------]%s\n",++transtartId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		printf("B1:%s %d %s\n",transtartId,itime,A1S[len])>>outfile
		close(outfile)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2
		}
	}
	else if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S," Key: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("C1:%s[------]%s %s[------]%d[------]%s\n",++tranfinishedId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		printf("C1:%s %d %s\n",tranfinishedId,itime,A1S[len])>>outfile
		close(outfile)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2
		}
	}
	else if($0~/^CinResponse\ has\ been\ sent\ by.*/)
	{
		isPending=0
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		if(isPending==0)
		{
			itime=countTime(realTime1,realTime2)
			printf("D1:%s[------]%s %s[------]%d[------]%s\n",++sentId,realTime1,realTime2,itime,A1S[len])
			sub(/false|true/,"",A1S[len])
			printf("D1:%s %d %s\n",sentId,itime,A1S[len])>>outfile
			close(outfile)
		}
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2
		}
	}
	else if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey:")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("D1':%s[------]%s %s[------]%d[------]%s\n",++timeoutId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		#printf("D1':%s %d %s\n",timeoutId,itime,A1S[len])>>outfile
		#close(outfile)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey:")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("D1'':%s[------]%s %s[------]%d[------]%s\n",++failId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		#printf("D1'':%s %d %s\n",failId,itime,A1S[len])>>outfile
		#close(outfile)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/)
	{
		print $0 >>outfile_3
		close(outfile_3)
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^CinTransactionExecutor\ queue\ size\:.*/)
	{
		queuesizeId++
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^Transaction\ SendFailed.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"key:")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("E1:%s[------]%s %s[------]%d[------]%s\n",++SendFailId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		#printf("E1:%s %d %s\n",SendFailId,itime,A1S[len])>>outfile
		#close(outfile)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^Transaction\ Timeout.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"key:")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("F1:%s[------]%s %s[------]%d[------]%s\n",++TTimeoutId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		#printf("F1:%s %d %s\n",TTimeoutId,itime,A1S[len])>>outfile
		#close(outfile)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^CinRequest\ has\ been\ sent\ by.*/)
	{
		Method=""
		Event=""
		ChainId=""
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey: ")
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
			if($0~/^ChainId.*/) 
			{
				sub(/\r/,"",$0)
				lenId=split($0,A1C,")")
				ChainId=A1C[lenId]
			}
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("A2:%s[------]%s %s[------]%d[------]%s[------]%s/%s[------]%s\n",++RespsendId,realTime1,realTime2,itime,A1S[len],Method,Event,ChainId)
		sub(/false|true/,"",A1S[len])
		printf("%s %s_%s %s\n",A1S[len],Method,Event,ChainId)>>outfile_5
		close(outfile_5)
		printf("A2:%s %d %s %s_%s\n",RespsendId,itime,A1S[len],Method,Event)>>outfile_4
		close(outfile_4)
		MAE=Method "_" Event
		if((MAE=="Message_01" || MAE=="Logon_02") && ChainId!="")
		{
			if(ChainId in iarray)
			{
				delete iarray[ChainId]
			}
		}
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^CinResponse\ has\ been\ received.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("B2:%s[------]%s %s[------]%d[------]%s\n",++CinResponsereceivedId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		printf("B2:%s %d %s\n",CinResponsereceivedId,itime,A1S[len])>>outfile_4
		close(outfile_4)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^ResponseReceivedEvent\ has\ been\ started.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S," Key: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("C2:%s[------]%s %s[------]%d[------]%s\n",++RespstartId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		printf("C2:%s %d %s\n",RespstartId,itime,A1S[len])>>outfile_4
		close(outfile_4)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S," Key: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("D2:%s[------]%s %s[------]%d[------]%s\n",++RespfinishId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		printf("D2:%s %d %s\n",RespfinishId,itime,A1S[len])>>outfile_4
		close(outfile_4)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^Recieved\ out\ of\ bunding\ response.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"Key: ")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("C2':%s[------]%s %s[------]%d[------]%s\n",++RecievedoutrespId,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		#printf("C2':%s %d %s\n",RecievedoutrespId,itime,A1S[len])>>outfile_4
		#close(outfile_4)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^send CinMessage to next node.*/)
	{
		sub(/\r/,"",$0)
		len=split($0,A1S,"MessageKey:")
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		itime=countTime(realTime1,realTime2)
		printf("E2:%s[------]%s %s[------]%d[------]%s\n",++sendCMto,realTime1,realTime2,itime,A1S[len])
		sub(/false|true/,"",A1S[len])
		#printf("E2:%s %d %s\n",sendCMto,itime,A1S[len])>>outfile_4
		#close(outfile_4)
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^Package is not CinMessage.*/)
	{
		notCinMes++
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		if($0~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/)
		{
			realTime1=$1;realTime2=$2;
		}
	}
	else if($0~/^send data handled Error.*/)
	{
		sendhError++
		for(;getline && $0!~/^2017\-[0,1][0-9]\-[0-3][0-9]\ [0-2][0-9]\:[0-5][0-9]\:/;)
		{
			if($0~/^CinRequest\ has\ been\ received.*/) receiveId++
			if($0~/^TransactionCreatedEvent\ has\ been\ started.*/) transtartId++
			if($0~/^TransactionCreatedEvent\ has\ been\ finished.*/) tranfinishedId++
			if($0~/^CinResponse\ has\ been\ sent\ by.*/) sentId++
			if($0~/^Transaction\ FROM\ client\ Send\ Timeout.*/) timeoutId++
			if($0~/^Transaction\ FROM\ client\ Send\ Failed.*/) failId++
			if($0~/^CinTransactionOrderedWorker-[0-9]* queue remain\:.*/) queueId++
			if($0~/^CinTransactionExecutor\ queue\ size\:.*/) queuesizeId++
			if($0~/^Transaction\ SendFailed.*/) SendFailId++
			if($0~/^Transaction\ Timeout.*/) TTimeoutId++
			if($0~/^CinRequest\ has\ been\ sent\ by.*/) RespsendId++
			if($0~/^CinResponse\ has\ been\ received.*/) CinResponsereceivedId++
			if($0~/^ResponseReceivedEvent\ has\ been\ started.*/) RespstartId++
			if($0~/^ResponseReceivedEvent\ has\ been\ finished.*/) RespfinishId++
			if($0~/^Recieved\ out\ of\ bunding\ response.*/) RecievedoutrespId++
			if($0~/^send CinMessage to next node.*/) sendCMto++
			if($0~/^Package is not CinMessage.*/) notCinMes++
			if($0~/^send data handled Error.*/) sendhError++
		}
		{
			realTime1=$1;realTime2=$2;
		}
	}
}
END{
	printf("(A1) the sum of CinRequest receive packets is :%d\n",receiveId)>outfile_6
	close(outfile_6)
	printf("(B1) the sum of TransactionCreatedEvent start packets is :%d\n",transtartId)>>outfile_6
	close(outfile_6)
	printf("(C1) the sum of TransactionCreatedEvent finished packets is :%d\n",tranfinishedId)>>outfile_6
	close(outfile_6)
	printf("(D1) the sum of CinResponse sent packets is :%d\n",sentId)>>outfile_6
	close(outfile_6)
	printf("(D1') TimeoutSum packets is :%d;(D1'') FailedSum packets is :%d\n",timeoutId,failId)>>outfile_6
	close(outfile_6)
	printf("(E1) Transaction SendFailed packets is :%d;(F1) Transaction Timeout packets is :%d\n",SendFailId,TTimeoutId)>>outfile_6
	close(outfile_6)
	printf("CinTransactionOrderedWorker queue sum is :%d ;CinTransactionExecutor queue sum is :%d\n",queueId,queuesizeId)>>outfile_6
	close(outfile_6)
	printf("(A2) the sum of CinRequest sent packets is :%d\n",RespsendId)>>outfile_6
	close(outfile_6)
	printf("(B2) the sum of CinResponse received packets is :%d\n",CinResponsereceivedId)>>outfile_6
	close(outfile_6)
	printf("(C2) the sum of ResponseReceivedEvent started packets is :%d\n",RespstartId)>>outfile_6
	close(outfile_6)
	printf("(D2) the sum of ResponseReceivedEvent finished packets is :%d\n",RespfinishId)>>outfile_6
	close(outfile_6)
	printf("(E2) the sum of send CinMessage to is :%d\n",sendCMto)>>outfile_6
	close(outfile_6)
	printf("the sum of Package is not CinMessage is :%d\n",notCinMes)>>outfile_6
	close(outfile_6)
	printf("the sum of send data handled Error is :%d\n",sendhError)>>outfile_6
	close(outfile_6)
	printf("(C2') the sum of Recieved out of bunding packets is :%d\n",RecievedoutrespId)>>outfile_6
	close(outfile_6)
	for(name in iarray)
		print name,iarray[name] >>outfile_6
	close(outfile_6)
	print "finish:",outfile_6
}


