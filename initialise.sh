#!/bin/bash

# Install required system packages
sudo apt-get update
sudo apt-get install -y ghostscript pstoedit wget jq curl

# Install Inkscape AppImage
INKSCAPE_APPIMAGE="inkscape.appimage"
wget https://sourceforge.net/projects/inkscape/files/Inkscape-ebf0e94-x86_64.AppImage/download -O "$INKSCAPE_APPIMAGE"
chmod +x "$INKSCAPE_APPIMAGE"
./"$INKSCAPE_APPIMAGE" --appimage-extract
./squashfs-root/AppRun --version
sudo ln -sf "$(pwd)/squashfs-root/AppRun" /usr/local/bin/inkscape

# Cleanup Inkscape files
rm -rf squashfs-root
rm -f "$INKSCAPE_APPIMAGE"

materialIconVersion="5.27.0"
wget --retry-on-http-error=429 "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/PKief/vsextensions/material-icon-theme/${materialIconVersion}/vspackage" -O material-icon-theme.vsix.gz
gzip -d material-icon-theme.vsix.gz
code-server --install-extension material-icon-theme.vsix --force
rm material-icon-theme.vsix




