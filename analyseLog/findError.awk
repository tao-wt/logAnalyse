# analyse cmp's log
# start the analyse script while test is stable 
# writer SY60216 
# usage:
#  awk -f loganalyse.awk inputfile
BEGIN{ 
	key="";num=0 
	values="" 
	array["Data/11"]=0;array["Data/12"]=0; a=0;b=0;c=0;d=0 
	outfile="./out/Error" 
	outfile_2="./out/methodAndevent" 
	system("rm -rf " outfile) 
	system("rm -rf " outfile_2)
}
{ 
	key=$0 
	sub(/^-/,"\\-",key) 
	cmd_1="grep  -w \"" key "\"" " ./out/log_1" 
	while(cmd_1 | getline var) 
	{  
		if(var~/^A[1,2].*/) a++  
		if(var~/^B[1,2].*/) b++  
		if(var~/^C[1,2].*/) c++  
		if(var~/^D[1,2].*/) d++ 
	} 
	close(cmd_1) 
	if(a!=b || b!=c || d<a) 
	{  
		num++  
		cmd_2="grep  -w \"" key "\"" " ./out/keyAndMethod | awk '{print $2}' | uniq "  
		while(cmd_2 | getline var_2)  
		{   
			#len=split(var_2,A1S," ")   
			if(var_2 in array)   
			{    
				array[var_2]+=1   
			}   
			else   
			{    
				array[var_2]=1   
			}  
		}  
		close(cmd_2)  
		if(a>b) values=values " B"  
		if(a>c) values=values " C"  
		if(a>d) values=values " D" 
		print "-------------------------------------------------------------------------------------------------------------------------------------"  
		print num,"a,b,c,d:",a,b,c,d," ",key,values  
		print num,key,values>>outfile  
		close(outfile)  
		for(name in array)   
			print name," approach ",array[name] >outfile_2  
		close(outfile_2) 
	} 
	values="";a=0;b=0;c=0;d=0
}
END{ 
	for(name in array)  
		print name," approach ",array[name]
}
