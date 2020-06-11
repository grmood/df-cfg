#!/usr/bin/env bash

uri="$sp1host:/root"

./forget-sp.sh
rsync -av ./* $uri
rsync -av ./.bashrc $uri

#scp ./.bashrc ./* $sp1host:/root/

