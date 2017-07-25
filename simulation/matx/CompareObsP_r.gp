set xlabel "t[s]"
set ylabel "r[m]"
plot "CompareObs1.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "red" title "obs-p1 r"
replot "CompareObs2.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "obs-p2 r"
