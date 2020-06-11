#!/usr/bin/env bash

./forget-sp.sh
scp ./.bashrc ./* root@$p3vm1:/root/

