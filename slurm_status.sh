#!/bin/bash
linetoshow=10
user=$USER
while getopts ":n:u:" opt
do
 	case $opt in
		n)
			linetoshow=${OPTARG}
		;;
		u)
			user=${OPTARG}
		;;
		\?)
			echo "Only -u (user) and -n (lines to show) are supported"
      		;;
  	esac
done

echo "Jobs running for $user:"
jobids=$(squeue -u $user | awk -F ' ' 'NR > 1 {print $1}')
getstdout () {
	echo $1 | xargs -n1 scontrol show job | grep -oh "StdOut=[^ ]*" | sed "s/StdOut=//g"
}
for id in $jobids
do 
	file=$(getstdout $id)
	echo "Job ID: $id"
	echo "Output file: $file"
	echo "----------------"
	cat $file | tail -n $linetoshow
	printf "\n"
done
