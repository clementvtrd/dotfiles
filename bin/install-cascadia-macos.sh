#!/usr/bin/env bash
set -euo pipefail

URL="https://github.com/microsoft/cascadia-code/releases/download/v2407.24/CascadiaCode-2407.24.zip"
TMPDIR="$(mktemp -d)"
ZIP="${TMPDIR}/cascadia.zip"
OUTDIR="${TMPDIR}/fonts"
USER_INSTALL_DIR="${HOME}/Library/Fonts"

usage() {
  cat <<EOF
Usage: $0 [--system|-s]

Downloads Cascadia Code and installs fonts for the current user by default.
Use --system to install to /Library/Fonts (requires sudo).
EOF
  exit 1
}

SYSTEM_INSTALL=0
if [ "${1-}" = "--system" ] || [ "${1-}" = "-s" ]; then
  SYSTEM_INSTALL=1
elif [ "${1-}" = "--help" ] || [ "${1-}" = "-h" ]; then
  usage
fi

echo "Downloading Cascadia Code from ${URL}..."
curl -L -f -o "${ZIP}" "${URL}"

mkdir -p "${OUTDIR}"
unzip -q "${ZIP}" -d "${TMPDIR}"

# Collect font files (.ttf, .otf)
find "${TMPDIR}" -type f \( -iname '*.ttf' -o -iname '*.otf' \) -exec cp -v {} "${OUTDIR}/" \;

if [ ${SYSTEM_INSTALL} -eq 1 ]; then
  echo "Installing system-wide to /Library/Fonts (sudo required)..."
  sudo mkdir -p /Library/Fonts
  sudo cp -v "${OUTDIR}"/* /Library/Fonts/
else
  echo "Installing to ${USER_INSTALL_DIR}..."
  mkdir -p "${USER_INSTALL_DIR}"
  cp -v "${OUTDIR}"/* "${USER_INSTALL_DIR}/"
fi

echo "Cleaning up ${TMPDIR}"
rm -rf "${TMPDIR}"

echo "Cascadia Code installed. Restart apps to see the new fonts."
