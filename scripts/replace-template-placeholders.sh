#!/usr/bin/env bash
# Replaces leftover <REPO_NAME> placeholders from the oliverlorenz/.lib-typescript
# template with the real repo name, and strips template-only scaffolding
# (marked with `template-bootstrap:remove-*`) from tracked files.
#
# Used by both scripts/init-from-template.sh (manual, run locally right
# after generating a repo) and .github/workflows/template-bootstrap.yml
# (automatic safety net that runs on the first push to main).

set -euo pipefail

REPO_NAME="${1:?Usage: $0 <repo-name>}"

if [[ "$REPO_NAME" == ".lib-typescript" ]]; then
  echo "Refusing to run against the template repo itself." >&2
  exit 1
fi

cd "$(git rev-parse --show-toplevel)"

PLACEHOLDER_FILES=(
  package.json
  README.md
  CLAUDE.md
  .devcontainer/devcontainer.json
  src/index.ts
)

for file in "${PLACEHOLDER_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    sed -i "s/<REPO_NAME>/${REPO_NAME}/g" "$file"
  fi
done

for file in .github/workflows/release.yml CLAUDE.md; do
  if [[ -f "$file" ]]; then
    sed -i '/template-bootstrap:remove-start/,/template-bootstrap:remove-end/d' "$file"
    sed -i '/template-bootstrap:remove-line/d' "$file"
  fi
done

npm install
