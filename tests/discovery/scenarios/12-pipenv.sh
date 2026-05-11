#!/usr/bin/env bash
# 12-pipenv: Pipfile present, pipenv installed, streamlit installed via pipenv.
# Pipenv puts its venv outside the project (default ~/.local/share/virtualenvs/),
# so there's no ./.venv to short-circuit our priority order. VIRTUAL_ENV unset.
# Expected: discover.sh detects the pipenv branch via Pipfile marker and resolves
# the bundled SKILL.md.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-}"
pip install --quiet pipenv

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV CONDA_PREFIX
# Default pipenv behavior: venv lives in ~/.local/share/virtualenvs/, NOT in the project.
unset PIPENV_VENV_IN_PROJECT

pipenv install --quiet "streamlit${STREAMLIT_VERSION:+==$STREAMLIT_VERSION}" >/dev/null 2>&1

# Sanity: confirm pipenv didn't drop a .venv in the project (would short-circuit our test).
if [ -e ".venv" ]; then
  echo "FAIL: 12-pipenv: pipenv unexpectedly created ./.venv — test setup is wrong" >&2
  exit 1
fi

run_discover
assert_bundled_skill_exists "12-pipenv"
