#!/bin/sh
source /varsrc

echo " - Running first Test [$TEST_NAME]"

OUTPUT_FILENAME=$(/run-cccd.sh "$TEST_NAME" | tail --lines=1 -)

echo "validate test results... [$OUTPUT_FILENAME]"
python3 /validate-test.py /kraw-expected.csv "$OUTPUT_FILENAME"

# as it turns out, cccd only offers one information: < 35, howeversome others use 40
# https://dl.acm.org/doi/pdf/10.1145/2597073.2597127 use increments of 10 from 0 to 40

echo "erase test source files to keep container runnable"
rm -rf "$CCCD_INPUT/$TEST_NAME"

# TODO: multiple source files => move source file extraction to highest level possible and remove test generation output from docker container build  after check
# Do this by directory binding which allows for custom files
# TODO: move up the args from varsrc to dockerfile to allow for more offline files