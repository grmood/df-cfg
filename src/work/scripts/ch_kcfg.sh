#!/usr/bin/env bash

PARAM="$1"
VALUE="$2"
FILE="$3"
SED_STR='/'"$PARAM=/c"'\'"$PARAM=$VALUE"

sed -i $SED_STR $FILE
