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

### Cursor

Copy a skill folder to your [Cursor skills directory](https://cursor.com/docs/context/skills):

```bash
cp -r skills/streamlit-app-basics ~/.cursor/skills/
```

Or add skills directly to your project's `.cursor/skills/` directory.

### Other AI Assistants

| Agent | Skills Folder | Documentation |
|-------|---------------|---------------|
| OpenAI Codex | `.codex/skills/` | [Codex Skills Docs](https://developers.openai.com/codex/skills/) |
| Gemini CLI | `.gemini/skills/` | [Gemini CLI Skills Docs](https://geminicli.com/docs/cli/skills/) |
| GitHub Copilot | `.github/skills/` | [Copilot Agent Skills Docs](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills) |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on creating new skills.

## Related Resources

- [Agent Skills Specification](https://agentskills.io/specification)
- [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Streamlit Documentation](https://docs.streamlit.io)
- [Streamlit API Reference](https://docs.streamlit.io/library/api-reference)

## License

This project is licensed under the Apache 2.0 License - see individual skills for their specific licenses.
