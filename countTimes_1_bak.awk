#spaceanalysespacecmp'sspacelogPLY#spacestartspacethespaceanalysespacescriptspacewhilespacetestspaceisspacestablespacePLY#spacewriterspaceSY60216spacePLY#spaceusage:PLY#TABTABTABawkspace-fspaceokloganalyse.awkspaceinputfilePLYPLYBEGIN{PLYTABoutfile="./out/log_1_time";num=0PLYTABA1T=0;B1T=0;C1T=0;D1T=0;j=0PLYTABvalues="";maestring=""PLYTABa=0;b=0;c=0;d=0PLYTABsystem("rmspace-rfspace"spaceoutfile)PLYTABoutfile_2="./out/methodAndevent_1"PLYTABsystem("rmspace-rfspace"spaceoutfile_2)PLYTABkey="";i=0;D1T_A1T_SUM=0;B1T_A1T_SUM=0;C1T_B1T_SUM=0;D1T_B1T_SUM=0PLYTABD1T_A1T_MAX=0;B1T_A1T_MAX=0;C1T_B1T_MAX=0;D1T_B1T_MAX=0PLYTABD1T_A1T_MIN=100;B1T_A1T_MIN=100;C1T_B1T_MIN=100;D1T_B1T_MIN=100PLY}PLY{PLYTABif(NF==0)spacekey=$3PLYTABif($3==key)PLYTAB{PLYTABTABj++PLYTABTABif($0~/^A1.*/)spacePLYTABTAB{PLYTABTABTABA1T=$2;maestring=$4;a++;PLYTABTAB}PLYTABTABelsespaceif($0~/^B1.*/)spacePLYTABTAB{PLYTABTABTABB1T=$2;b++;PLYTABTAB}PLYTABTABelsespaceif($0~/^C1.*/)spacePLYTABTAB{PLYTABTABTABC1T=$2;c++;PLYTABTAB}PLYTABTABelsespaceif($0~/^D1.*/)spacePLYTABTAB{PLYTABTABTABD1T=$2;d++;PLYTABTAB}PLYTAB}PLYTABelsespacePLYTAB{PLYTABTABif(j==4space&&spaceA1T>0space&&spaceB1T>0space&&spaceC1T>0space&&spaceD1T>0space&&spaceD1T-A1T>=0space&&spaceB1T-A1T>=0space&&spaceC1T-B1T>=0space&&spaceD1T-B1T>=0)PLYTABTAB{PLYTABTABTAB#printspace"-------------------------------------------------------------------------------------------------------------------------------------"PLYTABTABTABi++PLYTABTABTABD1T_A1T_SUM+=D1T-A1T;B1T_A1T_SUM+=B1T-A1T;C1T_B1T_SUM+=C1T-B1T;D1T_B1T_SUM+=D1T-B1TPLYTABTABTABD1T_A1T_MAX=(D1T-A1T>D1T_A1T_MAX)?spaceD1T-A1T:D1T_A1T_MAXPLYTABTABTABD1T_A1T_MIN=(D1T-A1T<D1T_A1T_MIN)?spaceD1T-A1T:D1T_A1T_MINPLYTABTABTABB1T_A1T_MAX=(B1T-A1T>B1T_A1T_MAX)?spaceB1T-A1T:B1T_A1T_MAXPLYTABTABTABB1T_A1T_MIN=(B1T-A1T<B1T_A1T_MIN)?spaceB1T-A1T:B1T_A1T_MINPLYTABTABTABC1T_B1T_MAX=(C1T-B1T>C1T_B1T_MAX)?spaceC1T-B1T:C1T_B1T_MAXPLYTABTABTABC1T_B1T_MIN=(C1T-B1T<C1T_B1T_MIN)?spaceC1T-B1T:C1T_B1T_MINPLYTABTABTABD1T_B1T_MAX=(D1T-B1T>D1T_B1T_MAX)?spaceD1T-B1T:D1T_B1T_MAXPLYTABTABTABD1T_B1T_MIN=(D1T-B1T<D1T_B1T_MIN)?spaceD1T-B1T:D1T_B1T_MINPLYTABTABTABprintspacekey,A1T,B1T,C1T,D1T,D1T-A1T,B1T-A1T,C1T-B1T,D1T-B1TPLYTABTABTABprintspacekey,A1T,B1T,C1T,D1T,D1T-A1T,B1T-A1T,C1T-B1T,D1T-B1Tspace>>outfilePLYTABTABTABclose(outfile)PLYTABTAB}PLYTABTABif(j!=4)PLYTABTAB{PLYTABTABTAB#printspace"-------------------------------------------------------------------------------------------------------------------------------------"PLYTABTABTABnum++PLYTABTABTABif(a>b)spacevalues=valuesspace"spaceB"PLYTABTABTABif(a>c)spacevalues=valuesspace"spaceC"PLYTABTABTABif(a>d)spacevalues=valuesspace"spaceD"PLYTABTABTABif(maestring!="")PLYTABTABTAB{PLYTABTABTABTABout="./out/"spacemaestringspace"_1"PLYTABTABTABTABif(maestringspaceinspaceiarray)PLYTABTABTABTAB{PLYTABTABTABTABTABiarray[maestring]+=1PLYTABTABTABTAB}PLYTABTABTABTABelsePLYTABTABTABTAB{PLYTABTABTABTABTABiarray[maestring]=1PLYTABTABTABTABTABprintspacemaestringspace>outPLYTABTABTABTAB}PLYTABTABTABTABprintspacenum,"|",maestring,"|",key,"|",valuesspace,"|",jPLYTABTABTABTABprintspacekey,valuesspace>>outPLYTABTABTABTABclose(out)PLYTABTABTABTABfor(namespaceinspaceiarray)PLYTABTABTABTABTABprintspacename,"spaceapproachspace",iarray[name]space>outfile_2PLYTABTABTABTABclose(outfile_2)PLYTABTABTAB}PLYTABTAB}PLYTABTABA1T=0;B1T=0;C1T=0;D1T=0;j=1;maestring="";values="";a=0;b=0;c=0;d=0PLYTABTABkey=$3PLYTABTABif($0~/^A1.*/)spacePLYTABTAB{PLYTABTABTABA1T=$2;maestring=$4;a++PLYTABTAB}PLYTABTABelsespaceif($0~/^B1.*/)spacePLYTABTAB{PLYTABTABTABB1T=$2;b++;PLYTABTAB}PLYTABTABelsespaceif($0~/^C1.*/)spacePLYTABTAB{PLYTABTABTABC1T=$2;c++;PLYTABTAB}PLYTABTABelsespaceif($0~/^D1.*/)spacePLYTABTAB{PLYTABTABTABD1T=$2;d++;PLYTABTAB}PLYTAB}PLY}PLYEND{PLYTABprintf("D1T_A1T_MAX=%d,B1T_A1T_MAX=%d,C1T_B1T_MAX=%d,D1T_B1T_MAX=%d\n",D1T_A1T_MAX,B1T_A1T_MAX,C1T_B1T_MAX,D1T_B1T_MAX)PLYTABprintf("D1T_A1T_MIN=%d,B1T_A1T_MIN=%d,C1T_B1T_MIN=%d,D1T_B1T_MIN=%d\n",D1T_A1T_MIN,B1T_A1T_MIN,C1T_B1T_MIN,D1T_B1T_MIN)PLYTABprintf("D1T_A1T_AV=%d,B1T_A1T_AV=%d,C1T_B1T_AV=%d,D1T_B1T_AV=%d\n",D1T_A1T_SUM/i,B1T_A1T_SUM/i,C1T_B1T_SUM/i,D1T_B1T_SUM/i)PLYTABprintf("D1T_A1T_MAX=%d,B1T_A1T_MAX=%d,C1T_B1T_MAX=%d,D1T_B1T_MAX=%d\n",D1T_A1T_MAX,B1T_A1T_MAX,C1T_B1T_MAX,D1T_B1T_MAX)>>outfilePLYTABclose(outfile)PLYTABprintf("D1T_A1T_MIN=%d,B1T_A1T_MIN=%d,C1T_B1T_MIN=%d,D1T_B1T_MIN=%d\n",D1T_A1T_MIN,B1T_A1T_MIN,C1T_B1T_MIN,D1T_B1T_MIN)>>outfilePLYTABclose(outfile)PLYTABprintf("D1T_A1T_AV=%d,B1T_A1T_AV=%d,C1T_B1T_AV=%d,D1T_B1T_AV=%d\n",D1T_A1T_SUM/i,B1T_A1T_SUM/i,C1T_B1T_SUM/i,D1T_B1T_SUM/i)>>outfilePLYTABclose(outfile)PLYTABfor(namespaceinspaceiarray)PLYTABTABprintspacename,"spaceapproachspace",iarray[name]PLY}PLYPLYPLY