# "@substdirs@"
# are the properly fixed subdirs configured via AC_CONFIG_SUBDIRS
# However, we cannot just add them to SUBDIRS because we need to
# pass special parameters during builds.
# SUBDIRS = @substdirs@

subdirs = @substdirs@

all-local:
	$(MAKE) TARGET=$@ recurse-to-subproject

check-local:
	$(MAKE) TARGET=$@ recurse-to-subproject

clean-local:
	$(MAKE) TARGET=$@ recurse-to-subproject

distclean-local:
	$(MAKE) TARGET=$@ recurse-to-subproject

install-data-local:
	$(MAKE) TARGET=$@ recurse-to-subproject

install-exec-local:
	$(MAKE) TARGET=$@ recurse-to-subproject

# Recursing for "make dist" doesn't work.
#
#distdir-local:
#	$(MAKE) TARGET=$@ recurse-to-subproject
#
#dist-hook:
#	$(MAKE) TARGET=$@ recurse-to-subproject

# A few notes about this:
# - The different sub-projects need to know about the other subprojects.
#   This is what the conditional make variable definitions are for.
# - We serialize compilation on purpose here. Thus, "make -j" on
#   libexif-testsuite will still have the subprojects built in the
#   required sequence, but the subprojects themselves can be parallel
#   compiled. And that is a lot of fun on a Quad-Opteron :-)
recurse-to-subproject:
	@target="$$(echo "$(TARGET)" | sed 's,-\(local\|hook\)$$,,g')"; \
	export target; \
	top_builddir="$$(cd "$(top_builddir)" && pwd)"; \
	top_srcdir="$$(cd "$(top_srcdir)" && pwd)"; \
	for subdir in $(subdirs); do \
		case "$${subdir}" in \
		*/exif)	\
			LIBEXIF_LIBS="$${top_builddir}/src/libexif/libexif/libexif.la"; \
			LIBEXIF_CFLAGS="-I$${top_srcdir}/src/libexif -I$${top_builddir}/src/libexif"; \
			;; \
		*) \
			LIBEXIF_LIBS=""; \
			LIBEXIF_CFLAGS=""; \
		esac; \
		echo "### Making \`$${target}' in \`$${subdir}' ###"; \
		for ppp in $${params}; do echo "    $${ppp}"; done; \
		(cd "$${subdir}" && $(MAKE) "$${LIBEXIF_LIBS+LIBEXIF_LIBS="$${LIBEXIF_LIBS}"}" "$${LIBEXIF_CFLAGS+LIBEXIF_CFLAGS="$${LIBEXIF_CFLAGS}"}" "$${target}") || exit $$?; \
	done

