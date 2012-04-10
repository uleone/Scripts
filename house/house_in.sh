#!/bin/bash
housePath="$HOME/house"
if [ ! -e "$housePath" ]
then
  mkdir "$housePath"
fi
cd "$housePath"
day=`date +%F-%H:%M`
today=`date +%F`
for count in {1..5}
do
  #wget http://beijing.anjuke.com/sale/o5-p$count -O anjuke.txt
  wget http://beijing.anjuke.com/sale/o5-p$count-rd1?kw=$1#kw -O anjuke.txt

  grep -E '建造年代：|/address|title.*prop_list' anjuke.txt | grep -v option > result.txt 
  sed s/[[:space:]]//g -i result.txt
  sed 'N;N;s/\n/ /g' -i result.txt
  awk -F'[' '{print $2}' result.txt > result2.txt
  sed s/[[:space:]]//g -i result2.txt
  sed s/';'/','/g -i result2.txt
  sed s/'\]<\/a>'//g -i result2.txt
  sed s/'&nbsp,&nbsp,'/';'/g -i result2.txt
  sed s/'<\/address>'/';'/g -i result2.txt
  sed s/'，'/','/g -i result2.txt
  sed s/'<\/p>'//g -i result2.txt
  sed s/'厅,'/'厅;'/g -i result2.txt
  sed s/'平米,'/';'/g -i result2.txt
  sed s/'元,'/'元;'/g -i result2.txt
  sed s/',建'/';建'/g -i result2.txt
  sed 's#<em>\|</em>\|，\|单价：\|楼层：\|建造年代：\|元# #g' -i result2.txt
  sed s/','/'.'/g -i result2.txt
  sed s/';'/','/g -i result2.txt
  sed s/[[:space:]]//g -i result.txt
  #awk -F';' '{print $1 $2 $3}' result.txt | sed s/','/';'/g -i $3 >>result.csv
  #mv result.txt result.csv
  cat result2.txt >> anjuke.$1.$today.csv
done
# If you want to change encoding to gb2312, uncomment the following line.
#iconv -f utf-8 -t gb2312 anjuke.$1.$today.csv -o anjuke.$1.$today.csv
rm *.txt
