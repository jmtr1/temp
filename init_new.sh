#!/bin/sh

# Install icon theme
wget --retry-on-http-error=429 https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix
code-server --install-extension pkief.material-icon-theme-5.27.0.vsix
rm material-icon-theme.vsix
