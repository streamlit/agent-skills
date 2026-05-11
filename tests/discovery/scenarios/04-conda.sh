#!/usr/bin/env bash
# 04-conda: CONDA_PREFIX is set; no venv/uv present. Runs in continuumio/miniconda3.
# Expected: discover.sh picks $CONDA_PREFIX/bin/python and resolves the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-}"
# Install Streamlit into the base conda env; CONDA_PREFIX already points here.
/opt/conda/bin/pip install --quiet "streamlit${STREAMLIT_VERSION:+==$STREAMLIT_VERSION}"
export CONDA_PREFIX="/opt/conda"

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV

run_discover
assert_bundled_skill_exists "04-conda"
