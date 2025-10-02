#!/bin/bash

set -e

# Install Python packages
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna lightgbm wandb openpyxl nbconvert botocore==1.40.18

# Install VS Code extensions
code-server --install-extension PKief.material-icon-theme
code-server --install-extension miguelcorraljr.jupyterlab-light-theme

# Ensure VS Code settings directory exists
mkdir -p ~/.config/Code/User

# Write VS Code settings
cat > ~/.config/Code/User/settings.json <<EOF
{
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "JupyterLab Light Theme"
}
EOF

