#!/bin/sh
awk -F '|' 'BEGIN{
#取得当前主机名,为每个机器单独部署时文件起一个别名
OFS="|";
is_null = "";
date=strftime("%Y%m%d");
table_filename="machine."date".unl";
logfile="./log_out"date".log"
print "...解析文件开始...."  strftime("%Y-%m-%d %H:%M:%S") >> logfile}

END{print "...解析文件结束....DONE"  strftime("%Y-%m-%d %H:%M:%S") >> logfile}

{
#文件分割 当文件条数为总记录条数50w的倍数时进行拆解文件,500000记录大小为:30M如需要更大的文件,可改变此大小
#4000000 约等于130M 56000000 约等于2G
if(NR % 56000000 ==0){
table_filename=table_filename"_"NR;
}

#对表中数据进行映射
#密码器编号
id = $1;
#密码器状态
state=$2;
#机具芯片号
if(length($3) > 0){
chipsn = substr($3,1,8);
}else{
chipsn=is_null;
}
#开户日期
if(length($4) > 0){
setdate = substr($4,1,8);
}else{
setdate = is_null;
}
#销户日期
if(length($5) > 0){
downdate = substr($5,1,8);
}else{
downdate = is_null;
}
#客户信息号
customno = is_null
#一级分行编号
if(length($7) > 0){
bankid = "250";
}else{
bankid = is_null;
}
#网点编号
if(length($8) > 0){
node = substr($8,1,6);
}else{
node = is_null;
}
#类型
issueorreg=$9


print id,state,chipsn,setdate,downdate,customno,bankid,node,issueorreg >> table_filename

}' 1.unl

