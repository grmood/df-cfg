#!/usr/bin/env bash

ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- make -j$(nproc) $@
