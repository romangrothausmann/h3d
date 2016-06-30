### gnuplot script to create a histogram with abs. and rel. scale and kernel-density plot

if (GPVAL_VERSION < 5.0) {print "This script needs gnuplot-5.x\n"; exit;}

if (!exists("datafile")) datafile='default.dat' # http://gnuplot.sourceforge.net/docs_4.2/node60.html
if (!exists("outfile")) outfile='hist-ar+kd.svg' # use ARG0."svg" for gp-5:  http://stackoverflow.com/questions/12328603/how-to-pass-command-line-argument-to-gnuplot#31815067
if (!exists("xlabel")) xlabel='UNSPECIFIED'
if (!exists("bin")) bin=17
if (!exists("sigma")) sigma=0
if (!exists("xmin")) xmin=0
if (!exists("xmax")) xmax=180
if (!exists("col")) col='interplanarAngles' # http://stackoverflow.com/questions/16089301/how-do-i-set-axis-label-with-column-header-in-gnuplot#18309074
if (!exists("sep")) sep=whitespace

set datafile separator sep

set samples 1000
set boxwidth bin # very important! see "gnuplot in action" p. 257
bin (x,s)= s* int(x/s)
binc(x,s)= s* (int(x/s) + .5)
binl(x,s)= s* ceil(x/s)
binr(x,s)= s* floor(x/s)

stats datafile u col nooutput # sets e.g. STATS_records

###first do a dummy plot to determin chosen y-range;-)
set xrange [xmin:xmax]
set term dumb
plot datafile u (binc(column(col), bin)):(1. / bin / STATS_records) smooth frequency with boxes ti sprintf("%d values (rel. freq)", STATS_records)
###y-range is now: GPVAL_Y_MAX or use GPVAL_DATA_Y_MAX
print GPVAL_Y_MAX, GPVAL_DATA_Y_MAX


## negative range for scattered points: http://www.gnuplot.info/demo/smooth.html
set yrange  [-0.0006:GPVAL_Y_MAX] # or [0:GPVAL_DATA_Y_MAX], without some small boxes might vanish!
set y2range [-0.0006 * bin * STATS_records:GPVAL_Y_MAX * bin * STATS_records] #scale yrange to make y2range graph (abs) coincide with relative

set title "kernel-density, relative and absolut frequency plot"
set xlabel xlabel
set ylabel  "rel. frequency"
set y2label "abs. frequency"
set y2tics
set ytics nomirror

set terminal svg enhanced font "arial,10" size 800,600 #with enhanced don't use: courier
set output outfile

set style fill transparent solid .7

set style line 1 dt 4 lc rgb "#11000000" lw 2
set style line 2 dt 1 lc rgb "#00ff00"
set style line 3 dt 1 lc rgb "#0000ff"

set style circle radius 1.1 # http://stackoverflow.com/questions/34532568/gnuplot-how-to-make-scatter-plots-with-transparent-points#34533791

## gp-4.6: kdensity with filledcurves gets accepted but does not work (http://gnuplot.sourceforge.net/demo_cvs/violinplot.html)
plot \
     "" u col:(0.0002*rand(0)-.00045) with circles fs fill transparent solid 0.35 noborder lc 'black' t '', \
     "" u (binc(column(col), bin)):(1) axes x1y2 smooth frequency with boxes ti sprintf("%d values (abs. freq)", STATS_records) ls 3 , \
     "" u (binc(column(col), bin)):(1. / bin / STATS_records) smooth frequency with boxes fs empty ti "(rel. freq)" ls 1 , \
     "" u col:(1. / STATS_records) smooth kdensity bandwidth sigma with filledcurves above y1 ti sprintf("kdensity ({/symbol s}= %2.1f; rel. freq)", sigma) ls 2 # for gp-5.x
#     "" u col:(1. / STATS_records):(sigma) smooth kdensity ti sprintf("kdensity ({/symbol s}= %2.1f; rel. freq)", sigma) ls 2 # gp<5: 3rd u-value is used but warning issued: extra columns ignored by smoothing option
