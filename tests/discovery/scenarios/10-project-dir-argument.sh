#!/usr/bin/env bash
# 10-project-dir-argument: discover.py invoked with --project-dir from a
# directory that does NOT contain the user's .venv. The .venv lives in a
# different directory, passed via --project-dir.
# Expected: discover.py uses --project-dir for path resolution, finds the
# user's .venv, and resolves the bundled SKILL.md.
# Proves the script honors --project-dir for environments where the agent
# can't (or doesn't) chdir into the project before invoking.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-}"

# Build the user's "project" with .venv + streamlit installed.
USER_PROJECT="$(mktemp -d)"
python3 -m venv "$USER_PROJECT/.venv"
"$USER_PROJECT/.venv/bin/pip" install --quiet "streamlit${STREAMLIT_VERSION:+==$STREAMLIT_VERSION}"

# Run from a totally unrelated directory (simulates: agent's CWD is e.g. the
# skill install dir, NOT the user's project).
ELSEWHERE="$(mktemp -d)"
cd "$ELSEWHERE"
unset VIRTUAL_ENV CONDA_PREFIX

# Custom invocation with --project-dir; mirror run_discover's capture plumbing.
discover_script="$REPO_ROOT/developing-with-streamlit/scripts/discover.py"
if command -v python3 >/dev/null 2>&1; then
  py=python3
else
  py=python
fi
stdout_file="$(mktemp)"
stderr_file="$(mktemp)"
set +e
"$py" "$discover_script" --project-dir "$USER_PROJECT" >"$stdout_file" 2>"$stderr_file"
CAPTURED_RC=$?
set -e
CAPTURED_STDOUT="$(cat "$stdout_file")"
CAPTURED_STDERR="$(cat "$stderr_file")"
rm -f "$stdout_file" "$stderr_file"

assert_bundled_skill_exists "10-project-dir-argument"
