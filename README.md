# Agent Skills for Streamlit Development

A lightweight **meta-skill** that teaches AI coding assistants (Claude Code, Cursor, and others) how to discover and load the Streamlit development skills bundled inside the Streamlit pip package (1.57+).

## What are Agent Skills?

Agent Skills are specialized instruction sets that enhance AI coding assistants' capabilities for specific tasks. Each skill contains instructions, scripts, and resources that the AI loads dynamically to improve performance on Streamlit development workflows.

The actual skill content (dashboards, themes, layouts, session state, custom components, etc.) ships with Streamlit itself — this repo only contains the entry point that bootstraps discovery.

## How it works

Starting with Streamlit 1.57, the full set of Streamlit development skills ships **inside the Streamlit pip package** itself. This repository provides a lightweight **meta-skill** that teaches agents how to discover and load those bundled skills.

The meta-skill ([`developing-with-streamlit/SKILL.md`](developing-with-streamlit/SKILL.md)):

1. Detects the active Python interpreter (virtualenv, conda, uv, or system)
2. Locates the installed Streamlit package path
3. Points the agent to the bundled skills at `<streamlit_path>/.agents/skills/`
4. Falls back to the [online docs](https://docs.streamlit.io/llms-full.txt) for older Streamlit versions

## Available skills (bundled with Streamlit 1.57+)

Once discovered via the meta-skill, the bundled `developing-with-streamlit` routing skill provides access to these sub-skills:

| Skill | Description |
|-------|-------------|
| building-streamlit-chat-ui | Chat interfaces, chatbots, AI assistants |
| building-streamlit-dashboards | KPI cards, metrics, dashboard layouts |
| building-streamlit-multipage-apps | Multi-page app structure and navigation |
| building-streamlit-custom-components-v2 | Custom Components v2, bidirectional state, bundling |
| choosing-streamlit-selection-widgets | Choosing the right selection widget |
| connecting-streamlit-to-snowflake | Connecting to Snowflake with st.connection |
| creating-streamlit-themes | Theme configuration, colors, fonts, light/dark modes |
| displaying-streamlit-data | Dataframes, column config, charts |
| improving-streamlit-design | Icons, badges, spacing, text styling |
| optimizing-streamlit-performance | Caching, fragments, forms, static vs dynamic widgets |
| organizing-streamlit-code | Separating UI from business logic, modules |
| setting-up-streamlit-environment | Python environment setup |
| using-streamlit-cli | CLI commands, running apps |
| using-streamlit-custom-components | Third-party components from the community |
| using-streamlit-layouts | Sidebar, columns, containers, dialogs |
| using-streamlit-markdown | Colored text, badges, icons, LaTeX, markdown features |
| using-streamlit-session-state | Session state, widget keys, callbacks, state persistence |

## Installation

### Claude Code

Copy the meta-skill folder to your Claude Code skills directory:

```bash
cp -r developing-with-streamlit ~/.claude/skills/
```

Or reference it directly in your project by adding it to your `.claude/skills/` directory.

### Cursor

Copy the meta-skill folder to your [Cursor skills directory](https://cursor.com/docs/context/skills):

```bash
cp -r developing-with-streamlit ~/.cursor/skills/
```

Or add it directly to your project's `.cursor/skills/` directory.

### Snowflake Cortex Code

Install the skill directly from GitHub:

```bash
cortex skill add streamlit/agent-skills
```

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
