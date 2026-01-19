# Contributing

We welcome contributions but are opinionated about what we include—skills should be focused, well-written, and follow Streamlit best practices.

**Before you start**: Read [AGENTS.md](AGENTS.md) for detailed guidance on writing skills for this repository, including Streamlit-specific guidelines, naming conventions, and context efficiency tips.

## Creating a New Skill

1. Copy the template:
   ```bash
   cp -r template developing-with-streamlit/skills/my-new-skill
   ```

2. Edit `developing-with-streamlit/skills/my-new-skill/SKILL.md` with your skill's instructions

3. Add the new skill to the sub-skills table in `developing-with-streamlit/SKILL.md`

3. Follow the [Agent Skills Specification](https://agentskills.io/specification) for formatting

## Skill Format

Each skill is a directory containing a required `SKILL.md` file and optional supporting directories:

```
skill-name/
├── SKILL.md          # Required - skill instructions
├── scripts/          # Optional - executable code (Python, Bash, JavaScript)
├── references/       # Optional - additional documentation
└── assets/           # Optional - static resources (templates, images, data files)
```

### SKILL.md

The `SKILL.md` file contains YAML frontmatter and markdown instructions:

```yaml
---
name: skill-name
description: A clear description of what this skill does and when to use it.
---

# Skill Instructions

Your instructions here...
```

### Optional Directories

| Directory | Purpose | Contents |
|-----------|---------|----------|
| `scripts/` | Executable code that agents can run | Python, Bash, JavaScript files |
| `references/` | Additional documentation loaded on-demand | Markdown files, domain-specific docs |
| `assets/` | Static resources | Templates, images, data files, schemas |

These directories support progressive disclosure—files are loaded only when needed, keeping context usage efficient.

### Required Fields

| Field | Description | Constraints |
|-------|-------------|-------------|
| `name` | Unique skill identifier | Lowercase letters, numbers, and hyphens only; max 64 chars; no XML tags; cannot contain "anthropic" or "claude" |
| `description` | What the skill does and when to use it | Non-empty; max 1024 chars; no XML tags; include keywords |

### Optional Fields

| Field | Description |
|-------|-------------|
| `license` | License identifier (e.g., `Apache-2.0`) |
| `compatibility` | Environment requirements |
| `metadata` | Additional properties (author, version, etc.) |

## Best Practices

- Comprehensive guidance: [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- Streamlit-specific: [AGENTS.md](AGENTS.md)
