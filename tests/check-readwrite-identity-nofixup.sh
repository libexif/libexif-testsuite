#!/bin/sh
# Read then write (unmodified) each image through exif, using the --no-fixup
# option. Check that the written image contains the same data as the original.

readonly script=`dirname $0`
readonly newscript="$script/check-readwrite-identity.sh"
exec $newscript --no-fixup
