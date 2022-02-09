#!/bin/sh

source /varsrc
source /varsrc-extra

echo " - Running first Test [$TEST_NAME]"

cd "$CCCD_DIRTY/bashScripts"

./cccd "$TEST_NAME"

# cat "../sourceFiles/Reports/${TEST_NAME}_comparisionReport.csv" # jepp... a typo... great
echo "validate test results..."
python3 /validate-test.py /kraw-expected.csv "../sourceFiles/Reports/${TEST_NAME}_comparisionReport.csv"

# TODO: automatically grep which file to cat for the test-cccd.sh script by using output of cccd (java call)

# TODO: multiple source files => move source file extraction to highest level possible and remove test generation output from docker container build  after check
# Do this by directory binding which allows for custom files
# TODO: move up the args from varsrc to dockerfile to allow for more offline files