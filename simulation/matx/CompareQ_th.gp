set xlabel "t[s]"
set ylabel "th[rad]"
set yrange [-0.175:0.175]
plot "CompareQ(6500).mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "Q1 th"
replot "CompareQ(5600).mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "Q2 th"
replot "CompareQ(6600).mat" using 1:3 with lines linewidth 2 linecolor rgbcolor "blue" title "Q3 th"
