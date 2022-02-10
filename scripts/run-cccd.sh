#!/bin/sh
source /varsrc
echo "[Running] [$1]"

cd "$CCCD_DIRTY/bashScripts"

./cccd "$1"

OUTPUT_FILENAME=$(tail --lines=1 ../src/cccd-run.log)
OUTPUT_FILENAME="$(pwd)/${OUTPUT_FILENAME/See Report at: /}"
echo "[Done] Analyze \"$OUTPUT_FILENAME\""
echo "$OUTPUT_FILENAME"