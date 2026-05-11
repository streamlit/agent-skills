#!/usr/bin/env bash
# Shared assertion helpers for discovery scenario tests.
#
# Each helper takes the scenario's exit code + captured stdout + captured
# stderr from scripts/discover.sh and asserts against the expected outcome.
# Helpers print a PASS/FAIL line and exit non-zero on failure.

set -u

_pass() {
  echo "PASS: $1"
}

_fail() {
  echo "FAIL: $1" >&2
  echo "---- captured stdout ----" >&2
  echo "${CAPTURED_STDOUT:-<empty>}" >&2
  echo "---- captured stderr ----" >&2
  echo "${CAPTURED_STDERR:-<empty>}" >&2
  echo "---- exit code ----" >&2
  echo "${CAPTURED_RC:-<unset>}" >&2
  exit 1
}

# Run discover.sh, capturing stdout/stderr/exit code into globals.
run_discover() {
  local discover_script="${DISCOVER_SCRIPT:-$REPO_ROOT/developing-with-streamlit/scripts/discover.sh}"
  local stdout_file stderr_file
  stdout_file="$(mktemp)"
  stderr_file="$(mktemp)"
  set +e
  bash "$discover_script" >"$stdout_file" 2>"$stderr_file"
  CAPTURED_RC=$?
  set -e
  CAPTURED_STDOUT="$(cat "$stdout_file")"
  CAPTURED_STDERR="$(cat "$stderr_file")"
  rm -f "$stdout_file" "$stderr_file"
}

# Asserts exit 0 + stdout path points at an existing bundled SKILL.md.
assert_bundled_skill_exists() {
  local scenario="$1"
  if [ "$CAPTURED_RC" -ne 0 ]; then
    _fail "$scenario: expected exit 0, got $CAPTURED_RC"
  fi
  if [ -z "$CAPTURED_STDOUT" ]; then
    _fail "$scenario: expected a path on stdout, got empty"
  fi
  if [ ! -f "$CAPTURED_STDOUT" ]; then
    _fail "$scenario: stdout path does not exist: $CAPTURED_STDOUT"
  fi
  case "$CAPTURED_STDOUT" in
    */.agents/skills/developing-with-streamlit/SKILL.md) ;;
    *) _fail "$scenario: stdout path did not match expected suffix: $CAPTURED_STDOUT" ;;
  esac
  _pass "$scenario: resolved bundled SKILL.md at $CAPTURED_STDOUT"
}

# Asserts exit 1 + missing-streamlit error with pip install hint on stderr.
assert_streamlit_missing() {
  local scenario="$1"
  if [ "$CAPTURED_RC" -ne 1 ]; then
    _fail "$scenario: expected exit 1 (missing streamlit), got $CAPTURED_RC"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "Streamlit is not installed"; then
    _fail "$scenario: expected stderr to mention Streamlit not installed"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "pip install streamlit"; then
    _fail "$scenario: expected stderr to include 'pip install streamlit' hint"
  fi
  _pass "$scenario: surfaced missing-streamlit error with pip install hint"
}

# Asserts exit 2 + pre-1.57 fallback pointing at llms-full.txt.
assert_pre_1_57_fallback() {
  local scenario="$1"
  if [ "$CAPTURED_RC" -ne 2 ]; then
    _fail "$scenario: expected exit 2 (pre-1.57), got $CAPTURED_RC"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "predates bundled skills"; then
    _fail "$scenario: expected stderr to mention predates bundled skills"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "pip install --upgrade streamlit"; then
    _fail "$scenario: expected stderr to suggest 'pip install --upgrade streamlit'"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "docs.streamlit.io/llms-full.txt"; then
    _fail "$scenario: expected stderr to include llms-full.txt fallback URL"
  fi
  _pass "$scenario: surfaced pre-1.57 fallback with upgrade hint + llms-full.txt URL"
}

# Asserts exit 4 + upstream-restructured fallback that lists available skills.
assert_upstream_restructured() {
  local scenario="$1"
  if [ "$CAPTURED_RC" -ne 4 ]; then
    _fail "$scenario: expected exit 4 (upstream restructured), got $CAPTURED_RC"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "upstream Streamlit reorganized"; then
    _fail "$scenario: expected stderr to mention upstream restructured the skill layout"
  fi
  if ! echo "$CAPTURED_STDERR" | grep -q "Available entries:"; then
    _fail "$scenario: expected stderr to include 'Available entries:' listing"
  fi
  _pass "$scenario: surfaced upstream-restructured error with available-skills listing"
}
