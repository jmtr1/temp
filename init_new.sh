#!/bin/bash
exec > >(tee -a /home/onyxia/init.log) 2>&1
set -euxo pipefail

echo "[Init] Running init.sh"

# Example step
date

# Download and install
wget -O /tmp/material-icon-theme.vsix \
  https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix
code-server --install-extension /tmp/material-icon-theme.vsix --force
