#!/bin/sh
. ./check-vars.sh
readonly result_file="result-1054322.tmp"
readonly tmpimg="1054322-1.out.jpg"

# Run this in the C locale so the messages are known
LANG=C; export LANG
LANGUAGE=C; export LANGUAGE

echo Remove thumbnail from 1054322 file
$EXIFEXE --remove-thumbnail --output "$tmpimg" "$SRCDIR"/1054322.jpg > ${result_file} 2>&1
result="`cat ${result_file}`"
s="$?"
echo "$result"
if echo "$result" | grep "The data supplied does not seem to contain EXIF data." > /dev/null; then
	:
elif test "$s" -eq 0; then
	echo "Exit code $s reading EXIF from an HTML file? That must be wrong."
	exit 1
else
	echo "Exit code $s"
	exit 1
fi
rm -f "$result_file" "$tmpimg"

echo Remove thumbnail from nonexistent file
$EXIFEXE --remove-thumbnail --output "$tmpimg" ./this-file-does-not-exist.jpg > ${result_file} 2>&1
result="`cat ${result_file}`"
s="$?"
echo "$result"
if echo "$result" | grep "does not contain EXIF data" > /dev/null; then
	:
elif test "$s" -eq 0; then
	echo "Exit code $s reading EXIF from a nonexisting file? That must be wrong."
	exit 1
else
	echo "Exit code $s"
	exit 1
fi

echo PASSED
rm -f "$result_file" "$tmpimg"
exit 0
