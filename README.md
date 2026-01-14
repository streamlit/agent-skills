# Agent Skills for Streamlit Development

A collection of [Agent Skills](https://agentskills.io) for building Streamlit applications with AI coding assistants like Claude Code, Cursor, and other AI-powered development tools.

## What are Agent Skills?

Agent Skills are specialized instruction sets that enhance AI coding assistants' capabilities for specific tasks. Each skill contains instructions, scripts, and resources that the AI loads dynamically to improve performance on Streamlit development workflows.

## Available Skills

| Skill | Description |
|-------|-------------|
| [streamlit-app-basics](skills/streamlit-app-basics/) | Build Streamlit applications following best practices |

## Installation

### Claude Code

Copy a skill folder to your Claude Code skills directory:

```bash
cp -r skills/streamlit-app-basics ~/.claude/skills/
```

Or reference skills directly in your project by adding them to your `.claude/skills/` directory.

### Claude.ai

Copy the contents of a skill's `SKILL.md` file and paste it into your Claude.ai conversation or upload as a custom skill.

### Other AI Assistants

Most AI coding assistants support custom instructions. Copy the relevant `SKILL.md` content into your assistant's custom instructions or system prompt.

## Creating a New Skill

1. Copy the template:
   ```bash
   cp -r template skills/my-new-skill
   ```

2. Edit `skills/my-new-skill/SKILL.md` with your skill's instructions

3. Follow the [Agent Skills Specification](https://agentskills.io/specification) for formatting

## Skill Format

Each skill requires a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: skill-name
description: A clear description of what this skill does and when to use it.
---

# Skill Instructions

Your instructions here...
```

### Required Fields

| Field | Description |
|-------|-------------|
| `name` | Unique identifier (lowercase, hyphens, max 64 chars) |
| `description` | What the skill does and when to use it (max 1024 chars) |

### Optional Fields

| Field | Description |
|-------|-------------|
| `license` | License identifier (e.g., `Apache-2.0`) |
| `compatibility` | Environment requirements |
| `metadata` | Additional properties (author, version, etc.) |

## Contributing

Contributions welcome! Fork the repo, create your skill in `skills/`, and submit a PR.

## Related Resources

- [Agent Skills Specification](https://agentskills.io/specification)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Streamlit Documentation](https://docs.streamlit.io)
- [Streamlit API Reference](https://docs.streamlit.io/library/api-reference)

## License

This project is licensed under the Apache 2.0 License - see individual skills for their specific licenses.
