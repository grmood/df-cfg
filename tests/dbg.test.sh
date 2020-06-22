#!/usr/bin/env bash

source "../exe.bashrc"

types=(info status ok fail warn err dbg list item)

for t in "${types[@]}"
do
	echo "Test type: $t" 
    EXE_DBG=y log $t "'$t' message";
done;
