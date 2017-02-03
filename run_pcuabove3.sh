N=1

while read line
do 

obsname=`echo ${line} | awk '{print $1}'`
String=`echo ${line} | awk '{print $2}'`
StringLength=`echo ${line} | awk '{print $2}' | awk '{print length}'`

#echo $StringLength

if [ "$StringLength" -gt 2 ]
then
	echo "$String"

#	for (( i=0; i<${#String}; i++ )); do
       for (( i=0; i<${StringLength}; i++ )); do
  		echo "${String:$i:1}"
  		pcunum[${i}]="${String:$i:1}" 
	done

#xspec<<EOF

#source modelspin_multipcu_TEST_m2l.tcl
#myfit ${obsname} [list ${pcunum[*]}]

#EOF

xspec<<EOF

source modelspin_multipcu_TEST_m2h.tcl
myfit ${obsname} [list ${pcunum[*]}]

EOF

unset pcunum

N=$((N+1))

else
	echo "Short"
fi

#done < numpcu_obs_hard.ls
#done < numpcu_obs_hard_relxill.ls
done < test_multiple.ls
