# Those numbers are the issue IDs from the sourceforge.net bug tracker or
# the BugTraq ID number.
#
# To get more info about NNNNNN, go visit
# https://sourceforge.net/tracker/index.php?func=detail&aid=NNNNNN&group_id=12272&atid=112272
#
# To get more info about bidNNNNN, go visit
# https://www.securityfocus.com/bid/NNNNN

SUBDIRS = images

# check-vars.sh.in is automatically included
EXTRA_DIST = \
	check-exif-executable.sh \
	check-general-images.sh \
	check-readwrite-identity.sh \
	check-readwrite-identity-nofixup.sh \
	check-no-unknown-tags.sh \
	check-all-mandatory-tags.sh \
	check-994706.sh check-994706.b.patch \
	check-1054321.sh 1054321.jpg \
	check-1054322.sh 1054322.jpg \
	check-1054323.sh 1054323.jpg \
	check-1169170.sh \
	check-bid37022.sh bid37022.jpg \
	check-tag-description.sh

if HAVE_EXIF_CLI

check_SCRIPTS = \
	check-exif-executable.sh \
	check-994706.sh \
	check-1054321.sh \
	check-1054322.sh \
	check-1054323.sh \
	check-1169170.sh \
	check-bid37022.sh

# These check scripts may take a little longer - but are invaluable. :)
check_SCRIPTS += check-general-images.sh \
	check-readwrite-identity.sh \
	check-readwrite-identity-nofixup.sh \
	check-no-unknown-tags.sh \
	check-all-mandatory-tags.sh \
	check-tag-description.sh

TESTS = $(check_SCRIPTS)

endif

CLEANFILES = *.out.jpg *.tmp

