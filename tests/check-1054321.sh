#!/bin/sh
. ./check-vars.sh
readonly result_file="result-1054321.tmp"
$EXIFEXE -m -o ./1054321.out.jpg "$SRCDIR"/1054321.jpg > "$result_file" 2>&1
s="$?"
tail "$result_file"

rm -f "$result_file"
exit "$s"
