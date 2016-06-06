#!/bin/bash


## start logging CPU and RAM usage
top -b -d 2 \
    | awk ' {if ($3 ~ /..:..:../) T=$3 } \
            {if ($1 ~ /%Cpu/) c=$8 } \
            {if ($0 ~ /iB Mem:/) {t=$3; u=$5;}} \
            {if ($0 ~ /iB Swap:/) s=$9} \
            /PID/ { print T, 100-c, (u-s)/t*100; fflush()}' \
	  > top.out &
PID=$! # remember PID

## run and time overall make
/usr/bin/time -v -a -o timing /opt/make-4.1/bin/make PV=/opt/paraview-5.0.1_GL2/ -j6 -k 2>&1 | tee make0.out

## terminate top-logging
kill $PID

