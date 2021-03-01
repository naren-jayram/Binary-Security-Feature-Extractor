#!/bin/bash

echo -e "Do you want to know the security attributes associated with the binaries? l=Linux binaries w=Windows binaries\n"
echo -e "Please let me know the binary type you are interested in?"  
read  user_input

grep_binaries()
{
	# find -type f -executable -exec file -i '{}' \; | grep 'x-executable; charset=binary'		//This detects only 32 bit elf
	# find . -type f -exec grep -IL . "{}" \;
	# OR
	find . -type f | perl -lne 'print if -B' |tee binaries-list.txt
	input="binaries-list.txt"
}

if [ "$user_input" == "l" ]
then
	grep_binaries
	while IFS= read -r line
	do
		echo -e "${line}" >> Results.txt 
		checksec $line >> Results.txt 2>&1
		echo -e "\n" >> Results.txt
	done < "$input"

elif [ "$user_input" == "w" ]
then
	grep_binaries
	path_name='Execution Path: '
	dir=$(pwd)
	path="${path_name}${dir}"
	echo -e "${path} \n" >> Results.txt

	while IFS= read -r line
	do
		echo -e "${line} \n" >> Results.txt 
		./winchecksec $line >> Results.txt
	done < "$input"

else
	echo -e "Invalid input. Please try again... \n"
	exit 0
fi