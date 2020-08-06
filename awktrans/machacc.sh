#!/bin/sh
awk -F '|' 'BEGIN{
#取得当前主机名,为每个机器单独部署时文件起一个别名
OFS="|";
is_null = "";
date=strftime("%Y%m%d");
table_filename="machacc."date".unl";
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
#一级分行编号
if(length($1) > 0){
bankid = "250";
}else{
bankid = is_null;
}
#网点编号
if(length($2) > 0){
node = substr($2,1,6);
}else{
node = is_null;
}
#账号密钥号
if(length($3) == 2){
dup = $3;
}else{
dup = is_null;
}
#账号
account=$4;
#密码器状态
state=$5;
#机具芯片号
if(length($6) > 0){
chipid = $6;
}else{
chipid=is_null;
}
#密码器编号
if(length($7) > 0){
mach = $7;
}else{
mach = is_null;
}
#密码器类型
if(length($8) > 0){
sign = $8;
}else{
sign = is_null;
}
#开户日期
if(length($9) > 0){
setdate = substr($9,1,8);
}else{
setdate = is_null;
}
#销户日期
if(length($10) > 0){
downdate = substr($10,1,8);
}else{
downdate = is_null;
}


print bankid,node,dup,accout,state,chipid,mach,sign,setdate,downdate >> table_filename;

}' 1.unl