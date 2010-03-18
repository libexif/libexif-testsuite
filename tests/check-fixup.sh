#!/bin/sh
# Tests the fixup of tag data from the wrong type into the correct type.
# The file wrong-format.jpg contains many tags that have many different,
# incorrect, data types, which are converted into the correct data types
# by libexif.

. check-vars.sh

srcimg="$SRCDIR/wrong-format.jpg"
dstimg="./fixup.out.jpg"
tmpfile="output.tmp"

# Abort on any command failure
set -e

echo Fix up data
# Use --remove of a nonexistent tag to force a rewrite of the file
"$EXIFEXE" -o "$dstimg" --remove --tag=0xbeef "$srcimg"

# Check the resulting EXIF file
env LANG=C LANGUAGE=C "$EXIFEXE" -m -i "$dstimg" >"$tmpfile"
"$DIFFEXE" "$tmpfile" - <<EOF
0x0112	Left-bottom
0x011a	72.00
0x011b	72.00
0x011c	Planar format
0x0128	Inch
0x0132	2009:12:16 23:30:32
0x0213	Centered
0x829a	1/2 sec.
0x9000	Exif Version 2.1
0x9101	Y Cb Cr -
0x9201	0.04 EV (1/1 sec.)
0x9286	Missing the character set
0xa000	FlashPix Version 1.0
0xa001	sRGB
0xa002	64
0xa003	64
0xa403	Manual white balance
0xa406	Night scene
EOF

rm -f "$dstimg" "$tmpfile"
