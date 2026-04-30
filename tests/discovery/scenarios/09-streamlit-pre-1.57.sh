#!/usr/bin/env bash
# 09-streamlit-pre-1.57: Streamlit installed, but version predates bundled skills.
# Expected: discover.sh exits 2 with llms-full.txt fallback on stderr.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-1.56.0}"
pip install --quiet "streamlit==$STREAMLIT_VERSION"

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV CONDA_PREFIX

run_discover
assert_pre_1_57_fallback "09-streamlit-pre-1.57"
