#!/bin/bash


## start logging CPU and RAM usage without top
# echo `date +%s` \
#      `mpstat 2 1 | awk '$1 ~ /Average:/ && $12 ~ /[0-9.]+/ { print 100 - $12 }'` # http://stackoverflow.com/questions/9229333/how-to-get-overall-cpu-usage-e-g-57-on-linux \
#      `free | awk '{if ($1 ~ /Mem:/) t=$2 } $2 ~ /buffers/ { print $4*100/t }'` # http://serverfault.com/questions/38065/how-to-get-memory-usage-with-vmstat
## start logging CPU and RAM usage with top
top -b -d 2 \
    | awk ' {if ($3 ~ /..:..:../) "date -d "$3" +%s" | getline T } # pipe time to date within awk: http://stackoverflow.com/questions/20646819/how-can-i-pass-variables-from-awk-to-a-shell-command#34420667 \
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

