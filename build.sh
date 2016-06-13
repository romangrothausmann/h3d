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

## top.out can be CLI visualized with:
# tail -n300 -f top.out    |   stdbuf -oL   awk '{"date -d @"$1" +%T" | getline T; print T, $2, $3}'  |   feedgnuplot.pl --stream --domain --lines --timefmt '%H:%M:%S' --set 'format x "%H:%M:%S"' --ymin 0 --ymax 100 --nopoints --lines --with "boxes fs solid " --style 0 "lc 3 with steps" --style 1 "lc 2 with steps" --terminal 'dumb 120,20' --xlen 600 | sed 's/\x0c/\x1bc\n/'


## run and time overall make
/usr/bin/time -v -a -o timing /opt/make-4.1/bin/make PV=/opt/paraview-5.0.1_GL2/ -j6 -k 2>&1 | tee make0.out

## terminate top-logging
kill $PID

## create aSVGs and "render" them to MP4s, specify ETIME=120 SIZE=1920x1080 to override automatic detection:
make PV=/opt/paraview-5.0.1_GL2/ ETIME=120 all.neato.Make.mp4 
# make PV=/opt/paraview-5.0.1_GL2/ ETIME=120 SIZE=1920x1080 all.dot.Make.mp4 
# make PV=/opt/paraview-5.0.1_GL2/ ETIME=120 SIZE=1920x1080 all.fdp.Make.mp4 


