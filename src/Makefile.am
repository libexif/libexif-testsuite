# "@substdirs@"
# are the properly fixed subdirs configured via AC_CONFIG_SUBDIRS
# However, we cannot just add them to SUBDIRS because we need to
# pass special parameters during builds.
# SUBDIRS = @substdirs@

subdirs = @substdirs@

all-local:
	@for subdir in $(subdirs); do \
		params=""; \
		case "$$subdir" in \
		*/exif)	\
			params="$${params} LIBEXIF_LIBS='$$(pwd)/$(top_builddir)/src/libexif/libexif/libexif.la'"; \
			params="$${params} LIBEXIF_CFLAGS='-I$$(pwd)/$(top_srcdir)/src/libexif'"; \
			;; \
		esac; \
		(cd "$$subdir" && $(MAKE) $${params} all) || exit $$?; \
	done

check-local:
	@for subdir in $(subdirs); do \
		(cd "$$subdir" && $(MAKE) check) || exit $$?; \
	done

clean-local:
	@for subdir in $(subdirs); do \
		(cd "$$subdir" && $(MAKE) clean) || exit $$?; \
	done

distclean-local:
	@for subdir in $(subdirs); do \
		(cd "$$subdir" && $(MAKE) distclean) || exit $$?; \
	done
