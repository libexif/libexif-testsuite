# Test functions for use within libexif-testsuite tests.
# These functions return characteristics of the various images that form
# a part of the test suite. Each function is called with the file name of
# the image as the only argument and returns a status value of 0 for true or
# 1 for false.

# Function that returns true when the given file contains no EXIF tags
noexiftags () {
	# This line could almost replace this function except that
	# it fails with a few images, and it's a lot slower:
	#file "$1" | grep -v -q "EXIF standard"
	case "$1" in 
		 *-thumb* | *no-exif* | *canon-powershot-a400-001.jpg)
			return 0 # No EXIF tags in this image
			;;
	esac
	return 1 # normal image with EXIF tags
}

# Function that returns true when the given file contains tags that are
# not properly sorted (i.e. the input file is corrupt and not to spec).
unsortedtags () {
	case "$1" in 
		 *Kodak_C310.jpg | \
		 *HTC_Touch_Pro2.jpg)
		 	return 0 # Input file has unsorted tags
			;;
	esac
	return 1 # normal image
}

# Function that returns true when the given file contains tags that are
# not recognized by libexif (i.e. the input file is corrupt and not to spec).
unknowntags () {
	case "$1" in 
		 *Panasonic_DMC-G1.jpg | \
		 *digiKam.jpg)
		 	return 0 # Input file has unknown tags
			;;
	esac
	return 1 # normal image
}

# Function that returns true when the given file is missing tags that are
# mandatory in the EXIF specification (i.e. the input file is corrupt
# and not to spec).
missingtags () {
	case "$1" in 
		 *Arcsoft_Webcam_Companion.jpg | \
		 *Motorola_Milestone.jpg | \
		 *digiKam.jpg | \
		 *HTC_Touch_Pro2.jpg)
		 	return 0 # Input file has unknown tags
			;;
	esac
	return 1 # normal image
}
