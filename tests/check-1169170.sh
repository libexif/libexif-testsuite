#!/bin/sh
. ./check-vars.sh
if "$EXIFEXE" "$SRCDIR/images/canon-powershot-a400-001.jpg" > /dev/null 2>&1; then
	echo "This should have failed."
	exit 1
fi

if "$EXIFEXE" --show-mnote "$SRCDIR/images/canon-powershot-a400-001.jpg" > /dev/null 2>&1; then
	echo "This should have failed."
	exit 1
fi

"$EXIFEXE" "$SRCDIR/images/canon-powershot-g2-001.jpg" > /dev/null 2>&1 || exit $?
"$EXIFEXE" --show-mnote "$SRCDIR/images/canon-powershot-g2-001.jpg" > /dev/null 2>&1 || exit $?

exit 0
