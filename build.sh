#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TARGET_DIR="$SCRIPT_DIR/target"
THEMES_DIR="${THEMES_DIR:-"$SCRIPT_DIR/../themes/themes"}"
RENDER_TMP="$(mktemp -d)"
cd "$SCRIPT_DIR"

cleanup() {
    # TODO: Should probably use git restore here
    if [[ -f stylesheets/lfs-xsl/lfs.css.bak ]]; then
        mv -vf stylesheets/lfs-xsl/lfs.css{.bak,}
    fi

    rm -rf "$RENDER_TMP"
}

trap 'cleanup' EXIT INT HUP

if [[ -n ${THEME:-} ]] && [[ -f stylesheets/lfs-xsl/lfs.css ]]; then
    mv -vf stylesheets/lfs-xsl/lfs.css{,.bak}
    cp -vf "$THEMES_DIR/$THEME.lfs.css" stylesheets/lfs-xsl/lfs.css
fi

make                                \
    REV=systemd                     \
    RENDERTMP="$RENDER_TMP"         \
    SHELL="/usr/bin/env bash"       \
    BASEDIR="$TARGET_DIR/book"      \
    DUMPDIR="$TARGET_DIR/commands"  \
    -j16
