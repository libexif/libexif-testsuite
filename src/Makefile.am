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

recurse-to-subproject:
	@target="$$(echo "$(TARGET)" | sed 's,-\(local\|hook\)$$,,g')"; \
	export target; \
	top_builddir="$$(cd "$(top_builddir)" && pwd)"; \
	top_srcdir="$$(cd "$(top_srcdir)" && pwd)"; \
	for subdir in $(subdirs); do \
		params=""; \
		case "$${subdir}" in \
		*/exif)	\
			params="$${params} LIBEXIF_LIBS='$${top_builddir}/src/libexif/libexif/libexif.la'"; \
			params="$${params} LIBEXIF_CFLAGS='-I$${top_srcdir}/src/libexif'"; \
			;; \
		esac; \
		echo "### Making \`$${target}' in \`$${subdir}' ###"; \
		(cd "$${subdir}" && $(MAKE) $${params} $${target}) || exit $$?; \
	done
