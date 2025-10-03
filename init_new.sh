#!/bin/bash
set -e

# Download your icon theme extension
wget -O /tmp/material-icon-theme.vsix https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix

# Install the extension into VS Code
code-server --install-extension /tmp/material-icon-theme.vsix

# Optional: clean up
rm /tmp/material-icon-theme.vsix
