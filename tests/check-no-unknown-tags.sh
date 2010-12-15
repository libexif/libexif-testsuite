#!/bin/sh
# Run all test images through exif and ensure that all the tags are known.
# This is as much a test of the images as of exif itself.

. ./check-vars.sh

tmpfile="./output.tmp"

# Display ok or FAILED depending on the result code
check_result () {
	s="$?"
	if test "$s" -eq 0; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		if [ -z "$1" ] ; then
			true cat "$tmpfile"
		else
			true cat "$1"
		fi
		continue
	fi
}

echo Testing "$EXIFEXE"

errors=0
total=0
total_img=0

for img in $ALLFILES
do
	test -f "$img" || continue

	if noexiftags "$img" ; then
		continue # skip image
	fi

	if unknowntags "$img" ; then
		echo "Skipping $img due to known, unknown tags"
		continue # skip image
	fi

	total_img=$(expr $total_img + 1)
	echo -n "#${total_img} "

	# Capture the debug logs
	echo -n "Reading image \`${img}'..."
	# Run this in the C language locale so the messages are known
	env LANG=C LANGUAGE=C "$EXIFEXE" -d "${img}" > "$tmpfile" 2>&1
	check_result

	# Ensure all tags were understood
	echo -n "Looking for unknown tags..."
	! grep -q "Unknown tag" "$tmpfile"
	check_result

done

rm "$tmpfile"

self="$(basename "$0")"
echo "$self: Checked $total_img images."
echo "$self: $errors checks failed."
test "$errors" -eq 0
