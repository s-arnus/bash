#!/bin/bash
#Solutions to exercises From a Coursera course "The Unix Workbench" - Johns Hopkins University
#Write a function called plier which multiplies together a sequence of numbers.
function plier {
	local sum=1
	for element in $@
	do
		let sum=$(echo "$(($sum * $element))")
	done
	echo $sum
}

#Write a function called isiteven that prints 1 if a number is even or 0 a number is not even.
function isiteven {
	if [ $(($1%2)) -eq 0 ]
	then
		echo "1"
	else
		echo "0"
	fi
}

#Write a function called nevens which prints the number of even numbers when provided with a sequence of numbers. Use isiteven when writing this function.
function nevens {
	local even=()
	for nr in $@
	do
		if [[ $(isiteven $nr) -eq 1 ]]
		then
			even+=($nr)
		fi
	done
	echo ${even[*]}
}

#Write a function called howodd which prints the percentage of odd numbers in a sequence of numbers. Use nevens when writing this function.
function howodd {
	count=0
	for item in $(nevens $@)
	do
		let count=$count+1
	done
	even=$count
	total=$#
	odd=$(expr $total - $even)

	percentage=$((100*$odd/$total | bc -l))

	echo "Total $total"
	echo "Even $even"
	echo "Odd $odd"
	echo "Percentage $percentage"
}

#Write a function called fib which prints the number of fibonacci numbers specified.
function fib {
	count=0
	fibon=(0 1)
	while [ $count -le $1 ]
	do
		if [[ $count -gt 1 ]]
		then
      			#If only first number is needed
			if [[ $1 -eq 0 ]]
			then
				echo "Fibon 0 is ${fibon[$count]}"
			#Else if only two numbers are needed
			elif [[ $1 -eq 1 ]]
			then
				echo "Fibon 1 is ${fibon[$count]}"
			#Else add new fibonacci number to the array
			else
				rev=$(expr $count - 1)
				prev2=$(expr $count - 2)
				new=$(expr ${fibon[$prev]} + ${fibon[$prev2]})
				fibon+=($new)
		      	fi
		fi
		let count=$count+1
	done
	echo ${fibon[*]:0:$1}
}
