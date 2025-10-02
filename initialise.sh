#!/bin/bash

set -e

# Install Python packages
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18

# Install VS Code icon theme extension
code-server --install-extension PKief.material-icon-theme

# Download the theme .vsix file
THEME_URL="https://github.com/jmtr1/temp/raw/refs/heads/main/jupyterlab-light-theme.vsix"
THEME_VSIX="jupyterlab-light-theme.vsix"

curl -fSL "$THEME_URL" -o "$THEME_VSIX"

# Install the theme extension
code-server --install-extension "$THEME_VSIX"

# Remove the downloaded .vsix file after installing
rm -f "$THEME_VSIX"

# Path to the VSCode settings.json file (for code-server)
SETTINGS_FILE="${HOME}/.local/share/code-server/User/settings.json"

# If settings.json doesn’t exist, initialize it
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "No existing settings.json found. Creating a new one."
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" > "$SETTINGS_FILE"
fi

# Use jq to update or add settings
jq '. + {
    "workbench.iconTheme": "material-icon-theme",
    "workbench.colorTheme": "JupyterLab Light Theme",
    "editor.rulers": [80, 100, 120],
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "flake8.args": ["--max-line-length=100"]
}' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"
