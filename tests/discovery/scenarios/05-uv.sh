#!/usr/bin/env bash
# 05-uv: uv is on PATH, pyproject.toml present, Streamlit installed via uv.
# Expected: discover.sh picks `uv run python` and resolves the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-1.57.0}"
pip install --quiet uv

WORK="$(mktemp -d)"
cd "$WORK"
uv init --quiet --no-workspace .
uv add --quiet "streamlit==$STREAMLIT_VERSION"

# uv creates ./.venv during `uv add`. To isolate the "uv wins" path we remove it
# so discover.sh falls past the .venv check. VIRTUAL_ENV also unset.
rm -rf .venv
unset VIRTUAL_ENV

run_discover
assert_bundled_skill_exists "05-uv"
