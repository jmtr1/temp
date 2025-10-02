#!/bin/bash

set -e

# Install Python packages
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18

# Install VS Code extension from Open VSX
code-server --install-extension PKief.material-icon-theme

# Build and install JupyterLab Light Theme extension
if [ ! -d "vscode-jupyterlab-theme" ]; then
  git clone https://github.com/corralm/vscode-jupyterlab-theme.git
fi
cd vscode-jupyterlab-theme
npm install
npx vsce package
# Install the generated .vsix (filename will match package version, e.g. jupyterlab-light-theme-x.y.z.vsix)
VSIX_FILE=$(ls *.vsix | head -n 1)
code-server --install-extension "$VSIX_FILE"
cd ..

# Ensure VS Code settings directory exists
mkdir -p ~/.config/Code/User

# Write VS Code settings
cat > ~/.config/Code/User/settings.json <<EOF
{
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "JupyterLab Light Theme"
}
EOF
