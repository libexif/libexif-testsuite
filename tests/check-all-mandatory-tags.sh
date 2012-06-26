#!/bin/sh
# Run all test images through exif and ensure that all the mandatory tags are
# available

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

	total_img=$(expr $total_img + 1)
	echo -n "#${total_img} "

	if missingtags "${img}"; then
		echo "Skipping image missing mandatory tags: ${img}"
		continue
	fi

	# Capture the debug logs
	echo -n "Reading image \`${img}'..."
	# Run this in the C language locale so the messages are known
	env LANG=C LANGUAGE=C $EXIFEXE -d "${img}" > "$tmpfile" 2>&1
	check_result

	# Ensure all tags were understood
	echo -n "Looking for all mandatory tags..."
	! grep -q "is mandatory in IFD" "$tmpfile"
	check_result

done

rm -f "$tmpfile"

self="$(basename "$0")"
echo "$self: Checked $total_img images."
echo "$self: $errors checks failed."
test "$errors" -eq 0
