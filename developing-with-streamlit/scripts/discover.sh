#!/usr/bin/env bash
# Discovers the Streamlit package's bundled agent-skills SKILL.md.
#
# Usage:
#   bash scripts/discover.sh [--project-dir PATH]
#
# When --project-dir is given, the script changes into that directory before
# detecting the interpreter (so its `.venv` / `../.venv` / `pyproject.toml` /
# `Pipfile` checks resolve relative to the user's project rather than to the
# script's installed location).
#
# Exit codes:
#   0 — success; prints the absolute path to the bundled SKILL.md on stdout.
#   1 — Streamlit is not installed in the detected interpreter.
#   2 — Streamlit is installed but predates bundled skills (no .agents/skills/).
#   3 — no usable Python interpreter was found.
#   4 — .agents/skills/ exists but the expected developing-with-streamlit/SKILL.md
#       is not at the documented sub-path (likely upstream restructured). The
#       agent should read the listed available skills directly.
#   5 — invalid script argument.
#
# On non-zero exit, a human-readable "ERROR:" block is printed on stderr.

set -u

# -- 0. Parse arguments --
PROJECT_DIR=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project-dir)
      if [ $# -lt 2 ]; then
        echo "ERROR: --project-dir requires a path argument" >&2
        exit 5
      fi
      PROJECT_DIR="$2"
      shift 2
      ;;
    --project-dir=*)
      PROJECT_DIR="${1#*=}"
      shift
      ;;
    -h|--help)
      sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1" >&2
      echo "Usage: bash scripts/discover.sh [--project-dir PATH]" >&2
      exit 5
      ;;
  esac
done

if [ -n "$PROJECT_DIR" ]; then
  if [ ! -d "$PROJECT_DIR" ]; then
    echo "ERROR: --project-dir is not a directory: $PROJECT_DIR" >&2
    exit 5
  fi
  cd "$PROJECT_DIR"
fi

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
elif command -v pipenv >/dev/null 2>&1 && [ -f "Pipfile" ]; then
  PY="pipenv run python"
elif command -v uv >/dev/null 2>&1 && [ -f "uv.lock" ]; then
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
Install with the matching tool for your project:
  pip install streamlit              # standard pip
  uv add streamlit                   # uv
  poetry add streamlit               # poetry
  pipenv install streamlit           # pipenv
  conda install -c conda-forge streamlit   # conda
If your project uses conda, pyenv-virtualenv, pipenv, poetry, hatch, or pdm,
ACTIVATE its environment first (conda activate <env>, pipenv shell,
poetry shell, hatch shell, etc.) so the right Python is detected, then re-run.
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
AGENTS_SKILLS_DIR="$STREAMLIT_PATH/.agents/skills"
PRIMARY_SKILL="$AGENTS_SKILLS_DIR/developing-with-streamlit/SKILL.md"

# -- 3a. Happy path: documented sub-skill exists --
if [ -f "$PRIMARY_SKILL" ]; then
  echo "$PRIMARY_SKILL"
  exit 0
fi

# -- 3b. Bundled skills directory exists but our expected sub-path doesn't --
# Likely upstream restructured. Surface what IS available so the agent can
# pick the most relevant skill rather than blindly falling back to llms-full.txt.
if [ -d "$AGENTS_SKILLS_DIR" ]; then
  cat >&2 <<EOF
ERROR: Streamlit's bundled skills directory exists, but the expected
developing-with-streamlit/SKILL.md is missing from the documented sub-path.
This usually means upstream Streamlit reorganized the skill layout.

Streamlit path: $STREAMLIT_PATH
Bundled skills directory: $AGENTS_SKILLS_DIR
Available entries:
EOF
  ls -1 "$AGENTS_SKILLS_DIR" | sed 's/^/  /' >&2
  cat >&2 <<EOF

Read whichever sub-skill best matches the user's task. If none match,
fall back to: https://docs.streamlit.io/llms-full.txt
EOF
  exit 4
fi

# -- 3c. No bundled skills directory at all → genuine pre-1.57 install --
cat >&2 <<EOF
ERROR: Streamlit is installed but predates bundled skills (< 1.57).
Interpreter: $PY
Streamlit path: $STREAMLIT_PATH

For best results, upgrade to get version-matched bundled skills:
  pip install --upgrade streamlit

If upgrading isn't an option, fall back to the online docs:
  https://docs.streamlit.io/llms-full.txt
EOF
exit 2
