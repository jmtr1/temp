#!/bin/bash
set -e

# Location of your .vsix extension
EXT_URL="https://github.com/jmtr1/temp/raw/refs/heads/main/pkief.material-icon-theme-5.27.0.vsix"
EXT_FILE="/tmp/material-icon-theme.vsix"

# Download the extension
curl -L "$EXT_URL" -o "$EXT_FILE"

# Install it in VS Code
code --install-extension "$EXT_FILE" --force

# (Optional) Set it as the default icon theme in settings.json
SETTINGS_FILE="$HOME/.vscode-server/data/Machine/settings.json"
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Merge/update settings.json
if [ ! -f "$SETTINGS_FILE" ]; then
    echo '{}' > "$SETTINGS_FILE"
fi

jq '. + {"workbench.iconTheme": "material-icon-theme"}' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

echo "✅ Material Icon Theme installed and activated"
