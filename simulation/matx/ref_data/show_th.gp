set xlabel 't[s]'
set ylabel 'th[rad]'
set xrange [0:15]
set yrange [-0.2:0.2]
set  terminal windows enhanced 1
plot "case1.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "red" title "dt1 th"
replot "case3.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "green" title "dt2 th"
