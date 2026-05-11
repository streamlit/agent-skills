#!/usr/bin/env bash
# 01-active-venv: VIRTUAL_ENV is set and points at a venv with Streamlit installed.
# Expected: discover.sh picks $VIRTUAL_ENV/bin/python and resolves the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-}"
WORK="$(mktemp -d)"
cd "$WORK"

python3 -m venv .venv
. .venv/bin/activate
pip install --quiet "streamlit${STREAMLIT_VERSION:+==$STREAMLIT_VERSION}"

run_discover
assert_bundled_skill_exists "01-active-venv"
