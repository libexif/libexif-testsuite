#!/bin/sh
. ./check-vars.sh
if test -x "$EXIFEXE"; then
	echo "exif executable \`$EXIFEXE' is executable. Good."
	ls -l "$EXIFEXE"
else
	echo "exif executable \`$EXIFEXE' is NOT executable. Bad."
	ls -l "$EXIFEXE"
	exit 1
fi
