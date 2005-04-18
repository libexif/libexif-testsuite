# Those numbers are the bub IDs from the sourceforge.net bug tracker.
#
# To get more info about NNNNNN, go visit
# https://sourceforge.net/tracker/index.php?func=detail&aid=NNNNNN&group_id=12272&atid=112272

SUBDIRS = images

EXTRA_DIST = \
	check-exif-executable.in \
	check-general-images.in \
	check-994706.in check-994706.b.patch \
	check-1054321.in 1054321.jpg \
	check-1054322.in 1054322.jpg \
	check-1054323.in 1054323.jpg \
	check-1169170.in

if HAVE_EXIF_CLI

check_SCRIPTS = \
	check-exif-executable.sh \
	check-994706.sh \
	check-1054321.sh check-1054322.sh check-1054323.sh \
	check-1169170.sh
# This check script takes too long for too few benefits:
#	check-general-images.sh

TESTS = $(check_SCRIPTS)

endif

CLEANFILES = $(check_SCRIPTS) *.out.jpg *.dst.txt *.src.txt *.modified.jpeg *.a.patch *.xpatch

%.sh: %.in Makefile
	@echo "Creating $@"
	@sed 's|@exif\@|$(top_builddir)/src/exif/exif/exif|g;s|@top_srcdir\@|$(top_srcdir)|g;s|@srcdir\@|$(srcdir)|g;s|@diff\@|$(DIFF)|g' < $< > $@
	@chmod +x $@

