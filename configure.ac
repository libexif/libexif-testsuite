AC_PREREQ(2.59)
AC_INIT([libexif test suite],[0.6.12],[libexif-devel@lists.sourceforge.net],[libexif-testsuite])
AC_CONFIG_SRCDIR([tests/Makefile.am])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([gnu 1.8 dist-bzip2])

GP_CHECK_SHELL_ENVIRONMENT

GP_CONFIG_INIT
GP_CONFIG_MSG([Source code location],[${srcdir}])


dnl ---------------------------------------------------------------------------
dnl PKG_CONFIG and PKG_CONFIG_PATH setup
dnl ---------------------------------------------------------------------------
if test "x${PKG_CONFIG_PATH}" = "x"; then
	PKG_CONFIG_PATH="`pwd`/src/libexif/libexif"
else
	PKG_CONFIG_PATH="`pwd`/src/libexif/libexif:${PKG_CONFIG_PATH}"
fi
GP_PKG_CONFIG


dnl ---------------------------------------------------------------------------
dnl compiler stuff
dnl ---------------------------------------------------------------------------
AC_PROG_CC
AC_C_CONST
AM_PROG_LIBTOOL
AM_CFLAGS="$CFLAGS"
GP_CONFIG_MSG([Compiler],[${CC}])


dnl ---------------------------------------------------------------------------
dnl Warnings: If we have GCC, be paranoid.
dnl ---------------------------------------------------------------------------
if test "x$GCC" = "xyes"; then
    AM_CFLAGS="$AM_CFLAGS -Wall -Wchar-subscripts -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wpointer-arith"
    AM_LDFLAGS="$AM_LDFLAGS -g -Wall"
fi

AC_SUBST([AM_CFLAGS])
AC_SUBST([AM_LDFLAGS])


dnl ---------------------------------------------------------------------------
dnl Configure subtrees
dnl ---------------------------------------------------------------------------
dnl Yes, the sequence matters!

AC_CONFIG_SUBDIRS([src/libexif])
AC_CONFIG_SUBDIRS([src/exif])

# workaround, must be after all AC_CONFIG_SUBDIRS
# recursive make, two-subdirs, and stuff.
substdirs=""
for subdir in ${subdirs}; do
    substdirs="${substdirs} \$(top_builddir)/${subdir}"
done
AC_SUBST([substdirs])


dnl ---------------------------------------------------------------------------
dnl Output files
dnl ---------------------------------------------------------------------------
AC_CONFIG_FILES([
  Makefile
  m4/Makefile
  src/Makefile
  tests/Makefile
])
AC_OUTPUT

GP_CONFIG_OUTPUT
