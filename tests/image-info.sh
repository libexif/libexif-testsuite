# Test functions for use within libexif-testsuite tests.
# These functions return characteristics of the various images that form
# a part of the test suite. Each function is called with the file name of
# the image as the only argument and returns a status value of 0 for true or
# 1 for false.

# Function that returns true when the given file should be entirely skipped.
# noexiftags() should be used instead, when possible (i.e. when there
# actually are no EXIF tags in the file).
skipimage () {
	case "$1" in 
# TEMPORARILY DISABLE IMAGES ON THE NEXT LINE UNTIL I FIX THE TESTS
		*Panasonic_DMC-LX5.jpg)
			return 0 # Skip this file entirely
			;;
	esac
	return 1 # normal image
}

# Function that returns true when the given file contains no EXIF tags
noexiftags () {
	# The following line could almost replace this function except
	# that it fails with a few images, and it's a lot slower:
	#file "$1" | grep -v -q "EXIF standard"
	case "$1" in 
# TEMPORARILY DISABLE IMAGES ON THE NEXT LINE UNTIL I FIX THE TESTS
		 *HTC_T-Mobile_G1.jpg | *Panasonic_DMC-LX5.jpg | \
		 *canon-powershot-a400-001.jpg | \
		 *-thumb* | *no-exif*)
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
		 *HTC_Rhodium.jpg | \
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
		 *Canon_PowerShot_ELPH_100_HS.jpg | \
		 *Kodak_C160.jpg | \
		 *Nikon_Coolpix_S9100.jpg | \
		 *Nikon_Coolpix_AW100.jpg | \
		 *Nikon_Coolpix_P7100.jpg | \
		 *Panasonic_DMC-G1.jpg | \
		 *Panasonic_DMC-LX5.jpg | \
		 *Pentax_Q.jpg | \
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
		 *KDE_digiKam.jpg | \
		 *Palm_Centro.jpg | \
		 *RIM_Blackberry_Torch.jpg | \
		 *RIM_Blackberry_Playbook.jpg | \
		 *HTC_Touch_Pro2.jpg)
		 	return 0 # Input file has unknown tags
			;;
	esac
	return 1 # normal image
}
