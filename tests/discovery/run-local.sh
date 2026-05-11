#!/usr/bin/env bash
# Runs the full discovery test matrix locally via `docker run`.
#
# Mirrors .github/workflows/test-discovery.yml. Each scenario runs in a fresh
# container so environment state from previous scenarios can't leak.
#
# Usage:
#   bash tests/discovery/run-local.sh                # run all scenarios
#   bash tests/discovery/run-local.sh 04-conda       # run one scenario
#
# Requires: docker.

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FILTER="${1:-}"

# (scenario-name, image) pairs. Keep in sync with .github/workflows/test-discovery.yml.
SCENARIOS=(
  "01-active-venv|python:3.12-slim"
  "02-local-dotvenv|python:3.12-slim"
  "03-parent-dotvenv|python:3.12-slim"
  "04-conda|continuumio/miniconda3"
  "05-uv|python:3.12-slim"
  "06-system-python|python:3.12-slim"
  "07-priority-venv-over-local|python:3.12-slim"
  "08-streamlit-missing|python:3.12-slim"
  "09-streamlit-pre-1.57|python:3.12-slim"
  "10-project-dir-argument|python:3.12-slim"
  "11-upstream-restructured|python:3.12-slim"
  "12-pipenv|python:3.12-slim"
  "13-uv-no-lockfile|python:3.12-slim"
)

FAILED=()
PASSED=()

for entry in "${SCENARIOS[@]}"; do
  name="${entry%%|*}"
  image="${entry##*|}"
  if [ -n "$FILTER" ] && [ "$FILTER" != "$name" ]; then
    continue
  fi

  echo ""
  echo "=========================================="
  echo "Scenario: $name  (image: $image)"
  echo "=========================================="

  # python:3.12-slim lacks `venv` module's ensurepip by default? It has it.
  # miniconda3 has python + pip at /opt/conda/bin — fine.
  set +e
  docker run --rm \
    --workdir /work \
    -v "$REPO_ROOT:/work:ro" \
    "$image" \
    bash -c "bash /work/tests/discovery/scenarios/${name}.sh"
  rc=$?
  set -e

  if [ $rc -eq 0 ]; then
    PASSED+=("$name")
  else
    FAILED+=("$name")
  fi
done

echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo "Passed: ${#PASSED[@]}"
for n in "${PASSED[@]}"; do echo "  + $n"; done
echo "Failed: ${#FAILED[@]}"
for n in "${FAILED[@]}"; do echo "  - $n"; done

[ ${#FAILED[@]} -eq 0 ]
