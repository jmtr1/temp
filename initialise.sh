#!/bin/bash

set -e

# Install Python packages
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18

# Install Node.js and npm (needed to build the theme)
sudo apt-get update
sudo apt-get install -y nodejs npm

# Install VSCE (VS Code Extension Manager) globally
sudo npm install -g vsce

# Install VS Code extension from Open VSX
code-server --install-extension PKief.material-icon-theme

# Build and install JupyterLab Light Theme extension
git clone https://github.com/corralm/vscode-jupyterlab-theme.git
cd vscode-jupyterlab-theme
npm install
vsce package
# Install the generated .vsix
VSIX_FILE=$(ls *.vsix | head -n 1)
code-server --install-extension "$VSIX_FILE"
cd ..
# Clean up the theme source directory
rm -rf vscode-jupyterlab-theme

# Ensure VS Code settings directory exists
mkdir -p ~/.config/Code/User

# Write VS Code settings
cat > ~/.config/Code/User/settings.json <<EOF
{
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "JupyterLab Light Theme"
}
EOF
