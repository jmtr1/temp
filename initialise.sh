#!/bin/bash

set -e

# Install GDAL Python package with numpy-based raster support
# See : https://pypi.org/project/GDAL/
uv pip install --system torch dask transformers ipywidgets boto3 openai dotenv optuna
