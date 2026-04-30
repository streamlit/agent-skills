# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository overview

This repository contains a **single meta-skill** that teaches AI agents how to discover Streamlit development skills bundled inside the Streamlit pip package (1.57+).

The actual skill content (dashboards, themes, layouts, session state, custom components, etc.) now ships with Streamlit itself. This repo provides the entry point that bootstraps that discovery — new skill content should be contributed upstream to the [Streamlit repository](https://github.com/streamlit/streamlit), not added here.

**Key files:**
- `developing-with-streamlit/SKILL.md` — Meta-skill that locates and loads bundled Streamlit skills
- `template/` — Reference template for anyone authoring a new skill (locally or upstream)
- `README.md` — Human-readable documentation

## Meta-skill contract

The meta-skill at `developing-with-streamlit/SKILL.md` resolves the bundled routing skill by:

1. Detecting the active Python interpreter (`$VIRTUAL_ENV` → `.venv` → `../.venv` → conda → uv → system).
2. Running `python -c "import streamlit; print(streamlit.__path__[0])"` to locate the installed package.
3. Loading `<streamlit_path>/.agents/skills/developing-with-streamlit/SKILL.md`.
4. Falling back to `pip install streamlit` when missing, or `https://docs.streamlit.io/llms-full.txt` when the installed version predates bundled skills.

When editing the meta-skill, preserve this contract. Changes that alter interpreter detection order, the package-path lookup, or the fallback behavior should be explicit and reviewed.

## Skill authoring reference (for upstream contributions)

The guidance below describes how skills are structured. Use it when contributing new skills **upstream to Streamlit**, not when modifying this repo.

### Skill structure

Each skill is a directory containing a required `SKILL.md` file and optional supporting directories:

```
skill-name/
├── SKILL.md          # Required: Instructions for the AI agent
├── scripts/          # Optional: Executable code
├── references/       # Optional: Additional documentation
└── assets/           # Optional: Static resources
```

| Directory | Purpose | Example Contents |
|-----------|---------|------------------|
| `scripts/` | Executable code that agents can run directly | `extract.py`, `process.sh`, `transform.js` |
| `references/` | Supplementary documentation loaded on-demand | `REFERENCE.md`, `FORMS.md`, domain-specific docs |
| `assets/` | Non-executable static resources | Templates, images, lookup tables, schemas |

**Script conventions**: write status messages to stderr (`echo 'Processing...' >&2`) and machine-readable output (JSON) to stdout. This keeps human-readable progress separate from parseable results.

### Frontmatter

`SKILL.md` must include YAML frontmatter and markdown instructions:

```yaml
---
name: skill-name
description: Clear description of what this skill does and when to use it.
---

# Skill Name

Instructions for the AI agent...
```

| Field | Description | Constraints |
|-------|-------------|-------------|
| `name` | Unique skill identifier | Lowercase letters, numbers, and hyphens only; max 64 chars; no XML tags; cannot contain "anthropic" or "claude" |
| `description` | What the skill does and when to use it | Non-empty; max 1024 chars; no XML tags; include keywords |
| `license` | (Optional) License identifier (e.g., `Apache-2.0`) | |
| `metadata` | (Optional) Additional properties (author, version, tags) | |

### Naming conventions

| Item | Convention | Example |
|------|------------|---------|
| Skill directory | lowercase-with-hyphens (gerund form preferred) | `building-dashboards` |
| Skill file | Always `SKILL.md` | `SKILL.md` |
| Frontmatter `name` | Matches directory name | `name: building-dashboards` |

Avoid vague names (`helper`, `utils`) or reserved words (`anthropic-*`, `claude-*`).

### Best practices

See the official [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md) for comprehensive guidance. Key points:

- **Keep SKILL.md under 500 lines** — use separate reference files for detailed content
- **Write specific descriptions** — include what the skill does AND when to use it
- **Use third person** in descriptions (e.g., "Processes files" not "I can process files")
- **Be concise** — the context window is a shared resource
- **Keep file references one level deep** from SKILL.md
- **Use sentence casing for titles and headers** — capitalize only the first word and proper nouns
- **Verify all links are publicly accessible**

### Streamlit-specific guidelines

Skills should always target the **latest Streamlit version**. When authoring or updating skills:

1. Fetch the latest docs from [docs.streamlit.io/llms-full.txt](https://docs.streamlit.io/llms-full.txt) (markdown format optimized for LLMs).
2. Verify all code examples against the current API — check for deprecated methods or new alternatives.

## Contributing

- **New or updated Streamlit skill content** → open a PR against [streamlit/streamlit](https://github.com/streamlit/streamlit) targeting `streamlit/.agents/skills/`.
- **Changes to the meta-skill itself** (discovery logic, fallbacks, docs) → open a PR against this repo. Keep the discovery contract described above intact unless the change is intentional.
- See [CONTRIBUTING.md](CONTRIBUTING.md) for general guidelines.
