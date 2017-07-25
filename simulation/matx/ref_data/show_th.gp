set xlabel 't[s]'
set ylabel 'th[rad]'
set xrange [0:15]
set yrange [-0.2:0.2]
set  terminal windows enhanced 1
plot "case3.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "red" title "Q1 th"
replot "case5.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "green" title "Q2 th"
replot "case11.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "blue" title "Q3 th"
