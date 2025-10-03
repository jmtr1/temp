#!/bin/bash

# Install Inkscape AppImage
INKSCAPE_APPIMAGE="inkscape.appimage"
wget https://sourceforge.net/projects/inkscape/files/Inkscape-ebf0e94-x86_64.AppImage/download -O "$INKSCAPE_APPIMAGE"
chmod +x "$INKSCAPE_APPIMAGE"
./"$INKSCAPE_APPIMAGE" --appimage-extract
./squashfs-root/AppRun --version
sudo ln -sf "$(pwd)/squashfs-root/AppRun" /usr/local/bin/inkscape

# Install Material Icon Theme extension
wget --retry-on-http-error=429 https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix -O material-icon-theme.vsix
code-server --install-extension "$(pwd)/material-icon-theme.vsix"

wget --retry-on-http-error=429 https://github.com/jmtr1/temp/raw/refs/heads/main/jupyterlab-light-theme.vsix -O jupyterlab-light-theme.vsix
code-server --install-extension "$(pwd)/jupyterlab-light-theme.vsix"

code-server --uninstall-extension github.copilot-chat

# Install Python packages (commented for now) NEW
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18

# Update VSCode settings
SETTINGS_FILE="${HOME}/.local/share/code-server/User/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "No existing settings.json found. Creating a new one."
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" > "$SETTINGS_FILE"
fi

jq '. + {
    "workbench.colorTheme": "JupyterLab Light Theme",
    "workbench.iconTheme": "material-icon-theme",
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "notebook.output.fontSize": 13,
    "notebook.output.scrolling": true,
    "editor.fontFamily": "JetBrains Mono",
    "editor.fontSize": 13,
    "workbench.startupEditor": "none",
    "workbench.secondarySidebar.enabled": false,
    "chat.editor.showChat": false,
    "chat.experimental.showOnStartup": false
    "workbench.panel.chat.enabled": false
    "welcomePage.walkthroughs.openOnInstall": false,
    "editor.gettingStartedPreferences.experimental.showOnStartup": "off",
    "files.exclude": {
        "**/__pycache__": true,
        "**/.env": true,
        "**/.lnk": true,
        "**/.vscode": true,
        "**/*.lnk": true,
        "**/requirements.txt": true,
        "**/.cache": true
    }
}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

rm -rf squashfs-root inkscape.appimage material-icon-theme.vsix jupyterlab-light-theme.vsix
