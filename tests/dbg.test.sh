#!/usr/bin/env bash

source "../exe.bashrc"

types=(info status ok fail warn err dbg list item)

EXE_DBG=y dbg "types: ${types[*]}"

for t in "${types[@]}"
do
    EXE_DBG=y log $t "'$t' message";
done;
