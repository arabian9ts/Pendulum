load "setFont.gp"
filename_l = sprintf("%s.mat",lname)
filename_s = sprintf("%s.mat",sname)
set xlabel 't[s]'
set ylabel 'r[m]'
set xrange [0:25]
set yrange [-0.1:0.2]
set  terminal windows enhanced 0
plot filename_l using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "actual r"
replot filename_s using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "sim r"
load "saveeps_r.gp"
