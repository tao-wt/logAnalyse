# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#			awk -f okloganalyse.awk inputfile

BEGIN{
	outfile="./out/log_1_time";num=0
	A1T=0;B1T=0;C1T=0;D1T=0;j=0
	values="";maestring=""
	a=0;b=0;c=0;d=0
	system("rm -rf " outfile)
	outfile_2="./out/methodAndevent_1"
	system("rm -rf " outfile_2)
	key="";i=0;D1T_A1T_SUM=0;B1T_A1T_SUM=0;C1T_B1T_SUM=0;D1T_B1T_SUM=0
	D1T_A1T_MAX=0;B1T_A1T_MAX=0;C1T_B1T_MAX=0;D1T_B1T_MAX=0
	D1T_A1T_MIN=100;B1T_A1T_MIN=100;C1T_B1T_MIN=100;D1T_B1T_MIN=100
}
{
	if(NF==0) key=$3
	if($3==key)
	{
		j++
		if($0~/^A1.*/) 
		{
			A1T=$2;maestring=$4;a++;
		}
		else if($0~/^B1.*/) 
		{
			B1T=$2;b++;
		}
		else if($0~/^C1.*/) 
		{
			C1T=$2;c++;
		}
		else if($0~/^D1.*/) 
		{
			D1T=$2;d++;
		}
	}
	else 
	{
		if(j==4 && A1T>0 && B1T>0 && C1T>0 && D1T>0 && D1T-A1T>=0 && B1T-A1T>=0 && C1T-B1T>=0 && D1T-B1T>=0)
		{
			#print "-------------------------------------------------------------------------------------------------------------------------------------"
			i++
			D1T_A1T_SUM+=D1T-A1T;B1T_A1T_SUM+=B1T-A1T;C1T_B1T_SUM+=C1T-B1T;D1T_B1T_SUM+=D1T-B1T
			D1T_A1T_MAX=(D1T-A1T>D1T_A1T_MAX)? D1T-A1T:D1T_A1T_MAX
			D1T_A1T_MIN=(D1T-A1T<D1T_A1T_MIN)? D1T-A1T:D1T_A1T_MIN
			B1T_A1T_MAX=(B1T-A1T>B1T_A1T_MAX)? B1T-A1T:B1T_A1T_MAX
			B1T_A1T_MIN=(B1T-A1T<B1T_A1T_MIN)? B1T-A1T:B1T_A1T_MIN
			C1T_B1T_MAX=(C1T-B1T>C1T_B1T_MAX)? C1T-B1T:C1T_B1T_MAX
			C1T_B1T_MIN=(C1T-B1T<C1T_B1T_MIN)? C1T-B1T:C1T_B1T_MIN
			D1T_B1T_MAX=(D1T-B1T>D1T_B1T_MAX)? D1T-B1T:D1T_B1T_MAX
			D1T_B1T_MIN=(D1T-B1T<D1T_B1T_MIN)? D1T-B1T:D1T_B1T_MIN
			print key,A1T,B1T,C1T,D1T,D1T-A1T,B1T-A1T,C1T-B1T,D1T-B1T
			print key,A1T,B1T,C1T,D1T,D1T-A1T,B1T-A1T,C1T-B1T,D1T-B1T >>outfile
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
				out="./out/" maestring "_1"
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
		A1T=0;B1T=0;C1T=0;D1T=0;j=1;maestring="";values="";a=0;b=0;c=0;d=0
		key=$3
		if($0~/^A1.*/) 
		{
			A1T=$2;maestring=$4;a++
		}
		else if($0~/^B1.*/) 
		{
			B1T=$2;b++;
		}
		else if($0~/^C1.*/) 
		{
			C1T=$2;c++;
		}
		else if($0~/^D1.*/) 
		{
			D1T=$2;d++;
		}
	}
}
END{
	printf("D1T_A1T_MAX=%d,B1T_A1T_MAX=%d,C1T_B1T_MAX=%d,D1T_B1T_MAX=%d\n",D1T_A1T_MAX,B1T_A1T_MAX,C1T_B1T_MAX,D1T_B1T_MAX)
	printf("D1T_A1T_MIN=%d,B1T_A1T_MIN=%d,C1T_B1T_MIN=%d,D1T_B1T_MIN=%d\n",D1T_A1T_MIN,B1T_A1T_MIN,C1T_B1T_MIN,D1T_B1T_MIN)
	printf("D1T_A1T_AV=%d,B1T_A1T_AV=%d,C1T_B1T_AV=%d,D1T_B1T_AV=%d\n",D1T_A1T_SUM/i,B1T_A1T_SUM/i,C1T_B1T_SUM/i,D1T_B1T_SUM/i)
	printf("D1T_A1T_MAX=%d,B1T_A1T_MAX=%d,C1T_B1T_MAX=%d,D1T_B1T_MAX=%d\n",D1T_A1T_MAX,B1T_A1T_MAX,C1T_B1T_MAX,D1T_B1T_MAX)>>outfile
	close(outfile)
	printf("D1T_A1T_MIN=%d,B1T_A1T_MIN=%d,C1T_B1T_MIN=%d,D1T_B1T_MIN=%d\n",D1T_A1T_MIN,B1T_A1T_MIN,C1T_B1T_MIN,D1T_B1T_MIN)>>outfile
	close(outfile)
	printf("D1T_A1T_AV=%d,B1T_A1T_AV=%d,C1T_B1T_AV=%d,D1T_B1T_AV=%d\n",D1T_A1T_SUM/i,B1T_A1T_SUM/i,C1T_B1T_SUM/i,D1T_B1T_SUM/i)>>outfile
	close(outfile)
	for(name in iarray)
		print name," approach ",iarray[name]
}



