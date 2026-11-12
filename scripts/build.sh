#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT
mkdir -p docs

build_resume() {
    local source=$1 output=$2
    pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$build_dir" "$source"
    pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$build_dir" "$source"
    cp "$build_dir/${source%.tex}.pdf" "docs/$output"
}

build_resume ML.tex ml.pdf
build_resume ML_VK.tex ml-vk.pdf
build_resume Back.tex backend.pdf
build_resume Back_python.tex backend-python.pdf
