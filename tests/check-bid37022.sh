#!/bin/sh
# Checks that libexif doesn't crash when reading an invalid image with a BYTE
# array that is fixed up to SHORT. libexif 0.6.18 overflowed the heap in
# that case.  This isn't a complete test because a heap overflow won't
# always cause a crash, but a malloc library which checks heap consistency
# should catch it (such as glibc does when linked with -lmcheck, or valgrind).
# This bug is also known as CVE-2009-3895
. ./check-vars.sh

readonly bug="bid37022"
readonly srcimg="$SRCDIR/${bug}.jpg"

# Run this in the C locale so the messages are known
LANG=C; export LANG
LANGUAGE=C; export LANGUAGE

echo "Reading invalid EXIF image"
$EXIFEXE "$srcimg" >/dev/null

# if the program doesn't crash it's a successful test
