#!/usr/bin/env bash
# Configure, build and smoke-test a patched coreutils source tree.
# Usage: build-and-test.sh <coreutils-source-dir>
# Optional environment: EXTRA_CFLAGS (e.g. -std=gnu17).
set -euo pipefail

cd "$1"
RUNNER_TEMP="${RUNNER_TEMP:-${TMPDIR:-/tmp}}"

echo "::group::Configure"
./configure CFLAGS="-g -O2 ${EXTRA_CFLAGS:-}" > configure.log 2>&1 || { tail -n 50 configure.log; exit 1; }
echo "::endgroup::"

# A full build is needed: building only src/cp and src/mv skips the gnulib
# BUILT_SOURCES (lib/wchar.h, lib/limits.h, ...) and fails.
echo "::group::Build coreutils"
make -j"$(nproc)"
echo "::endgroup::"

test -x src/cp
test -x src/mv
src/cp --version | head -n1
src/mv --version | head -n1

CP="$PWD/src/cp"
MV="$PWD/src/mv"

# Source lives in /dev/shm (tmpfs) and destination in RUNNER_TEMP, so
# that mv has to copy across filesystems instead of just renaming.
SRC=$(mktemp -d /dev/shm/advcpmv-src.XXXXXX)
DST=$(mktemp -d "$RUNNER_TEMP/advcpmv-dst.XXXXXX")

head -c 20M /dev/urandom > "$SRC/file.bin"
mkdir -p "$SRC/tree/sub"
head -c 5M /dev/urandom > "$SRC/tree/a.bin"
head -c 5M /dev/urandom > "$SRC/tree/sub/b.bin"
expected=$(sha256sum "$SRC/file.bin" | cut -d' ' -f1)

# The progress bar is only drawn on a terminal, so run under a pty.
run_tty() {
  script -qec "$*" /dev/null
}

echo "::group::cp -g (single file)"
out=$(run_tty "$CP -g $SRC/file.bin $DST/cp-file.bin")
printf '%s\n' "$out" | tr '\r' '\n' | tail -n 3
if ! printf '%s' "$out" | grep -q '%'; then
  echo "::error::cp -g printed no progress output"
  exit 1
fi
cmp "$SRC/file.bin" "$DST/cp-file.bin"
echo "::endgroup::"

echo "::group::cp -g -r (directory)"
run_tty "$CP -g -r $SRC/tree $DST/cp-tree" > /dev/null
diff -r "$SRC/tree" "$DST/cp-tree"
echo "::endgroup::"

echo "::group::mv -g (single file, across filesystems)"
out=$(run_tty "$MV -g $SRC/file.bin $DST/mv-file.bin")
printf '%s\n' "$out" | tr '\r' '\n' | tail -n 3
if ! printf '%s' "$out" | grep -q '%'; then
  echo "::error::mv -g printed no progress output"
  exit 1
fi
if [ -e "$SRC/file.bin" ]; then
  echo "::error::mv -g left the source file behind"
  exit 1
fi
actual=$(sha256sum "$DST/mv-file.bin" | cut -d' ' -f1)
if [ "$expected" != "$actual" ]; then
  echo "::error::mv -g produced a file with different contents"
  exit 1
fi
echo "::endgroup::"

echo "::group::mv -g (directory, across filesystems)"
cp -r "$DST/cp-tree" "$SRC/tree-copy"
run_tty "$MV -g $SRC/tree-copy $DST/mv-tree" > /dev/null
if [ -e "$SRC/tree-copy" ]; then
  echo "::error::mv -g left the source directory behind"
  exit 1
fi
diff -r "$DST/cp-tree" "$DST/mv-tree"
echo "::endgroup::"
