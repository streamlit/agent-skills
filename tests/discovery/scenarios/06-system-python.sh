#!/usr/bin/env bash
# 06-system-python: no venv, no conda, no uv. Just system python3 + Streamlit.
# Expected: discover.sh falls through to python3 and resolves the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-1.57.0}"
pip install --quiet "streamlit==$STREAMLIT_VERSION"

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV CONDA_PREFIX

run_discover
assert_bundled_skill_exists "06-system-python"
