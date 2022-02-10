#!/bin/sh
source /varsrc

echo " - Running first Test [$TEST_NAME]"

OUTPUT_FILENAME=$(/run-cccd.sh "$TEST_NAME" | tail --lines=1 -)

echo "validate test results..."
python3 /validate-test.py /kraw-expected.csv "$OUTPUT_FILENAME"

# TODO: multiple source files => move source file extraction to highest level possible and remove test generation output from docker container build  after check
# Do this by directory binding which allows for custom files
# TODO: move up the args from varsrc to dockerfile to allow for more offline files