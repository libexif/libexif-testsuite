AC_PREREQ(2.59)
AC_INIT([libexif test suite],[0.6.13],[libexif-devel@lists.sourceforge.net],[libexif-testsuite])
AC_CONFIG_SRCDIR([tests/Makefile.am])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([gnu 1.8 dist-bzip2])

GP_CHECK_SHELL_ENVIRONMENT

GP_CONFIG_INIT
GP_CONFIG_MSG([Source code location],[${srcdir}])


dnl ---------------------------------------------------------------------------
dnl compiler stuff
dnl ---------------------------------------------------------------------------
AC_PROG_CC
AC_C_CONST
AM_PROG_LIBTOOL
AM_CFLAGS="$CFLAGS"
GP_CONFIG_MSG([Compiler],[${CC}])


# ---------------------------------------------------------------------------
# Our tests require diff
# ---------------------------------------------------------------------------
AC_PATH_PROG([DIFF],[diff],[false])
if test "x$DIFF" = "xfalse"; then
	AC_MSG_ERROR([
* FATAL: ${PACKAGE_NAME} requires diff to work.
])
fi
AC_SUBST([DIFF])


# ---------------------------------------------------------------------------
# i18n support
# ---------------------------------------------------------------------------
GP_GETTEXT_HACK([${PACKAGE}],[Hans Ulrich Niedermann])
ALL_LINGUAS="de"
AM_GNU_GETTEXT_VERSION(0.14.1)
AM_GNU_GETTEXT([external])
AM_PO_SUBDIRS()
AM_ICONV()
GP_GETTEXT_FLAGS()

# We cannot use [AC_DEFINE_UNQUOTED()] for these definitions, as
# we require make to do insert the proper $(datadir) value
AC_SUBST([localedir],["\$(datadir)/locale"])
AM_CFLAGS="$AM_CFLAGS -DLOCALEDIR=\\\"${localedir}\\\""


# ---------------------------------------------------------------------------
# Warnings: If we have GCC, be paranoid.
# ---------------------------------------------------------------------------
if test "x$GCC" = "xyes"; then
    AM_CFLAGS="$AM_CFLAGS -Wall -Wchar-subscripts -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wpointer-arith"
    AM_LDFLAGS="$AM_LDFLAGS -g -Wall"
fi

AC_SUBST([AM_CFLAGS])
AC_SUBST([AM_LDFLAGS])


dnl ---------------------------------------------------------------------------
dnl PKG_CONFIG and PKG_CONFIG_PATH setup
dnl ---------------------------------------------------------------------------
pwd="$(pwd)"
for dir in libexif/libexif libgphoto2/libgphoto2 libusb
do
	tmp="${pwd}/src/${dir}"
	if test "x${PKG_CONFIG_PATH}" = "x"; then
	   PKG_CONFIG_PATH="${tmp}"
	else
	   PKG_CONFIG_PATH="${tmp}:${PKG_CONFIG_PATH}"
	fi
done
export PKG_CONFIG_PATH
GP_PKG_CONFIG


# ---------------------------------------------------------------------------
# Configure subtrees
# ---------------------------------------------------------------------------
dnl Yes, the sequence matters!

if test -d ${srcdir}/src/libexif && test -d ${srcdir}/src/exif; then

   AC_CONFIG_SUBDIRS([src/libexif])

   # This kind of relative definition only works for subprojects located 
   # in src/subproj, so we have to stick to that pattern.
   LIBEXIF_LIBS="\$(top_builddir)/../../src/libexif/libexif/libexif.la"
   LIBEXIF_CFLAGS="-I\$(top_builddir)/../../src/libexif -I\$(top_srcdir)/../../src/libexif"
   export LIBEXIF_LIBS LIBEXIF_CFLAGS

   AC_CONFIG_SUBDIRS([src/exif])

   if test ! -f ${srcdir}/src/libexif/configure; then
      AC_MSG_ERROR([
FATAL: ${PACKAGE_NAME} requires libexif source in src/libexif!
])
   fi

   if test ! -f ${srcdir}/src/exif/configure; then
      AC_MSG_ERROR([
FATAL: ${PACKAGE_NAME} requires exif source in src/exif!
])
   fi

   if test -d ${srcdir}/src/libexif-gtk; then
      AC_CONFIG_SUBDIRS([src/libexif-gtk])
      LIBEXIF_GTK_LIBS="\$(top_builddir)/../../src/libexif-gtk/libexif-gtk/libexif-gtk.la"
      LIBEXIF_GTK_CFLAGS="-I\$(top_builddir)/../../src/libexif-gtk -I\$(top_srcdir)/../../src/libexif-gtk"
      export LIBEXIF_GTK_LIBS LIBEXIF_GTK_CFLAGS
      if test -d ${srcdir}/src/gexif; then
	 AC_CONFIG_SUBDIRS([src/gexif])
      fi
   fi

   if test -d ${srcdir}/src/libusb; then
      AC_CONFIG_SUBDIRS([src/libusb])
      LIBUSB_LIBS="\$(top_builddir)/../../src/libusb/libusb.la"
      LIBUSB_CFLAGS="-I\$(top_builddir)/../../src/libusb -I\$(top_srcdir)/../../src/libusb"
      export LIBUSB_LIBS LIBUSB_CFLAGS
      if test -d ${srcdir}/src/libgphoto2; then
         AC_CONFIG_SUBDIRS([src/libgphoto2])
         LIBGPHOTO2_LIBS="\$(top_builddir)/../../src/libgphoto2/libgphoto2/libgphoto2.la"
         LIBGPHOTO2_CFLAGS="-I\$(top_builddir)/../../src/libgphoto2 -I\$(top_srcdir)/../../src/libgphoto2"
         export LIBGPHOTO2_LIBS LIBGPHOTO2_CFLAGS
         if test -d ${srcdir}/src/gphoto2; then
            AC_CONFIG_SUBDIRS([src/gphoto2])
         fi
         if test -d ${srcdir}/src/libexif-gtk
         then
            AC_CONFIG_SUBDIRS([src/gtkam])      
         fi
      fi
   fi

else
   AC_MSG_ERROR([
FATAL: src/libexif and src/exif subdirectories not found.
       The README file describes how to create them.
])
fi

# Message about configured subprojects
GP_CONFIG_MSG()dnl
_subdirs=""
for sd in $subdirs; do
	ssd="$(basename "$sd")"
	if test "x$_subdirs" = "x"; then
		_subdirs="$ssd";
	else
		_subdirs="$_subdirs $ssd"
	fi
done
GP_CONFIG_MSG([Subprojects],[${_subdirs}])dnl


dnl ---------------------------------------------------------------------------
dnl Output files
dnl ---------------------------------------------------------------------------
AC_CONFIG_FILES([
  po/Makefile.in
  Makefile
  m4/Makefile
  testlib/Makefile
  tests/Makefile
  tests/images/Makefile
])
AC_OUTPUT

GP_CONFIG_OUTPUT
