# Those numbers are the issue IDs from the sourceforge.net bug tracker.
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

# This check script may take a little long - but it is invaluable. :)
check_SCRIPTS += check-general-images.sh

TESTS = $(check_SCRIPTS)

endif

CLEANFILES = $(check_SCRIPTS) *.out.jpg *.dst.txt *.src.txt *.modified.jpeg *.a.patch *.xpatch *.tmp

# The embedded script for @exif@ is supposed to run at the time the
# .sh file is running. If not, we try to run the installed version.
# If that doesn't work, either, we fail.
.in.sh: Makefile
	@echo "Creating $@"
	@sed 's|@exif\@|`if test -x "$(top_builddir)/src/exif/exif/exif"; then echo "$(top_builddir)/src/exif/exif/exif"; elif test -x "$(bindir)/exif"; then echo "$(bindir)/exif"; else echo "Neither $(top_builddir)/src/exif/exif/exif nor $(bindir)/exif are executable." >&2; echo false; exit 1; fi`|g;s|@top_srcdir\@|$(top_srcdir)|g;s|@srcdir\@|$(srcdir)|g;s|@diff\@|$(DIFF)|g' < $< > $@
	@chmod +x $@

