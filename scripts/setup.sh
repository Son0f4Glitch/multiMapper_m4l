#!/bin/bash
# One-time setup on a Mac. Safe to run again.
# Usage:  bash scripts/setup.sh
set -euo pipefail
source "$(dirname "$0")/paths.sh"
cd "$REPO"

# 1. git (comes with Apple's Command Line Tools)
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Apple Command Line Tools (includes git)…"
  xcode-select --install || true
  echo "→ Finish the installer window, then run this script again."; exit 0
fi

# 2. GitHub CLI (handles login so you never type passwords in Terminal)
if ! command -v gh >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    brew install gh
  else
    echo "→ Install the GitHub CLI from https://cli.github.com (macOS .pkg), then run this again."
    exit 0
  fi
fi

# 3. Log in to GitHub (opens your browser once)
if ! gh auth status -h github.com >/dev/null 2>&1; then
  gh auth login -h github.com -p https -w
fi
gh auth setup-git

# 4. Turn this folder into a repo linked to GitHub
if [ ! -d .git ]; then
  git init -q -b main
  git remote add origin "$REMOTE_URL"
fi
LOGIN="$(gh api user -q .login)"; UID_="$(gh api user -q .id)"
git config user.name  >/dev/null || git config user.name "$LOGIN"
git config user.email >/dev/null || git config user.email "$UID_+$LOGIN@users.noreply.github.com"

git fetch -q origin || true
if git rev-parse -q --verify origin/main >/dev/null && ! git rev-parse -q --verify HEAD >/dev/null; then
  # GitHub already has commits (e.g. a README made on the website): build on top of them
  git reset -q origin/main
  git ls-files --deleted | while IFS= read -r f; do git checkout -- "$f"; done
  git branch -q -u origin/main main 2>/dev/null || true
fi
echo "✓ Repo linked to $REMOTE_URL"

# 5. Switch to the stable filename in both app folders
for DIR in "$TD_DIR" "$LIVE_DIR"; do
  OLD="$DIR/TDA_Multi_Mapper_v10_10.amxd"; NEW="$DIR/TDA_Multi_Mapper.amxd"
  if [ -f "$OLD" ] && [ ! -e "$NEW" ]; then mv -n "$OLD" "$NEW"; echo "✓ Renamed to TDA_Multi_Mapper.amxd in $(basename "$(dirname "$DIR")")"; fi
done

# 6. First push
if ! git rev-parse -q --verify refs/tags/v10.10 >/dev/null; then
  bash scripts/push.sh "TDA Multi Mapper v10.10 – first version on GitHub" 10.10
fi
echo "✓ Setup done."
