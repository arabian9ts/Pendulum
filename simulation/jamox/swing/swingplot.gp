set xrange [0:5]
set grid
set  terminal windows enhanced 0
plot "K1E3N031.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "red" title "sim r1"
replot "K1E4N031.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "sim r2"
replot "K1E5N031.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "blue" title "sim r3"
set  terminal windows enhanced 1
plot "K1E3N031.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "sim th1"
replot "K1E4N031.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "sim th2"
replot "K1E5N031.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "blue" title "sim th3"
