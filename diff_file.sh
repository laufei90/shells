#!/bin/bash
#检测两台服务器指定目录下的文件一致性
GCOLOR="\e[47;32m ------ [DELETED] \e[0m"
WCOLOR="\e[43;31m ------ [CHANGED] \e[0m"

#通过对比两台服务器上文件的md5值达到检测一致性的目的

a_dir=pythons
b_dir=pythons_b
#b_ip=192.168.31.55
#将指定目录下的文件全部遍历出来并作为md5sum命令的参数进而得到所有文件的md5值并写入到指定文件中
cd $a_dir
find . -type f | xargs md5sum > ../md5_a.txt
#ssh $b_ip "find $b_dir -type f | xargs md5sum > /tmp/md5_b.txt"
#scp $b_ip:/tmp/md5_b.txt /tmp
cd ../$b_dir
find . -type f | xargs md5sum > ../md5_b.txt
#将文件名作为遍历对象进行一一比对
cd ..
echo "以${a_dir}目录为基准将文件名作为遍历对象进行一一比对"
for f in `awk '{print $2}' md5_a.txt`
do
#不存在遍历对象中的文件时直接输出不存在的结果
if grep -qw "$f" md5_b.txt
then
md5_a=`grep -w "$f" md5_a.txt | awk '{print $1}'`
md5_b=`grep -w "$f" md5_b.txt | awk '{print $1}'`
#当文件存在时如果md5值不一致则输出文件改变的结果
if [ $md5_a != $md5_b ]
then
echo -e "$f  $GCOLOR."
fi

else
echo -e "$f  $WCOLOR."
fi
done