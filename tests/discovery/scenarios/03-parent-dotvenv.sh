#!/usr/bin/env bash
# 03-parent-dotvenv: ../.venv/bin/python exists; cwd is a child directory.
# Expected: discover.sh finds the parent .venv and resolves the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-}"
PARENT="$(mktemp -d)"
cd "$PARENT"
python3 -m venv .venv
.venv/bin/pip install --quiet "streamlit${STREAMLIT_VERSION:+==$STREAMLIT_VERSION}"
mkdir -p project
cd project
unset VIRTUAL_ENV

run_discover
assert_bundled_skill_exists "03-parent-dotvenv"
