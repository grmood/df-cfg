#!/usr/bin/env bash

source "../exe.bashrc"

types=(info status ok fail warn err dbg item)

for t in "${types[@]}"
do
    EXE_DBG=y log $t "logging '$t' message";
done;
