### gnuplot script to create overlays on an image

if (!exists("datafiles")) datafiles='default.png default.dat' # http://gnuplot.sourceforge.net/docs_4.2/node60.html
if (!exists("outfile")) outfile='imgOV.svg' # use ARG0."svg" for gp-5:  http://stackoverflow.com/questions/12328603/how-to-pass-command-line-argument-to-gnuplot#31815067
if (!exists("xmax")) xmax=10
if (!exists("ymax")) ymax=10

imgfile= word(datafiles,1)
datfile= word(datafiles,2)
polydat= word(datafiles,3)

set size ratio -1
set xrange [0:xmax]
set yrange [0:ymax]

unset border
unset xtics
unset ytics

set terminal svg enhanced font "sans,10" size xmax,ymax #don't use: courier or arial
set output outfile

plot \
     imgfile binary filetype=png w rgbimage ti '' , \
     datfile u ($1/8):(ymax-$2/8) pointtype 2 pointsize 3 lc 'yellow' ti '' , \
     datfile u ($1/8):(ymax-$2/8):($0+1) w labels left offset 1 textcolor 'yellow' font "sans,40" notitle , \
     polydat u 1:(ymax-$2) w lines lc 'yellow' lw 3 ti '' # http://stackoverflow.com/questions/29015920/gnuplot-draw-polygon-from-data
