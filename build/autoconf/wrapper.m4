dnl This Source Code Form is subject to the terms of the Mozilla Public
dnl License, v. 2.0. If a copy of the MPL was not distributed with this
dnl file, You can obtain one at http://mozilla.org/MPL/2.0/.

dnl =======================================================================
dnl = Enable compiling with various compiler wrappers (distcc, ccache, etc)
dnl =======================================================================
AC_DEFUN([MOZ_CHECK_COMPILER_WRAPPER],
[
MOZ_ARG_WITH_STRING(compiler_wrapper,
[  --with-compiler-wrapper[=path/to/wrapper]
    Enable compiling with wrappers such as distcc and ccache],
    COMPILER_WRAPPER=$withval, COMPILER_WRAPPER="no")

if test "$COMPILER_WRAPPER" != "no"; then
    case "$target" in
    *-mingw*)
        dnl When giving a windows path with backslashes, js/src/configure
        dnl fails because of double wrapping because the test further below
        dnl doesn't work with backslashes. While fixing that test to work
        dnl might seem better, a lot of the make build backend actually
        dnl doesn't like backslashes, so normalize windows paths to use
        dnl forward slashes.
        COMPILER_WRAPPER=`echo "$COMPILER_WRAPPER" | tr '\\' '/'`
        ;;
    esac

    case "$CC" in
    $COMPILER_WRAPPER\ *)
        :
        ;;
    *)
        CC="$COMPILER_WRAPPER $CC"
        CXX="$COMPILER_WRAPPER $CXX"
        _SUBDIR_CC="$CC"
        _SUBDIR_CXX="$CXX"
        ac_cv_prog_CC="$CC"
        ac_cv_prog_CXX="$CXX"
        MOZ_USING_COMPILER_WRAPPER=1
        ;;
    esac
fi

AC_SUBST(MOZ_USING_COMPILER_WRAPPER)
])
