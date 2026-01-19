# Agent Skills for Streamlit Development

A collection of [Agent Skills](https://agentskills.io) for building Streamlit applications with AI coding assistants like Claude Code, Cursor, and other AI-powered development tools.

## What are Agent Skills?

Agent Skills are specialized instruction sets that enhance AI coding assistants' capabilities for specific tasks. Each skill contains instructions, scripts, and resources that the AI loads dynamically to improve performance on Streamlit development workflows.

## Available skills

| Skill | Description |
|-------|-------------|
| [building-streamlit-chat-ui](skills/building-streamlit-chat-ui/) | Chat interfaces, chatbots, AI assistants |
| [building-streamlit-dashboards](skills/building-streamlit-dashboards/) | KPI cards, metrics, dashboard layouts |
| [building-streamlit-multipage-apps](skills/building-streamlit-multipage-apps/) | Multi-page app structure and navigation |
| [choosing-streamlit-selection-widgets](skills/choosing-streamlit-selection-widgets/) | Choosing the right selection widget |
| [connecting-streamlit-to-snowflake](skills/connecting-streamlit-to-snowflake/) | Connecting to Snowflake with st.connection |
| [customizing-streamlit-theme](skills/customizing-streamlit-theme/) | Custom colors via config.toml |
| [displaying-streamlit-data](skills/displaying-streamlit-data/) | Dataframes, column config, charts |
| [improving-streamlit-design](skills/improving-streamlit-design/) | Icons, badges, spacing, text styling |
| [optimizing-streamlit-performance](skills/optimizing-streamlit-performance/) | Caching, fragments, forms, static vs dynamic widgets |
| [organizing-streamlit-code](skills/organizing-streamlit-code/) | Separating UI from business logic, modules |
| [setting-up-streamlit-environment](skills/setting-up-streamlit-environment/) | Python environment setup |
| [using-streamlit-custom-components](skills/using-streamlit-custom-components/) | Third-party components from the community |
| [using-streamlit-layouts](skills/using-streamlit-layouts/) | Sidebar, columns, containers, dialogs |

## Installation

### Claude Code

Copy a skill folder to your Claude Code skills directory:

```bash
cp -r skills/optimizing-streamlit-performance ~/.claude/skills/
```

Or reference skills directly in your project by adding them to your `.claude/skills/` directory.

### Cursor

Copy a skill folder to your [Cursor skills directory](https://cursor.com/docs/context/skills):

```bash
cp -r skills/optimizing-streamlit-performance ~/.cursor/skills/
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
