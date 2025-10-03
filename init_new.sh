#!/bin/sh
set -e

# Download gzipped VSIX from Marketplace and save with a known name
wget -O material-icon-theme.vsix.gz \
  "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/PKief/vsextensions/material-icon-theme/5.27.0/vspackage"

# Decompress to VSIX
gzip -d material-icon-theme.vsix.gz

# Install into code-server
code-server --install-extension material-icon-theme.vsix --force

# Cleanup
rm material-icon-theme.vsix
