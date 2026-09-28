#!/usr/bin/env bash
# Thin CI wrapper around the 2021.01 qmake build. No dependency installation.
set -eo pipefail

source_root="$PWD"
export MXEDIR="${MXEDIR:-/mxe}"
export NUMCPU="${NUMCPU:-2}"
source scripts/setenv-mingw-xbuild.sh 64

case "$(qmake -query QT_VERSION)" in
  5.*) ;;
  *) echo 'This preview requires Qt 5.' >&2; exit 1 ;;
esac
qmake -v
"${MXE_TARGETS}-g++" --version
test -f "$MXETARGETDIR/qt5/mkspecs/features/qscintilla2.prf"
test -d "$MXETARGETDIR/include/CGAL"
test -f "$source_root/libraries/MCAD/__init__.py"

# The pinned GUI image omits Boost binaries required by the 2021.01 qmake project.
# Its default Boost recipe only builds a minimal library set, so request the
# components linked by this legacy project without changing OpenSCAD sources.
awk '
  /--without-mpi \\/ {
    print "        --with-filesystem \\";
    print "        --with-program_options \\";
    print "        --with-regex \\";
    print "        --with-chrono \\";
    print "        --with-thread \\";
    print "        --with-system \\";
    print "        --with-serialization \\";
    print "        --with-context \\";
  }
  { print }
' "$MXEDIR/src/boost.mk" > /tmp/openscad-boost.mk
mv /tmp/openscad-boost.mk "$MXEDIR/src/boost.mk"
# Boost.Build rejects any combination of --with and --without selectors.
sed -i -e 's/--without-mpi//' -e 's/--without-python//' "$MXEDIR/src/boost.mk"
rm -f "$MXETARGETDIR/installed/boost"
make -C "$MXEDIR" -j"$NUMCPU" MXE_TARGETS="$MXE_TARGETS" MXE_VERBOSE=1 boost
for library in thread_win32 program_options filesystem system regex chrono; do
  source_component="$library"
  if test "$library" = thread_win32; then
    source_component=thread
  fi
  source_library="$MXETARGETDIR/lib/libboost_${source_component}-mt-x64.a"
  target_library="$MXETARGETDIR/lib/libboost_${library}-mt.a"
  if test -f "$source_library"; then
    ln -sf "$(basename "$source_library")" "$target_library"
  fi
  if ! test -f "$target_library"; then
    echo "MXE Boost rebuild did not install $target_library" >&2
    find "$MXETARGETDIR/lib" -maxdepth 1 -type f -name 'libboost*' -printf '%f\n' >&2
    exit 1
  fi
done

# OpenSCAD 2021.01 uses a projection-traits API removed after CGAL 4.14.
# Build that dependency for this preview only; keep project sources untouched.
cgal_source=/tmp/CGAL-4.14
cgal_prefix=/tmp/cgal-4.14
tar -xf /runner-temp/CGAL-4.14.tar.xz -C /tmp
cd "$cgal_source"
"${MXE_TARGETS}-cmake" . \
  -C "$MXEDIR/src/cgal-TryRunResults.cmake" \
  -DCMAKE_INSTALL_PREFIX="$cgal_prefix" \
  -DCMAKE_BUILD_TYPE=Release \
  -DWITH_CGAL_Qt3=OFF -DWITH_CGAL_Qt4=OFF -DWITH_CGAL_Qt5=OFF \
  -DWITH_CGAL_ImageIO=OFF \
  -DGMP_INCLUDE_DIR="$MXETARGETDIR/include" \
  -DGMP_LIBRARIES="$MXETARGETDIR/lib/libgmp.a" \
  -DGMPXX_INCLUDE_DIR="$MXETARGETDIR/include" \
  -DGMPXX_LIBRARIES="$MXETARGETDIR/lib/libgmpxx.a" \
  -DMPFR_INCLUDE_DIR="$MXETARGETDIR/include" \
  -DMPFR_LIBRARIES="$MXETARGETDIR/lib/libmpfr.a" \
  -DBOOST_ROOT="$MXETARGETDIR" \
  -DCGAL_Boost_USE_STATIC_LIBS=ON
