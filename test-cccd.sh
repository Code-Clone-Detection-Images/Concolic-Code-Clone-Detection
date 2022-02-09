#!/bin/sh

source /varsrc
source /varsrc-extra

echo " - Running first Test [$EXAMPLE]"

cd "$CCCD_DIRTY/bashScripts"

./cccd "$EXAMPLE"
cat "../sourceFiles/Reports/${EXAMPLE}_comparisionReport.csv" # jepp... a typo... great

# TODO: multiple source files => move source file extraction to highest level possible and remove test generation output from docker container build  after check
# Do this by directory binding which allows for custom files