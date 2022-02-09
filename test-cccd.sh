#!/bin/sh

source /varsrc
source /varsrc-extra

echo " - Running first Test [$EXAMPLE]"

cd "$CCCD_DIRTY/bashScripts"

./cccd "$EXAMPLE"
cat "../sourceFiles/Reports/${EXAMPLE}_comparisionReport.csv" # jepp... a typo... great
