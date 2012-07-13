#!/bin/sh
# Tests for division by zero in Nikon MakerNote tag.
# Some environments will crash when dividing by zero in the
# "Manual Focus Distance" makernote tag.
# This tests bug CVE-2012-2837
. ./check-vars.sh
$EXIFEXE -m --show-mnote "$SRCDIR"/3434545.jpg > /dev/null 2>&1
# This should return 0 if no error, or nonzero on SIGFPE
