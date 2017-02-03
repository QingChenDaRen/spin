N=1

for i in `cat test_single.ls`
do

xspec<<EOF

source modelspin_singlepcu_m2h.tcl
myfit $i

EOF

# Count
N=$((N+1))

done
