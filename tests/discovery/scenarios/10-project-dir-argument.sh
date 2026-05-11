#!/usr/bin/env bash
# 10-project-dir-argument: discover.sh invoked with --project-dir from a
# directory that does NOT contain the user's .venv. The .venv lives in a
# different directory, passed via --project-dir.
# Expected: discover.sh `cd`s into the project dir and resolves the bundled SKILL.md.
# This proves the script honors --project-dir for environments where the agent
# can't (or doesn't) chdir into the project before invoking.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-1.57.0}"

# Build the user's "project" with .venv + streamlit installed.
USER_PROJECT="$(mktemp -d)"
python3 -m venv "$USER_PROJECT/.venv"
"$USER_PROJECT/.venv/bin/pip" install --quiet "streamlit==$STREAMLIT_VERSION"

# Run from a totally unrelated directory (simulates: agent's CWD is e.g. the
# skill install dir, NOT the user's project).
ELSEWHERE="$(mktemp -d)"
cd "$ELSEWHERE"
unset VIRTUAL_ENV CONDA_PREFIX

# Override DISCOVER_SCRIPT to add --project-dir argument; reuse run_discover plumbing.
discover_script="$REPO_ROOT/developing-with-streamlit/scripts/discover.sh"
stdout_file="$(mktemp)"
stderr_file="$(mktemp)"
set +e
bash "$discover_script" --project-dir "$USER_PROJECT" >"$stdout_file" 2>"$stderr_file"
CAPTURED_RC=$?
set -e
CAPTURED_STDOUT="$(cat "$stdout_file")"
CAPTURED_STDERR="$(cat "$stderr_file")"
rm -f "$stdout_file" "$stderr_file"

assert_bundled_skill_exists "10-project-dir-argument"
