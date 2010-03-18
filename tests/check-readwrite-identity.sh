#!/bin/sh
# Read then write (unmodified) each image through exif.
# Check that the written image contains the same data as the original.

. check-vars.sh

tmpfile="./output.tmp"
tmpfile2="./output2.tmp"
tmpimg="./readwrite.out.jpg"

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

# Put exif output into canonical form by removing lines that could change
canonicalize () {
	# Remove the MakerNote tag (0x927c) as well. This really shouldn't be
	# necessary, but it seems that there are some problems with
	# several MakerNotes types so they aren't completely identical to
	# the originals right now.
	sed -i  -e '/^EXIF tags in /d' \
		-e '/^0x927c/d' \
	  "$1"
}

echo Testing "$EXIFEXE" "$@"

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
	echo \#${total_img}

	# Create a copy of the image that has been processed by exif
	# Force this by attempting deleting a nonexistent tag
	echo -n "Copying image \`${img}'..."
	"$EXIFEXE" "$@" --remove --tag=0xbeef --output="${tmpimg}" "${img}" > "$tmpfile" 2>&1
	check_result

	# Listing original EXIF info
	echo -n "Listing EXIF info..."
	# Run this in the C language locale so the messages are known
	env LANG=C LANGUAGE=C "$EXIFEXE" "$@" --ids --width 999 "${img}" > "$tmpfile" 2>&1
	check_result

	# Listing copied EXIF info
	echo -n "Listing EXIF info..."
	# Run this in the C language locale so the messages are known
	env LANG=C LANGUAGE=C "$EXIFEXE" "$@" --ids --width 999 "${tmpimg}" > "$tmpfile2" 2>&1
	check_result $tmpfile2

	# Compare the tag output of the original and copied files.
	canonicalize "$tmpfile"
	canonicalize "$tmpfile2"
	if unsortedtags "${img}" || missingtags "${img}"; then
		# If input file is not to spec and its tags are not sorted,
		# sort the before and after files so they will compare equal.
		#
		# If input file is not to spec and is missing mandatory tags,
		# exif will add them but they may be displayed out of order,
		# so sort them both so they will compare equal.
		echo Sorting tags on out-of-spec image
		sort -o "$tmpfile" "$tmpfile"
		sort -o "$tmpfile2" "$tmpfile2"
	fi
	echo -n "Comparing before and after..."
	"$DIFFEXE" "$tmpfile" "$tmpfile2"
	check_result

	# Listing original MakerNote info
	echo -n "Listing MakerNote info..."
	# Run this in the C language locale so the messages are known
	env LANG=C LANGUAGE=C "$EXIFEXE" "$@" --ids --show-mnote --width 999 "${img}" > "$tmpfile" 2>&1
	check_result

	# Listing copied MakerNote info
	echo -n "Listing MakerNote info..."
	# Run this in the C language locale so the messages are known
	env LANG=C LANGUAGE=C "$EXIFEXE" "$@" --ids --show-mnote --width 999 "${tmpimg}" > "$tmpfile2" 2>&1
	check_result $tmpfile2

	canonicalize "$tmpfile"
	canonicalize "$tmpfile2"
	echo -n "Comparing before and after..."
	"$DIFFEXE" "$tmpfile" "$tmpfile2"
	check_result

done

rm "$tmpfile"
rm "$tmpfile2"
rm "$tmpimg"

self="$(basename "$0")"
echo "$self: Checked $total_img images."
echo "$self: $errors checks failed."
test "$errors" -eq 0
