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
