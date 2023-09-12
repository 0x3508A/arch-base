#!/usr/bin/env bash
if [ ! -e "./venv" ]; then
python -m venv venv
source ./venv/Scripts/activate
python.exe -m pip install --upgrade pip
pip install mkdocs-material
pip install pillow cairosvg mkdocs-minify-plugin
else
source ./venv/Scripts/activate
fi
mkdocs serve
