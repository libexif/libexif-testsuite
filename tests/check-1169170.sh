#!/bin/sh
. ./check-vars.sh

echo Check that showing tags on a corrupted file fails
if $EXIFEXE "$SRCDIR/images/canon-powershot-a400-001.jpg" > /dev/null 2>&1; then
	echo "This should have failed."
	exit 1
fi

echo Check that showing MakerNote tags on a corrupted file fails
if $EXIFEXE --show-mnote "$SRCDIR/images/canon-powershot-a400-001.jpg" > /dev/null 2>&1; then
	echo "This should have failed."
	exit 1
fi

$EXIFEXE "$SRCDIR/images/canon-powershot-g2-001.jpg" > /dev/null 2>&1 || exit $?
$EXIFEXE --show-mnote "$SRCDIR/images/canon-powershot-g2-001.jpg" > /dev/null 2>&1 || exit $?

echo PASSED
