#!/bin/sh
source /varsrc
echo "[Running] [$1]"

cd "$CCCD_DIRTY/bashScripts"

# copy source code to test to location
echo "[Running] Copy File to \"$CCCD_INPUT\""

# we do not care if cp fails, if so it may be the same folder
cp --update --recursive "$1" "$CCCD_INPUT" || true
OUTPUT_BASENAME=$(basename "$1")
./cccd "$OUTPUT_BASENAME"

echo ../src/cccd-run.log

OUTPUT_FILENAME=$(tail --lines=1 ../src/cccd-run.log)
OUTPUT_FILENAME="$(pwd)/${OUTPUT_FILENAME/See Report at: /}"
echo "[Done] Analyze \"$OUTPUT_FILENAME\""
# extract file name (NOTE: input should be folder)
cp --update "$OUTPUT_FILENAME" "$1" || true

# this is the return value of the script:
echo "$OUTPUT_FILENAME"