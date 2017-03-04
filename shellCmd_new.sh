#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#du参数
du -sch *
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rsync -arvz --delete -e "ssh -p 22" ~/test/ zhuser@99.12.90.8:/home/zhuser/test
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tcpdump src host 99.12.69.165 and dst 99.12.90.100 and udp  -vx -i eth0 -e 
tcpdump dst host 99.12.69.165 and icmp  -vx -i eth0 -e
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq
# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
zip bak_conf.zip ./dbconfiglogger.properties ./dbconfig.properties ./webmgr.properties ./WEB-INF/classes/dbconfig.properties ./WEB-INF/classes/config/spring.xml
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
date
hwclock --show
hwclock --set --date="2017-02-14 16:43:00"
hwclock --hctosys
hwclock --show
date
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sort -k3 -k2 ./out/log_1 >./out/log_1_sort
sort -k3 -k2 ./out/log_2 >./out/log_2_sort
sort -k1 keyAndMethod_2 | awk '{print $1}' | uniq >key_2
awk -F: -v num=0 -v max=0 -v min=19999 -v sum=0 '{num++;sum+=$2;if($2>max){max=$2} if(min>$2){min=$2}} END{print "max=",max ;print "min=",min ;print"ava=",sum/num }' queue
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
