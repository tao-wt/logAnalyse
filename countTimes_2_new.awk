# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#			awk -f okloganalyse.awk inputfile

BEGIN{
	outfile="./out/log_2_time";num=0
	A2T=0;B2T=0;C2T=0;D2T=0;j=0
	values="";maestring=""
	a=0;b=0;c=0;d=0
	system("rm -rf " outfile)
	outfile_2="./out/methodAndevent_2"
	system("rm -rf " outfile_2)
	key="";i=0;D2T_A2T_SUM=0;B2T_A2T_SUM=0;C2T_B2T_SUM=0;D2T_C2T_SUM=0
	D2T_A2T_MAX=0;B2T_A2T_MAX=0;C2T_B2T_MAX=0;D2T_C2T_MAX=0
	D2T_A2T_MIN=90;B2T_A2T_MIN=90;C2T_B2T_MIN=90;D2T_C2T_MIN=90
}
{
	if(NF==0) key=$3
	if($3==key)
	{
		j++
		if($0~/^A2.*/) 
		{
			A2T=$2;maestring=$4;a++;
		}
		else if($0~/^B2.*/) 
		{
			B2T=$2;b++
		}
		else if($0~/C2.*/) 
		{
			C2T=$2;c++
		}
		else if($0~/D2.*/) 
		{
			D2T=$2;d++
		}
	}
	else 
	{
		if(j==4 && A2T>0 && B2T>0 && C2T>0 && D2T>0 && D2T-A2T>=0 && B2T-A2T>=0 && C2T-B2T>=0 && D2T-C2T>=0)
		{
			i++
			D2T_A2T_SUM+=D2T-A2T;B2T_A2T_SUM+=B2T-A2T;C2T_B2T_SUM+=C2T-B2T;D2T_C2T_SUM+=D2T-C2T
			D2T_A2T_MAX=(D2T-A2T>D2T_A2T_MAX)? D2T-A2T:D2T_A2T_MAX
			D2T_A2T_MIN=(D2T-A2T<D2T_A2T_MIN)? D2T-A2T:D2T_A2T_MIN
			B2T_A2T_MAX=(B2T-A2T>B2T_A2T_MAX)? B2T-A2T:B2T_A2T_MAX
			B2T_A2T_MIN=(B2T-A2T<B2T_A2T_MIN)? B2T-A2T:B2T_A2T_MIN
			C2T_B2T_MAX=(C2T-B2T>C2T_B2T_MAX)? C2T-B2T:C2T_B2T_MAX
			C2T_B2T_MIN=(C2T-B2T<C2T_B2T_MIN)? C2T-B2T:C2T_B2T_MIN
			D2T_C2T_MAX=(D2T-C2T>D2T_C2T_MAX)? D2T-C2T:D2T_C2T_MAX
			D2T_C2T_MIN=(D2T-C2T<D2T_C2T_MIN)? D2T-C2T:D2T_C2T_MIN
			print key,A2T,B2T,C2T,D2T,D2T-A2T,B2T-A2T,C2T-B2T,D2T-B2T
			print key,A2T,B2T,C2T,D2T,D2T-A2T,B2T-A2T,C2T-B2T,D2T-B2T >>outfile
			close(outfile)
		}
		if(j!=4)
		{
			#print "-------------------------------------------------------------------------------------------------------------------------------------"
			num++
			if(a>b) values=values " B"
			if(a>c) values=values " C"
			if(a>d) values=values " D"
			if(maestring!="")
			{
				out="./out/" maestring "_2"
				if(maestring in iarray)
				{
					iarray[maestring]+=1
				}
				else
				{
					iarray[maestring]=1
					print maestring >out
				}
				print num,"|",maestring,"|",key,"|",values ,"|",j
				print key,values >>out
				close(out)
				for(name in iarray)
					print name," approach ",iarray[name] >outfile_2
				close(outfile_2)
			}
		}
		A2T=0;B2T=0;C2T=0;D2T=0;j=1
		key=$3
		if($0~/^A2.*/) 
		{
			A2T=$2;maestring=$4;a++;
		}
		else if($0~/^B2.*/) 
		{
			B2T=$2;b++
		}
		else if($0~/C2.*/) 
		{
			C2T=$2;c++
		}
		else if($0~/D2.*/) 
		{
			D2T=$2;d++
		}
	}
}
END{
	printf("D2T_A2T_MAX=%d,B2T_A2T_MAX=%d,C2T_B2T_MAX=%d,D2T_C2T_MAX=%d\n",D2T_A2T_MAX,B2T_A2T_MAX,C2T_B2T_MAX,D2T_C2T_MAX)
	printf("D2T_A2T_MIN=%d,B2T_A2T_MIN=%d,C2T_B2T_MIN=%d,D2T_C2T_MIN=%d\n",D2T_A2T_MIN,B2T_A2T_MIN,C2T_B2T_MIN,D2T_C2T_MIN)
	printf("D2T_A2T_AV=%d,B2T_A2T_AV=%d,C2T_B2T_AV=%d,D2T_C2T_AV=%d\n",D2T_A2T_SUM/i,B2T_A2T_SUM/i,C2T_B2T_SUM/i,D2T_C2T_SUM/i)
	printf("D2T_A2T_MAX=%d,B2T_A2T_MAX=%d,C2T_B2T_MAX=%d,D2T_C2T_MAX=%d\n",D2T_A2T_MAX,B2T_A2T_MAX,C2T_B2T_MAX,D2T_C2T_MAX)>>outfile
	close(outfile)
	printf("D2T_A2T_MIN=%d,B2T_A2T_MIN=%d,C2T_B2T_MIN=%d,D2T_C2T_MIN=%d\n",D2T_A2T_MIN,B2T_A2T_MIN,C2T_B2T_MIN,D2T_C2T_MIN)>>outfile
	close(outfile)
	printf("D2T_A2T_AV=%d,B2T_A2T_AV=%d,C2T_B2T_AV=%d,D2T_C2T_AV=%d\n",D2T_A2T_SUM/i,B2T_A2T_SUM/i,C2T_B2T_SUM/i,D2T_C2T_SUM/i)>>outfile
	close(outfile)
	for(name in iarray)
		print name," approach ",iarray[name]
}



