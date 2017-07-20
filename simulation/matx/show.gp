load "setFont.gp"
filename_l = sprintf("%s.mat",lname)
filename_s = sprintf("%s.mat",sname)
set xlabel 't[s]'
set ylabel 'r[m]'
set  terminal windows enhanced 0
plot filename_l using 1:3 with lines linewidth 2 linecolor rgbcolor "red" title "actual r"
replot filename_s using 1:2 with lines linewidth 2 linecolor rgbcolor "green" title "sim r"
set xlabel 't[s]'
set ylabel 'th[rad]'
set  terminal windows enhanced 1
plot filename_l using 1:4 with lines linewidth 2 linecolor rgbcolor "red" title "actual th"
replot filename_s using 1:3 with lines linewidth 2 linecolor rgbcolor "green" title "sim th"
