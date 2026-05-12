---
name: developing-with-streamlit
description: "Use for ALL Streamlit tasks: creating, editing, debugging, beautifying, styling, theming, optimizing, or deploying Streamlit apps. Also custom components, st.components.v2, HTML/JS/CSS work. Discovers and loads version-matched skills from the user's installed Streamlit (>=1.57). Triggers: streamlit, st., dashboard, app.py, beautify, style, CSS, color, background, theme, button, widget styling, custom component, st.components, CCv2, session state, performance, cache, fragment, slow rerun, deploy."
allowed-tools: Bash(python ${CLAUDE_SKILL_DIR}/scripts/discover.py:*) Bash(python3 ${CLAUDE_SKILL_DIR}/scripts/discover.py:*)
---

# Developing with Streamlit

Streamlit (>=1.57) ships with built-in agent skills that provide detailed guidance for building Streamlit apps. This skill locates those bundled skills from the user's active Python environment.

## Usage

Run the discovery script with the user's project directory as the target:

```bash
python <SKILL_DIR>/scripts/discover.py --project-dir <USER_PROJECT_DIR>
```

`<SKILL_DIR>` is the directory containing this `SKILL.md`; `<USER_PROJECT_DIR>` is the absolute path to the project the user is working on. Passing `--project-dir` is important because the script resolves `.venv`, `../.venv`, `Pipfile`, and `uv.lock` relative to the project — running it from the wrong directory silently picks the wrong Python environment.

If you cannot determine the user's project directory, omit `--project-dir` and invoke the script with that directory as your working directory instead.

The script is plain Python (stdlib only) — invoke it via `python3` on macOS / Linux, `python` on Windows. Either form works on either platform if both are on PATH.

## Outcomes

The script prints one of:

- **A path to a bundled `SKILL.md` on stdout** (exit 0). Read that file and follow its routing instructions — it points to specialized sub-skills for dashboards, themes, layouts, session state, custom components, and more.
- **An `ERROR:` block on stderr** (non-zero exit) with the next action to take:
  - **Exit 1**: Streamlit is not installed. **Confirm with the user before installing** — modifying their environment without permission is a problem. The error lists the right install command for their package manager (pip, uv, poetry, pipenv, conda) and reminds them to activate the project's environment if they use conda, pipenv, poetry, hatch, or pdm.
  - **Exit 2**: Streamlit is installed but predates bundled skills (< 1.57). Suggest the user upgrade with `pip install --upgrade streamlit` for the best experience (version-matched bundled skills). If they can't upgrade, fall back to `https://docs.streamlit.io/llms-full.txt` as the reference for Streamlit APIs.
  - **Exit 3**: No Python interpreter found. Ask the user to install Python 3.9+ and Streamlit, then re-run.
  - **Exit 4**: Bundled skills directory exists but the documented sub-path is missing — likely upstream Streamlit reorganized the skill layout. The error lists the available skill names; pick the one that best matches the user's task and read its `SKILL.md`. Fall back to `llms-full.txt` only if nothing matches.
  - **Exit 5**: Invalid script argument. Fix the invocation and re-run.

If the script exits non-zero, follow the printed instructions and re-run.

## How interpreter detection works

The script picks the first available Python in this order, evaluated relative to the project directory: `$VIRTUAL_ENV` → `./.venv` → `../.venv` → `$CONDA_PREFIX` → `pipenv run` (if `Pipfile` present) → `uv run` (if `uv.lock` present) → system `python3` / `python`. This matches whichever environment the user's project uses, so the discovered Streamlit version reflects what the project actually runs.

The uv branch checks for `uv.lock` specifically (not just `pyproject.toml`) because `pyproject.toml` is shared by poetry, hatch, pdm, and other tools — using it as the marker would misroute non-uv projects to uv whenever uv happens to be installed globally.

For tools that require activation (conda, poetry, hatch, pdm, pyenv-virtualenv), the user must have their environment active in the calling shell — otherwise the script falls through to system Python and may not find Streamlit. The exit-1 error message reminds them of this.
