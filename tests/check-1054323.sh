#!/bin/sh
. check-vars.sh
set -x
# -d flag turns a Corrupt Data error into a warning
"$EXIFEXE" -d -r -o ./1054323.out.jpg "$SRCDIR"/1054323.jpg >/dev/null
s="$?"
rm -f ./1054323.out.jpg
exit "$s"
