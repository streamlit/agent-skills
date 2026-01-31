# Agent Skills for Streamlit Development

A collection of [Agent Skills](https://agentskills.io) for building Streamlit applications with AI coding assistants like Claude Code, Cursor, and other AI-powered development tools.

## What are Agent Skills?

Agent Skills are specialized instruction sets that enhance AI coding assistants' capabilities for specific tasks. Each skill contains instructions, scripts, and resources that the AI loads dynamically to improve performance on Streamlit development workflows.

## Available skills

The main skill is [`developing-with-streamlit`](developing-with-streamlit/SKILL.md), which routes to specialized sub-skills:

| Skill | Description |
|-------|-------------|
| [building-streamlit-chat-ui](developing-with-streamlit/skills/building-streamlit-chat-ui/) | Chat interfaces, chatbots, AI assistants |
| [building-streamlit-dashboards](developing-with-streamlit/skills/building-streamlit-dashboards/) | KPI cards, metrics, dashboard layouts |
| [building-streamlit-multipage-apps](developing-with-streamlit/skills/building-streamlit-multipage-apps/) | Multi-page app structure and navigation |
| [choosing-streamlit-selection-widgets](developing-with-streamlit/skills/choosing-streamlit-selection-widgets/) | Choosing the right selection widget |
| [connecting-streamlit-to-snowflake](developing-with-streamlit/skills/connecting-streamlit-to-snowflake/) | Connecting to Snowflake with st.connection |
| [creating-streamlit-themes](developing-with-streamlit/skills/creating-streamlit-themes/) | Theme configuration, colors, fonts, light/dark modes, professional brand alignment, CSS avoidance |
| [displaying-streamlit-data](developing-with-streamlit/skills/displaying-streamlit-data/) | Dataframes, column config, charts |
| [improving-streamlit-design](developing-with-streamlit/skills/improving-streamlit-design/) | Icons, badges, spacing, text styling |
| [optimizing-streamlit-performance](developing-with-streamlit/skills/optimizing-streamlit-performance/) | Caching, fragments, forms, static vs dynamic widgets |
| [organizing-streamlit-code](developing-with-streamlit/skills/organizing-streamlit-code/) | Separating UI from business logic, modules |
| [setting-up-streamlit-environment](developing-with-streamlit/skills/setting-up-streamlit-environment/) | Python environment setup |
| [using-streamlit-cli](developing-with-streamlit/skills/using-streamlit-cli/) | CLI commands, running apps |
| [using-streamlit-custom-components](developing-with-streamlit/skills/using-streamlit-custom-components/) | Third-party components from the community |
| [using-streamlit-layouts](developing-with-streamlit/skills/using-streamlit-layouts/) | Sidebar, columns, containers, dialogs |
| [using-streamlit-markdown](developing-with-streamlit/skills/using-streamlit-markdown/) | Colored text, badges, icons, LaTeX, markdown features |
| [using-streamlit-session-state](developing-with-streamlit/skills/using-streamlit-session-state/) | Session state, widget keys, callbacks, state persistence |

## Installation

### Claude Code

Copy the parent skill folder to your Claude Code skills directory:

```bash
cp -r developing-with-streamlit ~/.claude/skills/
```

Or reference skills directly in your project by adding them to your `.claude/skills/` directory.

### Cursor

Copy the parent skill folder to your [Cursor skills directory](https://cursor.com/docs/context/skills):

```bash
cp -r developing-with-streamlit ~/.cursor/skills/
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
