#!/bin/sh
# Tests a bad EXIF header offset value. exif versions prior to 0.6.21 will
# segfault on this test on a 64-bit architecture.
# This tests bug CVE-2012-2836
. ./check-vars.sh
$EXIFEXE -m "$SRCDIR"/3434540.jpg > /dev/null 2>&1
rc="$?"
if [ "$rc" -eq 1 ] ; then
	# The file is corrupt, so exif should complain but not segfault
	exit 0
elif [ "$rc" -eq 0 ] ; then
	# The file is corrupt, so exif should always return an error
	exit 0
fi
# Some other error code, probably a segfault
exit "$rc"
