#!/bin/sh
# Tests removal of existing tags.
# Tags within each sub-IFD are tested. Boundary conditions such as removing
# all tags within a sub-IFD, and all tags in file are also tested.

. ./check-vars.sh

originalimg="$SRCDIR/images/canon-powershot-g2-001.jpg"
srcimg="remove-tag-src.out.jpg"
dstimg="remove-tag.out.jpg"

append_image () {
	if [ -e "$dstimg" ] ; then
		mv -f "$dstimg" "$srcimg"
	fi
}

count_tags () {
	"$EXIFEXE" --no-fixup -m -i "$@" | grep '^0x' | wc -l
}

count_maker_tags () {
	env LANG=C LANGUAGE=C "$EXIFEXE" --no-fixup -m -i --show-mnote "$@" | grep "	" | wc -l
}

# Abort on any command failure
set -e

cp "$originalimg" "$srcimg"

# Count the number of tags
numtags=`count_tags "$srcimg"`
echo Starting with $numtags tags in the file
test "$numtags" -eq 46

nummaker=`count_maker_tags "$srcimg"`
echo and 78 MakerNote tags: $nummaker
test "$nummaker" -eq 78

# Remove tags in the order in which they appear in the IFD
TESTTAGS_Interoperability="0x0001 0x0002 0x1001 0x1002"
ifd=Interoperability
for tag in $TESTTAGS_Interoperability; do
	"$EXIFEXE" --no-fixup --tag=$tag --ifd=$ifd --remove -o "$dstimg" "$srcimg" >/dev/null
	append_image
done

numtags=`count_tags "$srcimg"`
echo Must be 42 tags remaining: $numtags
test "$numtags" -eq 42

nummaker=`count_maker_tags "$srcimg"`
echo and 78 MakerNote tags: $nummaker
test "$nummaker" -eq 78

# Remove tags in the reverse order in which they appear in the IFD
TESTTAGS_1="0x0128 0x011b 0x011a 0x0103"
ifd=1
for tag in $TESTTAGS_1; do
	"$EXIFEXE" --no-fixup --tag=$tag --ifd=$ifd --remove -o "$dstimg" "$srcimg" >/dev/null
	append_image
done

numtags=`count_tags "$srcimg"`
echo Must be 38 tags remaining: $numtags
test "$numtags" -eq 38

nummaker=`count_maker_tags "$srcimg"`
echo and 78 MakerNote tags: $nummaker
test "$nummaker" -eq 78

# Remove all tags in the 0 IFD (including the Make tag), leaving no tags
# except the EXIF sub-IFD tags
TESTTAGS_0="0x010f 0x0110 0x0112 0x011a	0x011b 0x0128 0x0132 0x0213"
ifd=0
for tag in $TESTTAGS_0; do
	"$EXIFEXE" --no-fixup --tag=$tag --ifd=$ifd --remove -o "$dstimg" "$srcimg" >/dev/null
	append_image
done

numtags=`count_tags "$srcimg"`
echo Must be 30 tags remaining: $numtags
test "$numtags" -eq 30

# Without the Make tag, the Canon MakerNote can't be decoded
nummaker=`count_maker_tags "$srcimg"`
echo and 0 MakerNote tags: $nummaker
test "$nummaker" -eq 0

# Remove all tags in the EXIF IFD (including MakerNote), leaving no tags at all
TESTTAGS_EXIF="0x829a 0x829d 0x9000 0x9003 0x9004 0x9101 0x9102 0x9201 0x9202 0x9204 0x9205 0x9207 0x9209 0x920a 0x927c 0x9286 0xa000 0xa001 0xa002 0xa003 0xa20e 0xa20f 0xa210 0xa217 0xa300 0xa401 0xa402 0xa403 0xa404 0xa406"
ifd=EXIF
for tag in $TESTTAGS_EXIF; do
	"$EXIFEXE" --no-fixup --tag=$tag --ifd=$ifd --remove -o "$dstimg" "$srcimg" >/dev/null
	append_image
done

numtags=`count_tags "$srcimg"`
echo Must be 0 tags remaining: $numtags
test "$numtags" -eq 0

nummaker=`count_maker_tags "$srcimg"`
echo and 0 MakerNote tags: $nummaker
test "$nummaker" -eq 0

rm -f "$srcimg" "$dstimg"
