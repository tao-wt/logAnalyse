# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#  awk -f loganalyse.awk inputfile
BEGIN{ 
	mint=1969309360 
	key="" inputfile="./out/log_1"
}
{ 
	for(;getline var <inputfile;) 
	{  
		if(index(var,$2))   
		{   
			len=split(var,ikey," ")   
			if(mint>ikey[2])   
			{    
				mint=ikey[2]    
				key=$2   
			}  
		} 
	} 
	close(inputfile) 
	print mint,$2
}
END{ 
	print key
}
