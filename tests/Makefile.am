# Those numbers are the bub IDs from the sourceforge.net bug tracker.
#
# To get more info about NNNNNN, go visit
# https://sourceforge.net/tracker/index.php?func=detail&aid=NNNNNN&group_id=12272&atid=112272

check_SCRIPTS = \
	check-994706.sh check-1054321.sh check-1054322.sh check-1054323.sh

TESTS = $(check_SCRIPTS)

CLEANFILES = $(check_SCRIPTS) *.modified.jpeg

%.sh: %.in Makefile
	sed 's|@exif\@|$(top_builddir)/src/exif/exif/exif|g' < $< > $@
	chmod +x $@

