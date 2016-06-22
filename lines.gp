# command line variables http://stackoverflow.com/questions/12328603/how-to-pass-command-line-argument-to-gnuplot
# inline data: http://stackoverflow.com/questions/4981279/how-to-make-several-plots-from-the-same-standard-input-data-in-gnuplot
# plot and draw lines http://stackoverflow.com/questions/16541040/how-do-i-use-gnuplot-to-plot-a-simple-2d-vector-arrow
# http://www.gnuplot.info/demo/arrowstyle.html
# plot labels (Ids) at point coords http://stackoverflow.com/questions/14608900/how-to-label-x-y-data-points-in-gnuplot-4-2-with-integer-numbers
# http://gnuplot.sourceforge.net/demo/datastrings.html
# arithmetic on columns (and fit to function) https://chemistry.osu.edu/~foster.281/gnuplot/gnuplot_tutorial3_files/gp_manip.html
# interpret as number and print string http://stackoverflow.com/questions/5242253/how-to-convert-integer-to-string-in-gnuplot

## call as 
## gnuplot -e "datafile='z-slice.lst';scale=0.331662" ~/gnuplot/lines.gpl

if (!exists("datafile")) datafile='default.dat'
if (!exists("scale")) scale=1.0 # http://gnuplot.sourceforge.net/docs_4.2/node60.html

set terminal svg enhanced font "arial,10" size 800,800 #with enhanced don't use: courier
set output "lines.svg"

set xrange [0:4336*scale]
set yrange [0:500*scale]
set size ratio -1

#set arrow from $1,0 to $1,100 nohead 
plot datafile using ($1*scale):(0):(0):(500*scale) notitle with vectors nohead lc 'black', \
     datafile using ($1*scale):(0):(sprintf("%5.2f", $1*scale)) notitle with labels center


