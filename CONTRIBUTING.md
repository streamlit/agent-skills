# Contributing

This repository hosts a single **meta-skill** (`developing-with-streamlit`) that teaches AI agents to discover Streamlit development skills bundled inside the Streamlit pip package (1.57+).

## Where to contribute

- **New or updated Streamlit skill content** (dashboards, themes, custom components, etc.) → open a PR against [streamlit/streamlit](https://github.com/streamlit/streamlit) targeting [`lib/streamlit/.agents/skills/`](https://github.com/streamlit/streamlit/tree/develop/lib/streamlit/.agents/skills). That's where the actual skill content lives.
- **Changes to this meta-skill** (discovery logic, interpreter detection, fallback behavior, install docs) → open a PR against this repo.

## Working on the meta-skill

Read [AGENTS.md](AGENTS.md) first — it describes the meta-skill contract (interpreter detection order, the `streamlit.__path__` lookup, and the fallback to `docs.streamlit.io/llms-full.txt` for pre-1.57 installs). Changes to that contract should be deliberate and reviewed.

## Authoring skills upstream

If you're contributing skill content to the Streamlit repo, use the existing bundled skills under [`lib/streamlit/.agents/skills/`](https://github.com/streamlit/streamlit/tree/develop/lib/streamlit/.agents/skills) as reference. The format follows the [Agent Skills specification](https://agentskills.io/specification) — see the [Anthropic best-practices docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) for detailed guidance on writing effective skills. Always verify code examples against the latest Streamlit API at [docs.streamlit.io/llms-full.txt](https://docs.streamlit.io/llms-full.txt).
