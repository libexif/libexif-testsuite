# @subdirs@ are the configured subproject directories
SUBDIRS = m4m po testlib @subdirs@ tests

EXTRA_DIST = build-config.sh build-config.txt

ACLOCAL_AMFLAGS = -I auto-m4 -I m4m

#######################################################################
# Help for the maintainer
#

# Simulate something like
#   EXTRA_DIST_IF_EXIST = ChangeLog.git
# If present, ship ChangeLog.git in source tarball.
# If not present, don't ship it.
dist-hook:
	if test -f $(srcdir)/ChangeLog.git; then \
		cp -p $(srcdir)/ChangeLog.git $(distdir)/ChangeLog.git; \
	fi

.PHONY: git-changelog
git-changelog: $(srcdir)/ChangeLog.git
	@for subdir in @subdirs@; do (cd "$$subdir" && $(MAKE) $@); done

.PHONY: $(srcdir)/ChangeLog.git
$(srcdir)/ChangeLog.git:
	(cd "$(srcdir)" && git2cl > $@)

.PHONY: git-tag-release
git-tag-release:
	@tag="$$(echo "$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)-release" | sed 's|\.|_|g')"; \
	echo "Are you sure you want to git tag \`$${tag}' your source files?"; \
	echo "Press Ctrl-C to abort, Enter to continue."; \
	read; \
	cd "$(srcdir)" && git tag "$${tag}"

# End of Makefile.am.
