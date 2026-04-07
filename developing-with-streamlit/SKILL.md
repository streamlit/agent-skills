---
name: discovering-streamlit-skills
description: "Discovers and loads Streamlit development skills bundled with the installed Streamlit package. Use for any Streamlit task: creating, editing, debugging, styling, theming, optimizing, or deploying Streamlit apps. Triggers: streamlit, st., dashboard, app.py, beautify, style, theme, widget, custom component."
---

# Discovering Streamlit skills

Streamlit (1.57+) ships with built-in agent skills that provide detailed guidance for building Streamlit apps. This skill shows how to find and load them from the installed package.

## Quick one-liner

```bash
python -c "import streamlit; print(streamlit.__path__[0] + '/.agents/skills/developing-with-streamlit/SKILL.md')"
```

Read the file at that path to get the full routing skill with sub-skills for dashboards, themes, layouts, session state, custom components, and more.

## Step-by-step discovery

### First step: detect the Python interpreter

Find the right Python interpreter by checking these locations in order:

1. **Active virtual environment** — `$VIRTUAL_ENV/bin/python` (if `$VIRTUAL_ENV` is set)
2. **Local `.venv`** — `.venv/bin/python` (if that file exists)
3. **Parent `.venv`** — `../.venv/bin/python` (if that file exists)
4. **Conda environment** — `$CONDA_PREFIX/bin/python` (if `$CONDA_PREFIX` is set)
5. **uv** — `uv run python` (if `uv` is available on `$PATH`)
6. **System Python** — `python3` or `python`

Use the first interpreter found. This ordering avoids accidentally using a system Python that lacks the project's Streamlit installation.

### Next step: locate the Streamlit package

Run this command with the detected interpreter:

```bash
python -c "import streamlit; print(streamlit.__path__[0])"
```

This prints the absolute path to the Streamlit package directory (e.g., `/Users/dev/.venv/lib/python3.12/site-packages/streamlit`).

### Then: load the bundled skill

The main routing skill lives at:

```
<streamlit_path>/.agents/skills/developing-with-streamlit/SKILL.md
```

Read that file. It contains a routing table that directs to specialized sub-skills for specific tasks (dashboards, themes, layouts, performance, custom components, etc.). Follow its instructions to load the appropriate sub-skill for the user's request.

## Error handling

### Streamlit is not installed

If the `import streamlit` command fails with `ModuleNotFoundError`, Streamlit is not installed in the detected environment. Install it:

```bash
pip install streamlit
```

Then retry the discovery step.

### Skill file not found (Streamlit < 1.57)

If the `.agents/skills/` directory does not exist inside the Streamlit package, the installed version predates bundled skills. In this case, fall back to the online Streamlit documentation:

```
https://docs.streamlit.io/llms-full.txt
```

Fetch that URL and use it as the reference for Streamlit APIs and best practices. It is a markdown file optimized for LLM consumption.
