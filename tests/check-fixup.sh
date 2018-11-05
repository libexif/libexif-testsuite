#!/bin/sh
# Tests the fixup of tag data from the wrong type into the correct type.
# The file wrong-format.jpg contains many tags that have many different,
# incorrect, data types, which are converted into the correct data types
# by libexif.

. ./check-vars.sh

readonly srcimg="$SRCDIR/wrong-format.jpg"
readonly dstimg="fixup.out.jpg"
readonly tmpfile="check-fixup.tmp"

# Run this in the C locale so the messages are known
LANG=C; export LANG
LANGUAGE=C; export LANGUAGE

# Abort on any command failure
set -e

echo Fix up data
# Use --remove of a nonexistent tag to force a rewrite of the file
$EXIFEXE -o "$dstimg" --remove --tag=0xbeef "$srcimg"

# Check the resulting EXIF file
$EXIFEXE -m -i "$dstimg" >"$tmpfile"
"$DIFFEXE" - "$tmpfile" <<EOF
0x0112	Left-bottom
0x011a	72
0x011b	72
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

echo PASSED
rm -f "$dstimg" "$tmpfile"
