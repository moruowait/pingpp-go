#!/bin/bash

set -bue

readonly ref="${1-upstream/master}"
readonly patches="$(mktemp -d)"
cp patches/* "${patches}"

git fetch --tags -q upstream
git checkout -q "${ref}"

readonly branch="patched-$(git log -1 --format="%H")"

git branch -D -f "${branch}" || true
git checkout -q -b "${branch}"

git am "${patches}"/*

git tag -f "${branch}"
git push -u -f origin tag "${branch}"

git checkout patch
git branch -D "${branch}"
