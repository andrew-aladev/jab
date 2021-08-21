#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd "../.."

yarn run sprites

cd "src/img"

while read -r sprite; do
  echo "- optimizing sprite: $sprite"
  pngcrush -ow -brute "$sprite"
done < <(find "generated" -type f -name "*.png")
