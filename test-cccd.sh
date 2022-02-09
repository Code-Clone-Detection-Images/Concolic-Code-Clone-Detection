#!/bin/sh

source /varsrc


echo " - Running first Test [$EXAMPLE]"

cd "$CCCD_DIRTY/bashScripts"

./cccd "$EXAMPLE"
cat "reports/$EXAMPLE.csv"
