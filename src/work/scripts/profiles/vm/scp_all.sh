#!/usr/bin/env bash

source $work/utils.sh

ssh_spforget

rsync -av ./* $uri
rsync -av ./.??* $uri

#scp ./.bashrc ./* $sp1host:/root/

