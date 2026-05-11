#!/usr/bin/env bash
# 13-uv-no-lockfile: uv installed globally, pyproject.toml present, NO uv.lock.
# Simulates: poetry/hatch/pdm/setuptools-pep621 user with uv as a globally-
# installed tool (common — uv is becoming a default install).
#
# Without the uv.lock guard, the uv branch would fire on any pyproject.toml,
# misrouting these projects to a fresh uv-spawned venv that has nothing to do
# with the user's actual environment.
#
# Expected: discover.sh skips the uv branch (no uv.lock present), falls
# through to system python3 — which here has no Streamlit, so exit 1. The
# error message must list `python3` as the interpreter, NOT `uv run`. That's
# the regression signal: if someone reverts the uv.lock guard, the error
# would say "Interpreter: uv run --quiet python" instead.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

pip install --quiet uv

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV CONDA_PREFIX

# A bare pyproject.toml — could be poetry, hatch, pdm, etc. NOT uv.
cat > pyproject.toml <<'TOML'
[project]
name = "not-a-uv-project"
version = "0.1.0"
TOML

# Sanity: no uv.lock should exist.
if [ -e uv.lock ]; then
  echo "FAIL: 13-uv-no-lockfile: setup error — uv.lock exists, scenario invalid" >&2
  exit 1
fi

run_discover

# Expect exit 1 (no Streamlit found anywhere).
if [ "$CAPTURED_RC" -ne 1 ]; then
  echo "FAIL: 13-uv-no-lockfile: expected exit 1, got $CAPTURED_RC" >&2
  echo "$CAPTURED_STDERR" >&2
  exit 1
fi

# The interpreter listed in the error must be python3, NOT uv run.
# That's the regression marker: with the bug, it would say "uv run".
if echo "$CAPTURED_STDERR" | grep -q "Interpreter: uv run"; then
  echo "FAIL: 13-uv-no-lockfile: uv branch misrouted on pyproject.toml without uv.lock" >&2
  echo "$CAPTURED_STDERR" >&2
  exit 1
fi
if ! echo "$CAPTURED_STDERR" | grep -q "Interpreter: python3"; then
  echo "FAIL: 13-uv-no-lockfile: expected interpreter to be python3" >&2
  echo "$CAPTURED_STDERR" >&2
  exit 1
fi

echo "PASS: 13-uv-no-lockfile: uv branch correctly skipped without uv.lock; fell through to python3"
