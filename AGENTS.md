# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository overview

This is a collection of Agent Skills for building Streamlit applications. Skills are instruction sets that enhance AI coding assistants' capabilities for specific tasks.

**Key files:**
- `skills/` - Contains all available skills, each in its own directory
- `template/` - Template for creating new skills
- `README.md` - Human-readable documentation

## Skill structure

Each skill is a directory containing a required `SKILL.md` file and optional supporting directories:

```
skills/
└── skill-name/
    ├── SKILL.md          # Required: Instructions for the AI agent
    ├── scripts/          # Optional: Executable code
    ├── references/       # Optional: Additional documentation
    └── assets/           # Optional: Static resources
```

### Optional directories

| Directory | Purpose | Example Contents |
|-----------|---------|------------------|
| `scripts/` | Executable code that agents can run directly | `extract.py`, `process.sh`, `transform.js` |
| `references/` | Supplementary documentation loaded on-demand | `REFERENCE.md`, `FORMS.md`, domain-specific docs |
| `assets/` | Non-executable static resources | Templates, images, lookup tables, schemas |

**Script conventions**: When writing executable scripts, write status messages to stderr (`echo 'Processing...' >&2`) and machine-readable output (JSON) to stdout. This keeps human-readable progress separate from parseable results.

## Creating a new skill

### 1. Create the skill directory

```bash
cp -r template skills/my-new-skill
```

Use lowercase names with hyphens. The recommended naming convention is **gerund form** (verb + -ing):
- `processing-pdfs`
- `analyzing-spreadsheets`
- `building-dashboards`

Avoid vague names (`helper`, `utils`) or reserved words (`anthropic-*`, `claude-*`).

### 2. Edit SKILL.md

The `SKILL.md` file must include YAML frontmatter and markdown instructions:

```yaml
---
name: skill-name
description: Clear description of what this skill does and when to use it.
---

# Skill Name

Instructions for the AI agent...
```

### Required frontmatter fields

| Field | Description | Constraints |
|-------|-------------|-------------|
| `name` | Unique skill identifier | Lowercase letters, numbers, and hyphens only; max 64 chars; no XML tags; cannot contain "anthropic" or "claude" |
| `description` | What the skill does and when to use it | Non-empty; max 1024 chars; no XML tags; include keywords |

### Optional frontmatter fields

| Field | Description |
|-------|-------------|
| `license` | License identifier (e.g., `Apache-2.0`) |
| `metadata` | Additional properties (author, version, tags) |

## File naming conventions

| Item | Convention | Example |
|------|------------|---------|
| Skill directory | lowercase-with-hyphens (gerund form preferred) | `building-dashboards` |
| Skill file | Always `SKILL.md` | `SKILL.md` |
| Frontmatter name | Matches directory name | `name: building-dashboards` |

## Best practices

For comprehensive guidance on writing effective skills, see the official [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md).

Key points:
- **Keep SKILL.md under 500 lines** - Use separate reference files for detailed content
- **Write specific descriptions** - Include what the skill does AND when to use it
- **Use third person** in descriptions (e.g., "Processes files" not "I can process files")
- **Be concise** - The context window is a shared resource
- **Keep file references one level deep** from SKILL.md
- **Use sentence casing for titles and headers** - Capitalize only the first word and proper nouns (e.g., "Creating a new skill" not "Creating a New Skill")
- **Verify all links are publicly accessible** - Ensure URLs point to existing, publicly available resources

## Streamlit-specific guidelines

Skills in this repository should always target the **latest Streamlit version**. Streamlit's API evolves frequently, and skills should reflect current best practices.

When writing or updating skills:

1. **Fetch the latest Streamlit documentation and API reference** from [docs.streamlit.io/llms-full.txt](https://docs.streamlit.io/llms-full.txt) (markdown format optimized for LLMs)
2. **Verify all code examples** against the current API - check for deprecated methods or new alternatives

This ensures skills provide accurate, up-to-date guidance rather than outdated patterns.

## Contributing

When adding or modifying skills:

1. Follow the template structure in `template/SKILL.md`
2. Ensure the skill is focused on a specific, well-defined task
3. Include practical code examples
4. Verify against the latest [Streamlit documentation](https://docs.streamlit.io/llms-full.txt)
5. Review against the [best practices for skill writing](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md)
6. **Update documentation when adding or renaming skills** - Reflect changes in `README.md` (Available skills table) and `developing-with-streamlit/SKILL.md` (Skill map table)
