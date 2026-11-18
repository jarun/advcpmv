#!/bin/sh

set -e

PATCH_FILE=
case "${1##*/}" in
    advcpmv-*)
        PATCH_FILE=$1
        NAME=${PATCH_FILE##*/}
        NAME=${NAME#advcpmv-}
        NAME=${NAME%.patch}
        ADVCPMV_VERSION=${NAME%-*}
        CORE_UTILS_VERSION=${NAME##*-}
        case "$PATCH_FILE" in
            /*) ;;
            *) PATCH_FILE="$PWD/$PATCH_FILE" ;;
        esac
        ;;
    *)
        ADVCPMV_VERSION=${1:-1.0}
        CORE_UTILS_VERSION=${2:-9.12}
        ;;
esac

curl -LO https://ftp.gnu.org/gnu/coreutils/coreutils-$CORE_UTILS_VERSION.tar.xz
tar xvJf coreutils-$CORE_UTILS_VERSION.tar.xz
rm coreutils-$CORE_UTILS_VERSION.tar.xz
(
    cd coreutils-$CORE_UTILS_VERSION/
    if [ -n "$PATCH_FILE" ]; then
        cp "$PATCH_FILE" "advcpmv-$ADVCPMV_VERSION-$CORE_UTILS_VERSION.patch"
    else
        curl -LO https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-$ADVCPMV_VERSION-$CORE_UTILS_VERSION.patch
    fi
    patch -p1 -i advcpmv-$ADVCPMV_VERSION-$CORE_UTILS_VERSION.patch
    ./configure
    make
    cp ./src/cp ../advcp
    cp ./src/mv ../advmv
)
rm -rf coreutils-$CORE_UTILS_VERSION
