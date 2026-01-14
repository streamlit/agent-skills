# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, etc.) when working with code in this repository.

## Repository Overview

This is a collection of Agent Skills for building Streamlit applications. Skills are instruction sets that enhance AI coding assistants' capabilities for specific tasks.

**Key files:**
- `skills/` - Contains all available skills, each in its own directory
- `template/` - Template for creating new skills
- `README.md` - Human-readable documentation

## Skill Structure

Each skill is a directory containing a `SKILL.md` file:

```
skills/
└── skill-name/
    └── SKILL.md    # Required: Instructions for the AI agent
```

Skills are instruction-only—no executable scripts or additional files are required.

## Creating a New Skill

### 1. Create the Skill Directory

```bash
cp -r template skills/my-new-skill
```

Use lowercase names with hyphens (e.g., `data-visualization`, `api-client`).

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

### Required Frontmatter Fields

| Field | Description | Constraints |
|-------|-------------|-------------|
| `name` | Unique skill identifier | Lowercase, hyphens only, max 64 chars |
| `description` | What the skill does and when to use it | Max 1024 chars, include keywords |

### Optional Frontmatter Fields

| Field | Description |
|-------|-------------|
| `license` | License identifier (e.g., `Apache-2.0`) |
| `metadata` | Additional properties (author, version, tags) |

## SKILL.md Content Guidelines

Structure your skill instructions with these sections:

1. **When to Use This Skill** - Clear triggers for when the skill applies
2. **Instructions/Patterns** - Step-by-step guidance or code patterns
3. **Examples** - Concrete code examples showing usage
4. **Common Pitfalls** - Mistakes to avoid
5. **References** - Links to official documentation

### Best Practices for Context Efficiency

Skills are loaded on-demand—only the skill name and description are loaded at startup. The full `SKILL.md` loads into context only when the agent decides the skill is relevant. To minimize context usage:

- **Keep SKILL.md under 500 lines**: Put detailed reference material in separate files if needed
- **Write specific descriptions**: Helps the agent know exactly when to activate the skill
- **Use progressive disclosure**: Reference supporting files that get read only when needed
- **Be concise**: Every line should provide value
- **Use code examples**: Show, don't just tell
- **Avoid redundancy**: Don't repeat information
- **Prioritize patterns**: Focus on reusable patterns over exhaustive API docs
- **Link to references**: Point to official docs for comprehensive details

### Description Keywords

Include relevant keywords in the `description` field to help AI agents identify when to use the skill:

```yaml
description: Build Streamlit applications following best practices. Use when creating dashboards, data apps, interactive visualizations, or any Python web application with Streamlit.
```

## Testing a Skill

To validate a skill works correctly:

1. Load the skill in your AI assistant (Claude Code, Cursor, etc.)
2. Test with prompts that should trigger the skill
3. Verify the AI follows the skill's patterns and guidelines
4. Check that generated code matches the skill's examples

## File Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Skill directory | lowercase-with-hyphens | `streamlit-app` |
| Skill file | Always `SKILL.md` | `SKILL.md` |
| Frontmatter name | Matches directory name | `name: streamlit-app` |


## Contributing

When adding or modifying skills:

1. Follow the template structure in `template/SKILL.md`
2. Ensure the skill is focused on a specific, well-defined task
3. Include practical code examples
4. Test the skill with an AI assistant before submitting