make -j"$NUMCPU"
make -j1 install
test -f "$cgal_prefix/include/CGAL/Triangulation_2_filtered_projection_traits_3.h"

export LIB3MF_INCLUDEPATH="$MXETARGETDIR/include/lib3mf"
export LIB3MF_LIBPATH="$MXETARGETDIR/lib"
# Parse Boost's foreach hooks before Qt defines its legacy `foreach` macro.
printf '#include <CGAL/Iterator_range.h>\n' > /tmp/openscad-mxe-preinclude.h

cd "$DEPLOYDIR"
qmake "$source_root/openscad.pro" \
  CONFIG+=release CONFIG+=deploy CONFIG+=link_pkgconfig CONFIG+=mingw-cross-env \
  CONFIG-=debug CONFIG-=experimental \
  "QMAKE_CXXFLAGS+=-I${cgal_prefix}/include" \
  "QMAKE_LFLAGS+=-L${cgal_prefix}/lib" \
  "QMAKE_CXXFLAGS+=-include /tmp/openscad-mxe-preinclude.h"
# Match the upstream cross-build workaround for parallel parser generation.
touch -t 200012121010 "$source_root/src/parser_yacc.h" \
  "$source_root/src/parser_yacc.cpp" "$source_root/src/parser_yacc.hpp" \
  "$source_root/src/lexer_lex.cpp"
make -j"$NUMCPU" release
test -s release/openscad.exe

# The upstream console wrapper allows a later Windows command-line smoke test.
qmake "$source_root/winconsole/winconsole.pro" CONFIG+=release CONFIG-=debug
make -j"$NUMCPU"
test -s release/openscad.com

output="$source_root/dist/openscad-ui-preview"
mkdir -p "$output/fonts"
cp release/openscad.exe release/openscad.com "$output/"
cp -a "$source_root/color-schemes" "$source_root/templates" "$source_root/examples" "$output/"
cp -a "$source_root/fonts/10-liberation.conf" "$source_root/fonts/Liberation-2.00.1" "$output/fonts/"
cp -a "$MXETARGETDIR/etc/fonts/." "$output/fonts/"
tar -C "$source_root" --exclude='.git' --exclude='.git*' -cf - libraries | tar -C "$output" -xf -
cp "$source_root/COPYING" "$output/"
printf 'cube([20,20,20], center=true);\n' > "$output/cube.scad"
printf '@echo off\r\nstart "" "%%~dp0openscad.exe" "%%~dp0cube.scad"\r\n' > "$output/Open-UI.cmd"
cat > "$output/START-HERE.txt" <<'EOF'
OpenSCAD 2021.01 — UI proposal

Extract the entire artifact before running Open-UI.cmd.
Press F5 to preview cube.scad, then inspect the editor, viewport, console and ASSIST.
ASSIST is deliberately offline. Its prompt and send button are disabled.
If you already use OpenSCAD, saved preferences take priority over theme defaults:
select Tomorrow Night for both editor syntax and 3D view in Preferences if needed.
This is an unsigned test build, not an installer or release.
EOF
{
  printf 'Source commit: %s\n' "$(git -C "$source_root" rev-parse HEAD)"
  printf 'Base: openscad-2021.01 / 41f58fe57c03457a3a8b4dc541ef5654ec3e8c78\n'
  printf 'Build image: %s\n' "$BUILD_IMAGE"
  printf 'CGAL compatibility dependency: 4.14 (cross-built in runner)\n'
  qmake -v
  "${MXE_TARGETS}-g++" --version
} > "$output/BUILD-INFO.txt"
"${MXE_TARGETS}-objdump" -f "$output/openscad.exe"
(cd "$output" && sha256sum openscad.exe openscad.com > SHA256SUMS.txt)
