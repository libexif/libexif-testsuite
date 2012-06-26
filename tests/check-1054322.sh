#!/bin/sh
. ./check-vars.sh
result_file="result-1054322-1.tmp"
env LANG=C LANGUAGE=C $EXIFEXE --remove-thumbnail --output ./1054322-1.out.jpg "$SRCDIR"/1054322.jpg > ${result_file} 2>&1
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
rm -f "$result_file"

result_file="result-1054322-2.tmp"
env LANG=C LANGUAGE=C $EXIFEXE --remove-thumbnail --output ./1054323-2.out.jpg ./this-file-does-not-exist.jpg > ${result_file} 2>&1
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
rm -f "$result_file"

exit 0
