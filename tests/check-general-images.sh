#!/bin/sh
# Execute a number of common sense checks on "real" images
# (not specially prepared images)

. ./check-vars.sh

tmpfile="./output.tmp"
tmpimg="./general.out.jpg"

echo Testing "$EXIFEXE"

errors=0
total=0
total_img=0

for img in $ALLFILES
do
	test -f "$img" || continue
	total_img=$(expr $total_img + 1)
	echo \#${total_img}

	# Skip these images entirely for whatever reason
	if skipimage "$img" ; then
		echo "Skipping \`${img}'... ok."
		continue
	fi

	# Test images without EXIF tags
	if noexiftags "$img" ; then
		echo -n "Attempting list of nonexistent EXIF data from \`${img}'..."
		$EXIFEXE "${img}" > "$tmpfile" 2>&1
		s="$?"
		if test "$s" -eq 1; then
			echo " ok."
		else
			echo " FAILED (${s})."
			errors=$(expr $errors + 1)
			cat "$tmpfile"
		fi
		continue
	fi

	# Check that listing EXIF info works
	echo -n "Listing EXIF info from \`${img}'..."
	# Run this in the C locale so the messages are known
	env LANG=C LANGUAGE=C $EXIFEXE "${img}" > "$tmpfile" 2>&1
	s="$?"
	if test "$s" -eq 0; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		cat "$tmpfile"
		continue # if listing EXIF info fails, the other tests cannot work anyway
	fi
	total=$(expr $total + 1)

	check_makernote=
	grep "^Maker Note" < "$tmpfile" > /dev/null && check_makernote=true
	check_thumbnail=
	grep "^EXIF data contains a thumbnail" < "$tmpfile" > /dev/null && check_thumbnail=true
	rm -f "$tmpfile"

	# Check that listing the makernote works
	echo -n "Listing MNote info from \`${img}'..."
	$EXIFEXE --show-mnote "${img}" > "$tmpfile" 2>&1
	s="$?"
	if test "$s" -eq 0; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		cat "$tmpfile"
	fi
	total=$(expr $total + 1)

	# Check that removing a tag works
	echo -n "Removing tag from \`${img}'..."
	$EXIFEXE --tag=DateTime --remove "${img}" -o "$tmpimg" > "$tmpfile" 2>&1
	s="$?"
	if test "$s" -eq 0; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		cat "$tmpfile"
	fi
	total=$(expr $total + 1)

	# Check that the tag is removed
	echo -n "Listing tag from \`${tmpimg}'..."
	$EXIFEXE --tag=DateTime "${tmpimg}" > "$tmpfile" 2>&1
	s="$?"
	if test "$s" -eq 1; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		cat "$tmpfile"
	fi
	total=$(expr $total + 1)

	# Check that listing EXIF info still works
	echo -n "Listing EXIF info from \`${tmpimg}'..."
	$EXIFEXE "${tmpimg}" > "$tmpfile" 2>&1
	s="$?"
	if test "$s" -eq 0; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		cat "$tmpfile"
	fi
	total=$(expr $total + 1)

	# Check that listing the makernote still works
	echo -n "Listing MNote info from \`${tmpimg}'..."
	$EXIFEXE --show-mnote "${tmpimg}" > "$tmpfile" 2>&1
	s="$?"
	if test "$s" -eq 0; then
		echo " ok."
	else
		echo " FAILED (${s})."
		errors=$(expr $errors + 1)
		cat "$tmpfile"
	fi
	total=$(expr $total + 1)

	# Check that extracting thumbnail works
	if [ "$check_thumbnail" ] ; then
		echo -n "Extracting thumbnail from ${img}"
		thumb="./$(basename "$img").check-general-images.thumb.out.jpg"
		$EXIFEXE -e -o "$thumb" "$img" > "$tmpfile" 2>&1
		s="$?"
		if test "$s" -eq 0; then
			echo " ok."
		else
			echo " FAILED (${s})."
			errors=$(expr $errors + 1)
			cat "$tmpfile"
		fi
		rm -f "$tmpfile" "$thumb"
		total=$(expr $total + 1)
	else
		echo "Skipping extract thumbnail test on ${img}"
	fi

done

rm -f "$tmpimg"

self="$(basename "$0")"
echo "$self: Performed $total checks on $total_img images."
echo "$self: $errors checks failed."
test "$errors" -eq 0
