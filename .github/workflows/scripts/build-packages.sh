#!/bin/bash

BUILD_ENVIRONMENT=$1
if [[ -z "$BUILD_ENVIRONMENT" ]]; then
  echo "Usage: $0 <build-environment>"
  exit 1
fi
OUT_DIR=out
REPO_DIR=arch-repo
PKGS_FILE=packages.json
STATE_FILE=build-state.json

mkdir -p "$OUT_DIR"
OUT_DIR=$(realpath "$OUT_DIR"/)
updated_state=$(cat $STATE_FILE)

for row in $(jq -c ".[] | select(.environment == \"$BUILD_ENVIRONMENT\")" $PKGS_FILE); do
  name="$(echo "$row" | jq -r '.name')"
  repo="$(echo "$row" | jq -r '.repo')"
  path="$(echo "$row" | jq -r '.path')"

  echo "::group::$name"
  if [[ "$repo" != "https://github.com/$GITHUB_REPOSITORY" ]]; then
    latest_sha=$(git ls-remote "$repo" HEAD | cut -f1 | tail -n1)
  else
    pushd $REPO_DIR
    latest_sha=$(git log -n 1 --format=%H -- "$path")
    popd
  fi
  cached_sha=$(jq -r --arg name "$name" '.[$name] // ""' $STATE_FILE)

  if [[ "$latest_sha" != "$cached_sha" ]]; then
    echo "Building $name"
    git clone --depth=1 "$repo" src/$name
    pushd "src/$name/$path"
    makepkg -s --noconfirm --clean --sign --skippgpcheck
    mv *.pkg.tar.xz *.sig "$OUT_DIR"
    popd
    updated_state=$(echo "$updated_state" | jq --arg name "$name" --arg sha "$latest_sha" '. + {($name): $sha}')
  else
    echo "Skipping $name (unchanged)"
    updated_state=$(echo "$updated_state" | jq --arg name "$name" --arg sha "$cached_sha" '. + {($name): $sha}')
  fi
  echo "::endgroup::"
done

echo "$updated_state" > $STATE_FILE