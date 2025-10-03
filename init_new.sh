#!/bin/sh
# Redirect stdout and stderr to a log file
exec > /home/onyxia/work/init.log 2>&1
set -eux

echo ">>> Init script started at $(date) <<<"

# Download the Material Icon Theme VSIX
wget --retry-on-http-error=429 \
  https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix \
  -O /tmp/material-icon-theme.vsix

ls -lh /tmp/material-icon-theme.vsix

# Install it into code-server
code-server --install-extension /tmp/material-icon-theme.vsix --force

# Clean up
rm /tmp/material-icon-theme.vsix

echo ">>> Installed extensions are now:"
code-server --list-extensions || true

echo ">>> Init script finished at $(date) <<<"
