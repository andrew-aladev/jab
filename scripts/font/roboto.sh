#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

CURRENT_DIR=$(pwd)

cd "../../src/font/roboto"

ARCHIVE_URL="https://github.com/googlefonts/roboto/releases/latest/download/roboto-unhinted.zip"

FONT_NAMES=(
  "Roboto-Bold"
  "Roboto-BoldItalic"
  "Roboto-Italic"
  "Roboto-Regular"
)

FONT_FILES=()
for font_name in "${FONT_NAMES[@]}"; do
  FONT_FILES+=("${font_name}.ttf")
done

OTHER_FILES=("LICENSE")
ALL_FILES=("${FONT_FILES[@]}" "${OTHER_FILES[@]}")

EXTENSIONS_FOR_CONVERT=(
  "eot"
  "svg"
  "woff"
  "woff2"
)

CONVERT_SCRIPT="${CURRENT_DIR}/convert.pe"

# Downloading archive.
ARCHIVE=$(mktemp)
wget "$ARCHIVE_URL" -O "$ARCHIVE"

# Unpacking archive.
ARCHIVE_DIR=$(mktemp --directory)
unzip -o "$ARCHIVE" -d "$ARCHIVE_DIR" "${ALL_FILES[@]}"
rm "$ARCHIVE"

# Testing if some file has been updated.
some_file_updated=false

for file in "${ALL_FILES[@]}"; do
  if ! cmp --silent "${ARCHIVE_DIR}/${file}" "$file"; then
    some_file_updated=true
  fi
done

# Converting and copying files
if [ "$some_file_updated" = true ]; then
  for file in "${OTHER_FILES[@]}"; do
    cp "${ARCHIVE_DIR}/${file}" "$file"
  done

  for index in ${!FONT_NAMES[@]}; do
    font_name="${FONT_NAMES[$index]}"
    font_file="${FONT_FILES[$index]}"

    cp "${ARCHIVE_DIR}/${font_file}" "$font_file"

    for extension in "${EXTENSIONS_FOR_CONVERT[@]}"; do
      fontforge -script "$CONVERT_SCRIPT" "$font_file" "${font_name}.${extension}"
    done

    rm "${font_name}.afm"
  done
fi

rm -r "$ARCHIVE_DIR"
