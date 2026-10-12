#!/usr/bin/env bash
# Install the repository's git hooks. Run once per clone:
#   scripts/install-hooks.sh
#
# Hooks are copied into the shared hooks directory, so every worktree of this
# clone is covered, including branches that do not have .githooks/ yet.

set -euo pipefail

root="$(git rev-parse --show-toplevel)"
hooks_dir="$(cd "$root" && cd "$(git rev-parse --git-common-dir)" && pwd)/hooks"

mkdir -p "$hooks_dir"
for hook in "$root"/.githooks/*; do
  name="$(basename "$hook")"
  cp "$hook" "$hooks_dir/$name"
  chmod +x "$hooks_dir/$name"
  echo "installed $name -> $hooks_dir/$name"
done
