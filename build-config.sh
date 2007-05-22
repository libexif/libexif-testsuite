#!/bin/sh
# build-config.sh - build source tree according to configuration
#
# Syntax:
#   ./build-config.sh [<configfile> [<subdir-to-build-in>]]
#
# Default <subdir-to-build-in> is the current directory.
# Default <configfile> is build-config.txt from the directory
#         where build-config.sh resides.
#
# Yes, "config manager" already does that, but hardly anyone has it installed.
# So we write something similar with restricted functionality in sh.
#
# Known Bugs:
# * A on-checked-out "." top-level directory is not handled correctly.
# * Checking out modules sometimes messes up the directories
#
# If you run into a bug, use a shell, build-config.txt, and your brain.

# shell sanity check
if test "x$(pwd)" != "x`pwd`"; then exit 13; fi

# basic definitions
self="$(basename "$0")"
selfdir="$(cd "$(dirname "$0")" && pwd)"

# read command line params
if test "x$1" != "x"; then
    config="$1"
else
    config="${selfdir}/build-config.txt"
fi
if test "x$2" != "x"; then
    topdir="$2/"
else
    topdir=""
fi

# Output file initialization
echo "# Building source tree according to configuration:"
echo "#    \`${config}'"

cvsrootmap="${selfdir}/build-config.cvsroot.map"
cvsrootnew="${selfdir}/build-config.cvsroot.new"
echo "# Line syntax: <anonymous cvsroot> <whitespace> <personal cvsroot>" > "$cvsrootnew"
if test ! -f "$cvsrootmap"; then ln "$cvsrootnew" "$cvsrootmap"; fi
cm_config="${selfdir}/build-config.cm"

echo "# Automatically generated configuration for \"config manager\" (cm)" > "$cm_config"
echo "# Source file: ${config}" >> "$cm_config"
echo "" >> "$cm_config"

# Main loop writing to output files, and updating/checking out source
while read rdir method restofline <&5; do
	echo "$rdir" | grep "^#" > /dev/null && continue
	test "x$rdir" = "x" && continue

	echo
	dir="${topdir}${rdir}"
	echo "# Directory: \`$dir' (\`$topdir', \`$rdir')"
	case "$method" in
	SVN)
		# Parse rest of line (just use it)
		svn_url="$restofline"
		if test -f "$dir/.svn/entries"; then
			(cd "$dir" && svn up)
		else
			svn checkout "$svn_url" "$dir"
		fi
		;;
	CVS)
		# Parse rest of line
		anoncvsroot="$(echo "$restofline" | (read cvsroot mod tag rest; echo "${cvsroot}"))"
		module="$(     echo "$restofline" | (read cvsroot mod tag rest; echo "${mod}"))"
		xtag="$(       echo "$restofline" | (read cvsroot mod tag rest; echo "${tag}"))"

		# Prepare tag variables
		if test "x$xtag" = "x"; then
			tag=""
			cmtag=""
		else
			tag="-r${xtag}"
			cmtag="?tag=${xtag}"
		fi

		# Run update or checkout
		if test -f "$dir/CVS/Root"; then
			echo "#            exists, running update."
			cvsroot="$(cat "$dir/CVS/Root")"
			if test "x${cvsroot}" != "x${anoncvsroot}"; then
				echo "${anoncvsroot} ${cvsroot}" >> "$cvsrootnew"
			fi
			echo "# CVSROOT:   ${cvsroot}"
			echo "# Module:    ${module}"
			repo="$(cat "$dir/CVS/Repository")"
			if test "x$repo" != "x$module"; then
			    echo "# Repo:      $repo"
			    echo "$self: Module and content of \`$dir/CVS/Repository' differ." 2>&1
			    echo "$self: Aborting." >&2
			    exit 1
			fi
			echo "(cd $dir && cvs -z3 update -P ${tag})"
			(cd "$dir" && cvs -z3 update -P ${tag})
		elif test -d "$dir"; then
			echo "#            exists, but not from CVS. Assuming tarball, doing nothing."
		        echo "$self: Directory \`$dir' exists, but is no CVS directory." >&2
			echo "$self: Assuming tarball origin, going on." >&2
		else
			echo "#            does not exist, running checkout."
			# Find personal CVSROOT, if we know it
			cvsroot="$anoncvsroot"
			eval "$(cat "$cvsrootnew" "$cvsrootmap" | while read anon pers; do
				if test "$anoncvsroot" = "$anon"; then
					echo "cvsroot=\"$pers\""
					break
				fi
			done)"
			echo "# CVSROOT:   ${cvsroot}"
			echo "# Module:    ${module}"
			# "cvs checkout -d ./something" seems to have problems
			# with the "./"; so we avoid that.
			tmpdir="${dir}.tmp-checkout"
			echo "(cd "$tmpdir" && cvs -z3 -d "$cvsroot" checkout -d cvs-checkout -P "$module" ${tag})"
			mkdir -p "$tmpdir"
			(cd "$tmpdir" && cvs -z3 -d "$cvsroot" checkout -d cvs-checkout -P "$module" ${tag})
			echo mv -f "$tmpdir/cvs-checkout" "$dir"
			mv -f "$tmpdir/cvs-checkout" "$dir"
			rm -rf "$tmpdir"
		fi

		# Consistency check, and write config-manager configuration
		sedrexp="^:\(pserver\|ext\):\(.*\):\(.*\)\$"
		if echo "${cvsroot}" | sed "\,${sedrexp}, q 1" > /dev/null
		then
			echo "$self: ILLEGAL CVSROOT \`${cvsroot}'" >&2
			echo "$self: Aborting." >&2
			exit 1
		else
			echo "${cvsroot}" | \
				sed "s,${sedrexp},${dir}        \1://\2\3/${module}${cmtag},g" >&3
		fi
		;;
	*)
		echo "Unhandled method: '$method'. Aborting." >&2
		exit 13
		;;
	esac
done 3>> "$cm_config" 5< "$config"

# Finish up files
echo "" >> "$cm_config"
echo "# End of file \`$(basename "$cm_config")'." >> "$cm_config"

# Remove duplicate lines from CVSROOT map
cat "$cvsrootnew" "$cvsrootmap" | sort | uniq > "${cvsrootmap}.new"
mv -f "${cvsrootmap}.new" "$cvsrootmap"
rm -f "$cvsrootnew"

exit 0
# End of program.
