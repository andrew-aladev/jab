#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../../src/img"

while read -r icon; do
  echo "- optimizing icon: $icon"
  pngcrush -ow -brute "$icon"
done < <(find "favicon" -type f -name "*.png")

echo "- creating favicon.ico"
convert "favicon/"*.png "generated/favicon.ico"
