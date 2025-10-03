#!/bin/sh

# Install Inkscape AppImage
INKSCAPE_APPIMAGE="inkscape.appimage"
wget https://sourceforge.net/projects/inkscape/files/Inkscape-ebf0e94-x86_64.AppImage/download -O "$INKSCAPE_APPIMAGE"
chmod +x "$INKSCAPE_APPIMAGE"
./"$INKSCAPE_APPIMAGE" --appimage-extract
./squashfs-root/AppRun --version
sudo ln -sf "$(pwd)/squashfs-root/AppRun" /usr/local/bin/inkscape


# Install Material Icon Theme extension
wget --retry-on-http-error=429 \
  https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix \
  -O material-icon-theme.vsix

code-server --install-extension material-icon-theme.vsix


# Install Python packages
#uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18



#!/bin/bash

# This init script updates settings of VSCode.
# See here for the default settings enforced in Onyxia's VSCode-based images :
# https://github.com/InseeFrLab/images-datascience/blob/main/vscode/settings/User.json

# Path to the VSCode settings.json file
SETTINGS_FILE="${HOME}/.local/share/code-server/User/settings.json"

# Check if the settings.json file exists, otherwise create a new one
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "No existing settings.json found. Creating a new one."
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" > "$SETTINGS_FILE"  # Initialize with an empty JSON object
fi

# Add or modify VSCode settings using jq
jq '. + {
    "workbench.colorTheme": "Default Dark Modern",  # Set the theme
    "workbench.iconTheme": "material-icon-theme",   # Set the icon theme

    "editor.rulers": [80, 100, 120],  # Add specific vertical rulers
    "files.trimTrailingWhitespace": true,  # Automatically trim trailing whitespace
    "files.insertFinalNewline": true,      # Ensure files end with a newline

    "flake8.args": [
        "--max-line-length=100"  # Max line length for Python linting
    ]
}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

