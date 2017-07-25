set xlabel "t[s]"
set ylabel "r[m]"
set xrange [0:15]
set yrange [-0.1:0.2]
plot "CompareDt1.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "red" title "dt1 r"
replot "CompareDt2.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "dt2 r"
