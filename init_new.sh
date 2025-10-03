#!/bin/bash
set -euxo pipefail

echo "[Init] Starting VSIX download and install"

# Download
wget -O /tmp/material-icon-theme.vsix \
  https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix

ls -lh /tmp/material-icon-theme.vsix

# Install into code-server
code-server --install-extension /tmp/material-icon-theme.vsix --force

# Confirm installation
echo "[Init] Installed extensions are now:"
code-server --list-extensions || true

echo "[Init] Done."
