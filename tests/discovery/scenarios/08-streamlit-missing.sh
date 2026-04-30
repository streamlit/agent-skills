#!/usr/bin/env bash
# 08-streamlit-missing: no Streamlit installed anywhere.
# Expected: discover.sh exits 1 with the 'pip install streamlit' hint on stderr.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV CONDA_PREFIX

run_discover
assert_streamlit_missing "08-streamlit-missing"
