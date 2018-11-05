#!/bin/sh
. ./check-vars.sh
readonly bug="994706"
readonly srcimg="$SRCDIR/images/canon-powershot-g2-001.jpg"
readonly dstimg="${bug}.out.jpg"

# Run this in the C locale so the messages are known
LANG=C; export LANG
LANGUAGE=C; export LANGUAGE

echo "Removing EXIF Maker Note"
$EXIFEXE "--ifd=EXIF" "--tag=MakerNote" --remove --output "$dstimg" "$srcimg" > /dev/null 2>&1
test "$?" -eq 0

$EXIFEXE --list-tags --width=80 "$srcimg" | sed '1d' > "./check-${bug}.src.tmp"
$EXIFEXE --list-tags --width=80 "$dstimg" | sed '1d' > "./check-${bug}.dst.tmp"

# Find different tags in source and destination image
"$DIFFEXE" -u "./check-${bug}.src.tmp" "./check-${bug}.dst.tmp" > "./check-${bug}.a.patch.tmp"

# Canonicalize diff files
sed '1,3 d' <        "./check-${bug}.a.patch.tmp" > "./check-${bug}.a.xpatch.tmp"
sed '1,3 d' < "$SRCDIR/check-${bug}.b.patch" > "./check-${bug}.b.xpatch.tmp"

# Compare diff files; they should be equal.
"$DIFFEXE" -u "./check-${bug}.a.xpatch.tmp" "./check-${bug}.b.xpatch.tmp"
s="$?"
if test "$s" -ne 0; then
	echo "The Maker Note should have been removed. Bad."
fi

rm -f "$dstimg" "./check-${bug}.src.tmp" "./check-${bug}.dst.tmp" "./check-${bug}.a.patch.tmp" "./check-${bug}.a.xpatch.tmp" "./check-${bug}.b.xpatch.tmp"

exit "$s"
