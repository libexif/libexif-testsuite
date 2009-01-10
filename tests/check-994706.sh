#!/bin/sh
. check-vars.sh
bug="994706"
srcimg="$SRCDIR/images/canon-powershot-g2-001.jpg"
dstimg="./${bug}.jpg.modified.jpeg"

# Remove Maker Note
echo "Removing EXIF Maker Note"
"$EXIFEXE" "--ifd=EXIF" "--tag=MakerNote" --remove --output "$dstimg" "$srcimg" > /dev/null 2>&1

# List all tags
env LANG=C LANGUAGE=C "$EXIFEXE" --list-tags "$srcimg" | sed '1d' > "./check-${bug}.src.txt"
env LANG=C LANGUAGE=C "$EXIFEXE" --list-tags "$dstimg" | sed '1d' > "./check-${bug}.dst.txt"

# Find different tags in source and destination image
"$DIFFEXE" -u "./check-${bug}.src.txt" "./check-${bug}.dst.txt" > "./check-${bug}.a.patch"

# Canonicalize diff files
sed '1,3 d' <        "./check-${bug}.a.patch" > "./check-${bug}.a.xpatch"
sed '1,3 d' < "$SRCDIR/check-${bug}.b.patch" > "./check-${bug}.b.xpatch"

# Compare diff files; they should be equal.
"$DIFFEXE" -u "./check-${bug}.a.xpatch" "./check-${bug}.b.xpatch"
s="$?"
if test "$s" -ne 0; then
	echo "The Maker Note should have been removed. Bad."
fi

rm -f "$dstimg" "./check-${bug}.src.txt" "./check-${bug}.dst.txt" "./check-${bug}.a.patch" "./check-${bug}.a.xpatch" "./check-${bug}.b.xpatch"

exit "$s"
