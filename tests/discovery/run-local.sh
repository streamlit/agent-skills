#!/usr/bin/env bash
# Run the discovery test suite locally via pytest.
#
# This is a convenience wrapper. The CI workflow at
# .github/workflows/test-discovery.yml runs the same suite on Linux + Windows.
#
# Usage:
#   bash tests/discovery/run-local.sh                       # all tests
#   bash tests/discovery/run-local.sh -k test_pipenv        # pytest filter
#   bash tests/discovery/run-local.sh -x                    # stop at first fail
#
# Requires Python 3.10+ and `pip install pytest`. Tests that need uv, pipenv,
# poetry, pdm, or conda will skip cleanly if those tools aren't installed.

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if ! command -v pytest >/dev/null 2>&1; then
  echo "pytest not found. Install it with: pip install pytest" >&2
  exit 1
fi

cd "$REPO_ROOT"
exec pytest tests/discovery/ -v "$@"
