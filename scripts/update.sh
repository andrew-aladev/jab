#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

git fetch --all || :
git fetch --tags || :
git remote | xargs -I {} git rebase "{}/$(git branch --show-current)" || :

cd ".."

ROOT_DIR=$(pwd)

rm -f "Gemfile.lock"

/usr/bin/env bash -cl "\
  yarn add npm-check-updates && \
  yarn exec ncu -- --upgrade && \
  yarn install && \
  cd \"$ROOT_DIR\" && \
  gem install bundler --force && \
  bundle update \
"

./scripts/font/all.sh
./scripts/img/favicon.sh
./scripts/img/sprites.sh
