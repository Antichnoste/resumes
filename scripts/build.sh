#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
export TEXINPUTS="./latex:${TEXINPUTS:-}"
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT
mkdir -p docs

build_resume() {
    local source=$1 output=${1%.tex}.pdf
    pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$build_dir" "$source"
    pdflatex -interaction=nonstopmode -halt-on-error -output-directory="$build_dir" "$source"
    cp "$build_dir/${source%.tex}.pdf" "docs/$output"
}

shopt -s nullglob
sources=( *.tex )
if (( ${#sources[@]} == 0 )); then
    echo 'В корне репозитория не найдено файлов .tex' >&2
    exit 1
fi

for source in "${sources[@]}"; do
    build_resume "$source"
done
