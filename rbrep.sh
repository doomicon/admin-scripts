#!/bin/bash

file="$1"

if [ -f "$file" ]

	then 
		sed -i 's/\/home\/rowens\/.rvm\//\/usr\/share\/ruby-rvm\//g' $file

	else
		echo "File Arg needed"

fi
