#!/bin/bash
exec > >(tee -a ~/init.log) 2>&1
set -euxo pipefail

echo "[Init] Starting VSIX download and install"

wget -O /tmp/material-icon-theme.vsix \
  https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix

ls -lh /tmp/material-icon-theme.vsix

code-server --install-extension /tmp/material-icon-theme.vsix --force

echo "[Init] Installed extensions are now:"
code-server --list-extensions || true

echo "[Init] Done."
