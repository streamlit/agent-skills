#!/usr/bin/env bash
# 07-priority-venv-over-local: VIRTUAL_ENV set (with Streamlit) AND ./.venv exists
# (without Streamlit). VIRTUAL_ENV must win per the documented priority order.
# Expected: discover.sh picks VIRTUAL_ENV and resolves the bundled SKILL.md.
# If priority order regressed and .venv won, the import would fail.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-1.57.0}"
WORK="$(mktemp -d)"
cd "$WORK"

# Venv A (with Streamlit) becomes the active VIRTUAL_ENV.
python3 -m venv venv-a
venv-a/bin/pip install --quiet "streamlit==$STREAMLIT_VERSION"

# ./.venv (without Streamlit) exists at cwd. Would be picked by step 2 if
# priority order is broken.
python3 -m venv .venv

. venv-a/bin/activate

run_discover
assert_bundled_skill_exists "07-priority-venv-over-local"
