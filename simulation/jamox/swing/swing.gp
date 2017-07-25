set  terminal windows enhanced 0
plot "k1000n075.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "swing r"
replot "expK1E3n075.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "sim r"
set  terminal windows enhanced 1
plot "k1000n075.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "red" title "swing th"
replot "expK1E3n075.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "sim th"
