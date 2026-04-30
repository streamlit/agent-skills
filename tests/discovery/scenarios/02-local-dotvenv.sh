#!/usr/bin/env bash
# 02-local-dotvenv: ./.venv/bin/python exists, but VIRTUAL_ENV is NOT set.
# Expected: discover.sh falls through to ./.venv/bin/python and resolves the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-1.57.0}"
WORK="$(mktemp -d)"
cd "$WORK"

python3 -m venv .venv
.venv/bin/pip install --quiet "streamlit==$STREAMLIT_VERSION"
# Do NOT activate. VIRTUAL_ENV must be unset for this scenario.
unset VIRTUAL_ENV

run_discover
assert_bundled_skill_exists "02-local-dotvenv"
