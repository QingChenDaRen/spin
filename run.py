import subprocess

#ls = ['2.txt' , '3.txt']


#xspec<<EOF
#source modelspin_singlepcu_m2l_relxil.tcl 
#myfit $i
#EOF

cmds = ['xspec<<EOF', 
	#'source modelspin_singlepcu_m2l_relxil.tcl', 
	'EOF']

process = subprocess.Popen(cmds, stdout=subprocess.PIPE)
for line in process.stdout:
    print(line)
    #process.stdin.write("\n")
