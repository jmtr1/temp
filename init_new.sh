#!/bin/bash
set -e

# Download the vsix
wget -O /tmp/material-icon-theme.vsix https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix

# Install it into the user’s extensions folder
code-server --install-extension /tmp/material-icon-theme.vsix --extensions-dir /home/onyxia/.local/share/code-server/extensions

# Clean up
rm /tmp/material-icon-theme.vsix
