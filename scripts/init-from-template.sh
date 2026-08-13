#!/usr/bin/env bash
# Run once, right after generating a new repo from oliverlorenz/.lib-typescript
# via "Use this template". Replaces <REPO_NAME> placeholders with the real
# repo name (read from the `origin` remote), strips template-only
# scaffolding, commits the result, and removes itself.
#
# .github/workflows/template-bootstrap.yml does the same thing automatically
# on the first push to main, as a safety net for anyone who skips this
# script — running this manually just gets you there immediately.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

REMOTE_URL="$(git remote get-url origin)"
REPO_NAME="$(basename -s .git "$REMOTE_URL")"

./scripts/replace-template-placeholders.sh "$REPO_NAME"

rm -f .github/workflows/template-bootstrap.yml scripts/replace-template-placeholders.sh scripts/init-from-template.sh

git add -A
git commit -m "chore: bootstrap repo from .lib-typescript template

Replaces <REPO_NAME> placeholders with ${REPO_NAME} and removes
template-only scaffolding."

echo "Done. Review the changes, fill in package.json's description, then push."
