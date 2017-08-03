load "setFont.gp"
set xlabel 't[s]'
set ylabel 'dr[m/s]'
set xrange [0:15]
set  terminal windows enhanced 0
plot "CalcError_obs1.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "red" title "error1 dr"
replot "CalcError_obs2.mat" using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "error2 dr"
