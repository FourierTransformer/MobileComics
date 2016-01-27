#!/bin/bash
# for i in `seq 1 1624`;
# do 
# 	phantomjs loadspeed.js http://localhost:8081/crop/$i
# done;

curl -s -L -o index.html http://localhost:8081

for j in `seq 0 150`;
do
	for i in `seq 1 10`;
	do 
		k=$(expr $j \* 10 + $i)
		{
			mkdir -p $k
		 	curl -s -L -o ./$k/index.html http://localhost:8081/$k
		 	mkdir -p crop/$k 
		 	curl -s -L -o ./crop/$k/index.html http://localhost:8081/crop/$k
		} &
	done; 
	wait
	echo $j
done;

for k in `seq 1601 1624`;
do
	{
		mkdir -p $k
		curl -s -L -o ./$k/index.html http://localhost:8081/$k
		mkdir -p crop/$k 
		curl -s -L -o ./crop/$k/index.html http://localhost:8081/crop/$k
	} &
done;

wait