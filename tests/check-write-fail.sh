#!/bin/sh
# Check that exif properly detects an unwritable file

. check-vars.sh

tmpfile="./output.tmp"

# Run this in the C locale so the messages are known
export LANG=C
export LANGUAGE=C

failed="0"

touch "$tmpfile"
chmod 444 "$tmpfile"
$EXIFEXE --create-exif --extract-thumbnail -o "$tmpfile" "$SRCDIR/images/canon-powershot-g2-001.jpg"
test $? -eq 1 || exit 1
s="$?"
rm -f "$tmpfile"
exit "$s"
