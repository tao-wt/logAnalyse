# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#   awk -f okloganalyse.awk inputfile
BEGIN{ 
	outfile="./out/log_1_time" 
	A1T=0;B1T=0;C1T=0;D1T=0;j=0 
	system("rm -rf " outfile) 
	#FS="[\-\-\-\-\-\-]" 
	key="";i=0;D1T_A1T_SUM=0;B1T_A1T_SUM=0;C1T_B1T_SUM=0;D1T_B1T_SUM=0 
	D1T_A1T_MAX=0;B1T_A1T_MAX=0;C1T_B1T_MAX=0;D1T_B1T_MAX=0 
	D1T_A1T_MIN=100;B1T_A1T_MIN=100;C1T_B1T_MIN=100;D1T_B1T_MIN=100
}
{ 
	if(NF==0) 
	key=$3 
	if($3==key) 
	{  
		j++  
		if(j>4)  
		{   
			if(A1T>0 && B1T>0 && C1T>0 && D1T>0 && D1T-A1T>=0 && B1T-A1T>=0 && C1T-B1T>=0 && D1T-B1T>=0)   
			{    
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
				A1T=0;B1T=0;C1T=0;D1T=0;j=1   
			}   
			if($0~/A1.*/) A1T=$2   
			else if($0~/B1.*/) B1T=$2   
			else if($0~/C1.*/) C1T=$2   
			else if($0~/D1.*/) D1T=$2  
		}  else  
		{   
			if($0~/A1.*/) A1T=$2   
			else if($0~/B1.*/) B1T=$2   
			else if($0~/C1.*/) C1T=$2   
			else if($0~/D1.*/) D1T=$2  
		} 
	} else  
	{  
		if(A1T>0 && B1T>0 && C1T>0 && D1T>0 && D1T-A1T>=0 && B1T-A1T>=0 && C1T-B1T>=0 && D1T-B1T>=0)  
		{   
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
		}  
		A1T=0;B1T=0;C1T=0;D1T=0;j=1  
		key=$3  
		if($0~/A1.*/) A1T=$2  
		else if($0~/B1.*/) B1T=$2  
		else if($0~/C1.*/) C1T=$2  
		else if($0~/D1.*/) D1T=$2 
	}
}
END{ 
	printf("D1T_A1T_MAX=%d,B1T_A1T_MAX=%d,C1T_B1T_MAX=%d,D1T_B1T_MAX=%d\n",D1T_A1T_MAX,B1T_A1T_MAX,C1T_B1T_MAX,D1T_B1T_MAX) 
	printf("D1T_A1T_MIN=%d,B1T_A1T_MIN=%d,C1T_B1T_MIN=%d,D1T_B1T_MIN=%d\n",D1T_A1T_MIN,B1T_A1T_MIN,C1T_B1T_MIN,D1T_B1T_MIN) 
	printf("D1T_A1T_AV=%d,B1T_A1T_AV=%d,C1T_B1T_AV=%d,D1T_B1T_AV=%d\n",D1T_A1T_SUM/i,B1T_A1T_SUM/i,C1T_B1T_SUM/i,D1T_B1T_SUM/i)
}

