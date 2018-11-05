#!/bin/sh
# Check that exif properly detects an unwritable file

. ./check-vars.sh

readonly tmpfile="write-fail.tmp"

# Run this in the C locale so the messages are known
LANG=C; export LANG
LANGUAGE=C; export LANGUAGE

failed="0"

touch "$tmpfile"
chmod 444 "$tmpfile"
$EXIFEXE --create-exif --extract-thumbnail -o "$tmpfile" "$SRCDIR/images/canon-powershot-g2-001.jpg"
test $? -eq 1 || exit 1
s="$?"

rm -f "$tmpfile"
exit "$s"
