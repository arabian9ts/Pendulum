set  terminal windows enhanced 0
plot "expK1E3N031.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "r1"
replot "expK1E4N031.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "r2"
replot "expK1E5N031.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "blue" title "r3"
set  terminal windows enhanced 1
plot "expK1E3N031.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "red" title "th1"
replot "expK1E4N031.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "green" title "th2"
replot "expK1E5N031.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "blue" title "th3"
