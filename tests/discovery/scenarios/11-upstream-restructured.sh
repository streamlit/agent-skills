#!/usr/bin/env bash
# 11-upstream-restructured: simulates upstream Streamlit moving or removing
# the developing-with-streamlit/SKILL.md while keeping the .agents/skills/
# directory itself. Expected: exit 4 with a directory listing on stderr.
#
# Without this branch, a future upstream rename would silently fall through
# to the pre-1.57 codepath even on a current install.

set -euo pipefail
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
source "$REPO_ROOT/tests/discovery/assert.sh"

STREAMLIT_VERSION="${STREAMLIT_VERSION:-}"
pip install --quiet "streamlit${STREAMLIT_VERSION:+==$STREAMLIT_VERSION}"

# Locate the installed streamlit and rename its bundled skill so the documented
# sub-path no longer exists, but .agents/skills/ does (with one or more siblings
# left behind to prove the listing works).
STREAMLIT_PATH="$(python3 -c 'import streamlit, os; print(os.path.dirname(streamlit.__file__))')"
mv "$STREAMLIT_PATH/.agents/skills/developing-with-streamlit" \
   "$STREAMLIT_PATH/.agents/skills/streamlit-development-renamed"

WORK="$(mktemp -d)"
cd "$WORK"
unset VIRTUAL_ENV CONDA_PREFIX

run_discover
assert_upstream_restructured "11-upstream-restructured"

# Sanity: the listing should mention the renamed directory.
if ! echo "$CAPTURED_STDERR" | grep -q "streamlit-development-renamed"; then
  echo "FAIL: 11-upstream-restructured: expected listing to include renamed dir" >&2
  echo "$CAPTURED_STDERR" >&2
  exit 1
fi
echo "PASS: 11-upstream-restructured: listing includes renamed sibling skill"
