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

# Install Python packages (needs bash for uv)
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18

# Install Material Icon Theme from VSIX
ICON_VSIX="pkief.material-icon-theme-5.27.0.vsix"
curl -fSL "https://github.com/jmtr1/temp/raw/refs/heads/main/$ICON_VSIX" -o "$ICON_VSIX"
code-server --install-extension "$ICON_VSIX"
rm -f "$ICON_VSIX"

# Install JupyterLab Light Theme from VSIX
THEME_VSIX="jupyterlab-light-theme.vsix"
curl -fSL "https://github.com/jmtr1/temp/raw/refs/heads/main/$THEME_VSIX" -o "$THEME_VSIX"
code-server --install-extension "$THEME_VSIX"
rm -f "$THEME_VSIX"

# Path to VSCode settings.json
SETTINGS_FILE="${HOME}/.local/share/code-server/User/settings.json"

# Ensure settings.json exists
if [ ! -f "$SETTINGS_FILE" ]; then
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" > "$SETTINGS_FILE"
fi

# Update settings.json
jq '. + {
    "workbench.iconTheme": "material-icon-theme",
    "workbench.colorTheme": "JupyterLab Light Theme",
    "editor.rulers": [80, 100, 120],
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "flake8.args": ["--max-line-length=100"],
    "editor.fontFamily": "JetBrains Mono, monospace",
    "editor.fontLigatures": true
}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
