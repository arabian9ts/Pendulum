set xlabel 't[s]'
set ylabel 'r[m]'
set xrange [0:15]
set yrange [-0.1:0.2]
set  terminal windows enhanced 1
plot "case3.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "Q1 r"
replot "case5.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "Q2 r"
replot "case11.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "blue" title "Q3 r"
