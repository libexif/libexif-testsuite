# Those numbers are the bub IDs from the sourceforge.net bug tracker.
#
# To get more info about NNNNNN, go visit
# https://sourceforge.net/tracker/index.php?func=detail&aid=NNNNNN&group_id=12272&atid=112272

SUBDIRS = images

check_SCRIPTS = \
	check-994706.sh \
	check-1054321.sh check-1054322.sh check-1054323.sh

EXTRA_DIST = \
	check-994706.in \
	check-1054321.in 1054321.jpg \
	check-1054322.in 1054322.jpg \
	check-1054323.in 1054323.jpg

TESTS = $(check_SCRIPTS)

CLEANFILES = $(check_SCRIPTS) *.out.jpg

%.sh: %.in Makefile
	@echo "Creating $@"
	@sed 's|@exif\@|$(top_builddir)/src/exif/exif/exif|g;s|@srcdir\@|$(srcdir)|g' < $< > $@
	@chmod +x $@

