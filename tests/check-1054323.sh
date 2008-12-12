#!/bin/sh
. check-vars.sh
set -x
"$EXIFEXE" -r -o ./1054323.out.jpg "$SRCDIR"/1054323.jpg
