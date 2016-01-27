#!/bin/bash


# for i in `seq 1601 1624`;
# do
# 	(echo "$i $(curl https://xkcd.com/$i/ 2>&1 | sed -n "72p")"&)
# done


# for i in `seq 1 10`;
# do 
	# 
# done; 

# wait
# echo "derp"


for j in `seq 0 15`;
do
	for i in `seq 1 100`;
	do 
		k=$(expr $j \* 100 + $i)
		{ echo "$k $(curl https://xkcd.com/$k/ 2>&1 | awk '/<img src=\"\/\/imgs.xkcd.com\/comics/')"; } &
	done; 
	wait
done;

for k in `seq 1601 1624`;
do
	{ echo "$k $(curl https://xkcd.com/$k/ 2>&1 | awk '/<img src=\"\/\/imgs.xkcd.com\/comics/')"; } &
done;

wait
