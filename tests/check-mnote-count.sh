#!/bin/sh
# Count the number of MakerNotes that can be parsed

. check-vars.sh

# Run this in the C locale so the messages are known
export LANG=C
export LANGUAGE=C 

tmpfile="./log.tmp"
: >"$tmpfile"

total=0
total_img=0
maker_img=0

for img in $ALLFILES
do
	test -f "$img" || continue

	total_img=$(expr $total_img + 1)

	# Test images without EXIF tags
	if noexiftags "$img" ; then
		#echo No EXIF tags in "$img"
		continue
	fi

	if ! $EXIFEXE -m --ifd=EXIF --tag=MakerNote "$img" >/dev/null 2>&1 ; then
		#echo No MakerNote tag in "$img"
		continue
	fi

	maker_img=$(expr $maker_img + 1)

	$EXIFEXE --show-mnote "$img" | grep 'MakerNote contains' >/dev/null
	s="$?"
	if test "$s" -eq 0; then
		total=$(expr $total + 1)
		#echo MakerNote understood in "${img}"
		$EXIFEXE --show-mnote -d "$img" | grep 'MakerNote variant' >>"$tmpfile"

	else
		echo Cannot understand MakerNote in "${img}"
	fi

done

echo ''
echo MakerNote variants recognized:
sort "$tmpfile" | uniq
maker_variants=`sort "$tmpfile" | uniq | wc -l`
rm "$tmpfile"

self="$(basename "$0")"
echo "$self: $total_img images checked."
echo "$self: $maker_img images had MakerNote tags."
echo "$self: $total images contained supported MakerNotes."
echo "$self: $maker_variants different MakerNote variants seen."
test "$total" -ne 0
