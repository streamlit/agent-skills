---
name: developing-with-streamlit
description: "Discovers and loads Streamlit development skills bundled with the installed Streamlit package. Use for any Streamlit task: creating, editing, debugging, styling, theming, optimizing, or deploying Streamlit apps. Triggers: streamlit, st., dashboard, app.py, beautify, style, theme, widget, custom component."
---

# Developing with Streamlit

Streamlit (1.57+) ships with built-in agent skills that provide detailed guidance for building Streamlit apps. This skill locates those bundled skills from the user's active Python environment.

## Usage

Run the discovery script:

```bash
bash scripts/discover.sh
```

The script prints one of:

- **A path to a bundled `SKILL.md` on stdout** (exit 0). Read that file and follow its routing instructions — it points to specialized sub-skills for dashboards, themes, layouts, session state, custom components, and more.
- **An `ERROR:` block on stderr** (non-zero exit) with the next action to take:
  - Exit 1: Streamlit is not installed — run `pip install streamlit`, then re-run.
  - Exit 2: Streamlit is installed but predates bundled skills — fall back to `https://docs.streamlit.io/llms-full.txt` as the reference for Streamlit APIs.
  - Exit 3: no Python interpreter found — install Python 3.9+ and Streamlit, then re-run.

If the script exits non-zero, follow the printed instructions and re-run.

## How interpreter detection works

The script picks the first available Python in this order: `$VIRTUAL_ENV` → `./.venv` → `../.venv` → `$CONDA_PREFIX` → `uv run` (if `pyproject.toml` present) → system `python3` / `python`. This matches whichever environment the user's project uses, so the discovered Streamlit version reflects what the project actually runs.
