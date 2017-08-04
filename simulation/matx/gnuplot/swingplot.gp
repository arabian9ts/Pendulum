set  terminal windows enhanced 0
plot "k1e4n025taki.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "swing r"
replot "k1e3n025taki.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "swing r2"
replot "k1e2n025taki.mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "blue" title "swing r3"
set  terminal windows enhanced 1
plot "k1e4n025taki.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "red" title "swing th"
replot "k1e3n025taki.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "green" title "swing th2"
replot "k1e2n025taki.mat" using 1:4 with lines linewidth 2 linecolor rgbcolor "blue" title "swing th3"
