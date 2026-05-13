# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository overview

This repository contains a **single meta-skill** that teaches AI agents how to discover Streamlit development skills bundled inside the Streamlit pip package (1.57+).

The actual skill content (dashboards, themes, layouts, session state, custom components, etc.) now ships with Streamlit itself. This repo provides the entry point that bootstraps that discovery — new skill **content** should be contributed upstream to the [Streamlit repository](https://github.com/streamlit/streamlit), not added here.

**Key files:**
- `developing-with-streamlit/SKILL.md` — Meta-skill that locates and loads bundled Streamlit skills
- `developing-with-streamlit/scripts/discover.py` — The actual contract implementation (interpreter detection, package-path lookup, fallback exit codes); edit this when changing discovery behavior
- `tests/discovery/test_discovery.py` — Pytest suite that exercises every documented codepath in `discover.py` on Linux + Windows; add a test here when adding a new branch
- `README.md` — Human-readable documentation and install instructions

## Meta-skill contract

The meta-skill at `developing-with-streamlit/SKILL.md` resolves the bundled routing skill by:

1. Detecting the active Python interpreter, in priority order: `$VIRTUAL_ENV` → `./.venv` → `../.venv` → `<git-root>/.venv` → `$CONDA_PREFIX` → `pipenv` (if `Pipfile` present) → `poetry` (if `poetry.lock` present) → `pdm` (if `pdm.lock` present) → `uv` (if `uv.lock` present) → system `python3` / `python`.
2. Running `python -c "import streamlit; print(streamlit.__path__[0])"` to locate the installed package.
3. Loading `<streamlit_path>/.agents/skills/developing-with-streamlit/SKILL.md`.
4. Falling back to `pip install streamlit` when missing, or `https://docs.streamlit.io/llms-full.txt` when the installed version predates bundled skills.

When editing the meta-skill, preserve this contract. Changes that alter interpreter detection order, the package-path lookup, or the fallback behavior should be explicit and reviewed.

## Authoring or updating skills

New Streamlit skills belong upstream at `streamlit/streamlit` under [`lib/streamlit/.agents/skills/`](https://github.com/streamlit/streamlit/tree/develop/lib/streamlit/.agents/skills), not in this repo. For the skill format (frontmatter, naming conventions, optional `scripts/` / `references/` / `assets/` directories), see:

- [Agent Skills specification](https://agentskills.io/specification)
- [Agent Skills best practices (Anthropic)](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md)
- Existing bundled skills under [`lib/streamlit/.agents/skills/`](https://github.com/streamlit/streamlit/tree/develop/lib/streamlit/.agents/skills) in the Streamlit repo — the best reference templates

When authoring skills, always verify code examples against the latest Streamlit API by consulting [docs.streamlit.io/llms-full.txt](https://docs.streamlit.io/llms-full.txt).

## Contributing

- **New or updated Streamlit skill content** → open a PR against [streamlit/streamlit](https://github.com/streamlit/streamlit) targeting [`lib/streamlit/.agents/skills/`](https://github.com/streamlit/streamlit/tree/develop/lib/streamlit/.agents/skills).
- **Changes to the meta-skill itself** (discovery logic, fallbacks, docs) → open a PR against this repo. Keep the discovery contract above intact unless the change is intentional.
- See [CONTRIBUTING.md](CONTRIBUTING.md) for general guidelines.
