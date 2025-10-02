#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# --- Helpers ---
log() {
    echo "[$(date --iso-8601=seconds)] $*"
}

# Run apt commands, retry if locked
apt_update_install() {
    local pkgs=("$@")
    log "Updating package lists"
    sudo apt-get update -y
    log "Installing packages: ${pkgs[*]}"
    sudo apt-get install -y "${pkgs[@]}"
}

# Symlink helper (overwrite if exists)
safe_symlink() {
    local target=$1
    local linkname=$2
    if [ -e "$linkname" ] || [ -L "$linkname" ]; then
        sudo rm -f "$linkname"
    fi
    sudo ln -s "$target" "$linkname"
}

# --- Main steps ---

log "Step: system packages"
apt_update_install ghostscript pstoedit wget jq

log "Step: install Inkscape via AppImage"
INK_IMG="inkscape.appimage"
INK_URL="https://sourceforge.net/projects/inkscape/files/Inkscape-ebf0e94-x86_64.AppImage/download"

if [ ! -f "$INK_IMG" ]; then
    wget -O "$INK_IMG" "$INK_URL"
    chmod +x "$INK_IMG"
fi

# Clean existing extraction if exists
if [ -d "squashfs-root" ]; then
    log "Removing old squashfs-root"
    rm -rf squashfs-root
fi

log "Extracting AppImage"
./"$INK_IMG" --appimage-extract

# Check version
if ! ./squashfs-root/AppRun --version >/dev/null 2>&1; then
    log "ERROR: Inkscape AppRun failed version test"
    exit 1
fi

INSTALL_BIN="/usr/local/bin/inkscape"
log "Symlinking Inkscape to $INSTALL_BIN"
safe_symlink "$(pwd)/squashfs-root/AppRun" "$INSTALL_BIN"

# Ensure executable
sudo chmod +x "$INSTALL_BIN"

# --- VS Code / code-server setup ---

log "Installing VS Code icon theme extension"
code-server --install-extension PKief.material-icon-theme

THEME_URL="https://github.com/jmtr1/temp/raw/refs/heads/main/jupyterlab-light-theme.vsix"
THEME_VSIX="jupyterlab-light-theme.vsix"

log "Downloading theme vsix"
curl -fSL "$THEME_URL" -o "$THEME_VSIX"

log "Installing theme extension"
code-server --install-extension "$THEME_VSIX"

log "Cleaning up theme vsix"
rm -f "$THEME_VSIX"

SETTINGS_FILE="${HOME}/.local/share/code-server/User/settings.json"
log "Ensuring settings file exists at $SETTINGS_FILE"
if [ ! -f "$SETTINGS_FILE" ]; then
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" > "$SETTINGS_FILE"
fi

log "Updating settings.json"
jq '. + {
    "workbench.iconTheme": "material-icon-theme",
    "workbench.colorTheme": "JupyterLab Light Theme",
    "editor.rulers": [80, 100, 120],
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "flake8.args": ["--max-line-length=100"],
    "editor.fontFamily": "JetBrains Mono, monospace",
    "editor.fontLigatures": true
}' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

log "Installing Python packages"
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert "botocore==1.40.18"

log "Script finished successfully"
