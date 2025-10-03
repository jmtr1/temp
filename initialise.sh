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

# Install and persist Material Icon Theme extension
materialIconVersion="5.27.0"
MATERIAL_VSIX="material-icon-theme.vsix"

# Download to working dir
wget "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/PKief/vsextensions/material-icon-theme/${materialIconVersion}/vspackage" -O "$MATERIAL_VSIX"

# Also copy it to /usr/local/bin for persistence
sudo cp "$MATERIAL_VSIX" /usr/local/bin/

# Install it into code-server
code-server --install-extension "$MATERIAL_VSIX" --force

# Cleanup local working copy
rm "$MATERIAL_VSIX"
