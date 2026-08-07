#!/usr/bin/env bash
# Creates (or bumps) a "sync with template" issue in every repo generated
# from oliverlorenz/.lib-typescript.
#
# - The repo list is fetched live from GitHub (all repos whose
#   templateRepository points at oliverlorenz/.lib-typescript), so it stays
#   correct as new repos are created from the template.
# - If an OPEN issue with the same title already exists in a repo, a "bump"
#   comment is added instead of creating a duplicate.
# - Otherwise a new issue is created.
#
# Requires: gh (authenticated), jq

set -uo pipefail

TEMPLATE_OWNER="oliverlorenz"
TEMPLATE_REPO=".lib-typescript"

TITLE="chore: sync with oliverlorenz/.lib-typescript template"
BODY=$'There are new changes in the template repository [oliverlorenz/.lib-typescript](https://github.com/oliverlorenz/.lib-typescript).\n\nPlease review the diff and pull the relevant changes into this repository.'

# Repos to skip even though they were generated from the template
# (e.g. archived/superseded copies).
EXCLUDE_REPOS=(
  lib-chatlog.old
)

mapfile -t REPOS < <(
  gh repo list "$TEMPLATE_OWNER" --limit 1000 --json name,templateRepository \
    | jq -r --arg owner "$TEMPLATE_OWNER" --arg repo "$TEMPLATE_REPO" \
      '.[] | select(.templateRepository.owner.login == $owner and .templateRepository.name == $repo) | .name' \
    | sort
)

if [[ ${#REPOS[@]} -eq 0 ]]; then
  echo "No repos found with template ${TEMPLATE_OWNER}/${TEMPLATE_REPO}. Aborting." >&2
  exit 1
fi

is_excluded() {
  local candidate="$1"
  for excluded in "${EXCLUDE_REPOS[@]}"; do
    [[ "$candidate" == "$excluded" ]] && return 0
  done
  return 1
}

for repo in "${REPOS[@]}"; do
  if is_excluded "$repo"; then
    echo "${repo} -> skipped (excluded)"
    continue
  fi

  full="${TEMPLATE_OWNER}/${repo}"

  existing=$(gh issue list --repo "$full" --state open --json number,title 2>/dev/null \
    | jq -r --arg t "$TITLE" '.[] | select(.title == $t) | .number' | head -n1)

  if [[ -n "${existing:-}" ]]; then
    if gh issue comment "$existing" --repo "$full" --body "bump" >/dev/null 2>&1; then
      echo "${repo} -> bumped existing issue #${existing}"
    else
      echo "${repo} -> FAILED to bump issue #${existing}"
    fi
  else
    if url=$(gh issue create --repo "$full" --title "$TITLE" --body "$BODY" 2>&1); then
      echo "${repo} -> created ${url}"
    else
      echo "${repo} -> FAILED to create issue: ${url}"
    fi
  fi
done
