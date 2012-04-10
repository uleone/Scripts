#!/bin/bash
housePath="$HOME/house"
if [ ! -e "$housePath" ]
then
  mkdir "$housePath"
fi
cd "$housePath"
day=`date +%F-%H:%M`
today=`date +%F`
for count in {1..12}
do
  wget http://beijing.anjuke.com/sale/o5-p$count -O anjuke.txt

  grep -E '建造年代：|/address' anjuke.txt | grep -v option > result.txt 
  sed '{N;s/\n/ /}' -i result.txt
  sed s/[[:space:]]//g -i result.txt
  sed s/';'/','/g -i result.txt
  sed s/'&nbsp,&nbsp,'/';'/g -i result.txt
  sed s/'<\/address>'/';'/g -i result.txt
  sed s/'，'/','/g -i result.txt
  sed s/'<\/p>'//g -i result.txt
  sed s/'厅,'/'厅;'/g -i result.txt
  sed s/平米,'/';'/g -i result.txt
  sed s/'元,'/'元;'/g -i result.txt
  sed s/',建'/';建'/g -i result.txt
  sed 's#<em>\|</em>\|，\|单价：\|楼层：\|建造年代：\|元# #g' -i result.txt
  #awk -F';' '{print $1 $2 $3}' result.txt | sed s/','/';'/g -i $3 >>result.csv
  #mv result.txt result.csv
  cat result.txt >> anjuke.$today.csv
  # If you want to change encoding to gb2312, uncomment the following line.
  #iconv -f utf-8 -t gb2312 anjuke.$today.csv -o anjuke.$today.csv
done
rm *.txt
