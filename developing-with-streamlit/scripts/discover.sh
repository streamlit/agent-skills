#!/usr/bin/env bash
# Discovers the Streamlit package's bundled agent-skills SKILL.md.
#
# Exit codes:
#   0 — success; prints the absolute path to the bundled SKILL.md on stdout.
#   1 — Streamlit is not installed in the detected interpreter.
#   2 — Streamlit is installed but predates bundled skills (< 1.57).
#   3 — no usable Python interpreter was found.
#
# On non-zero exit, a human-readable "ERROR:" block is printed on stderr with
# the next action the agent should take.

set -u

# -- 1. Detect Python interpreter in documented priority order --
PY=""
if [ -n "${VIRTUAL_ENV:-}" ] && [ -x "$VIRTUAL_ENV/bin/python" ]; then
  PY="$VIRTUAL_ENV/bin/python"
elif [ -x ".venv/bin/python" ]; then
  PY="$(pwd)/.venv/bin/python"
elif [ -x "../.venv/bin/python" ]; then
  PY="$(cd .. && pwd)/.venv/bin/python"
elif [ -n "${CONDA_PREFIX:-}" ] && [ -x "$CONDA_PREFIX/bin/python" ]; then
  PY="$CONDA_PREFIX/bin/python"
elif command -v uv >/dev/null 2>&1 && [ -f "pyproject.toml" ]; then
  PY="uv run --quiet python"
elif command -v python3 >/dev/null 2>&1; then
  PY="python3"
elif command -v python >/dev/null 2>&1; then
  PY="python"
fi

if [ -z "$PY" ]; then
  cat >&2 <<EOF
ERROR: No Python interpreter found.
Install Python 3.9+ and Streamlit (pip install streamlit), then re-run.
EOF
  exit 3
fi

# -- 2. Resolve streamlit.__path__[0] --
IMPORT_OUT="$($PY -c "import streamlit; print(streamlit.__path__[0])" 2>&1)"
IMPORT_RC=$?

if [ $IMPORT_RC -ne 0 ]; then
  if echo "$IMPORT_OUT" | grep -q "ModuleNotFoundError"; then
    cat >&2 <<EOF
ERROR: Streamlit is not installed in the detected Python environment.
Interpreter: $PY
Install it with:
  pip install streamlit
Then re-run this script.
EOF
    exit 1
  fi
  cat >&2 <<EOF
ERROR: Failed to import streamlit.
Interpreter: $PY
Output:
$IMPORT_OUT
EOF
  exit 1
fi

STREAMLIT_PATH="$IMPORT_OUT"
SKILL_PATH="$STREAMLIT_PATH/.agents/skills/developing-with-streamlit/SKILL.md"

# -- 3. Verify the bundled SKILL.md exists (Streamlit >= 1.57) --
if [ ! -f "$SKILL_PATH" ]; then
  cat >&2 <<EOF
ERROR: Streamlit is installed but predates bundled skills (< 1.57).
Interpreter: $PY
Streamlit path: $STREAMLIT_PATH
Fall back to the online docs:
  https://docs.streamlit.io/llms-full.txt
EOF
  exit 2
fi

echo "$SKILL_PATH"
