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

### Install once, works with every project

Because discovery happens dynamically against whichever interpreter is active, a single **user-level install** of this meta-skill works across every project on your machine — regardless of which Streamlit version each project pins. Upgrade a project's Streamlit and the agent automatically picks up the newer bundled skills; no re-install needed.

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

This repository contains a single meta-skill (`developing-with-streamlit`). **Install it once at the user level** — the meta-skill resolves the bundled skills dynamically from whichever Python interpreter is active, so one global install works across every project and every Streamlit version you use.

### Claude Code

Anthropic's Claude Code does not yet ship an official `skills install` CLI. Clone this repo and drop the skill folder into your user-level Claude skills directory:

```bash
git clone https://github.com/streamlit/agent-skills.git
cp -r agent-skills/developing-with-streamlit ~/.claude/skills/
```

If you prefer project-scoped install, copy to `.claude/skills/` in your repo root instead. See the [Claude Code skills docs](https://docs.anthropic.com/en/docs/claude-code/skills) for the latest guidance.

### GitHub Copilot

```bash
gh skill install streamlit/agent-skills developing-with-streamlit --scope user
```

Available via the GitHub CLI (`gh`) as of April 2026. Drop `--scope user` to install to the current repo only, or pin a version with `developing-with-streamlit@v1.0.0`. See the [Copilot agent skills docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/add-skills).

### Cursor

The same GitHub CLI supports Cursor via `--agent`:

```bash
gh skill install streamlit/agent-skills developing-with-streamlit --agent cursor --scope user
```

See the [Cursor skills docs](https://cursor.com/docs/context/skills) for alternative install flows (Settings UI, manual placement in `~/.cursor/skills/`).

### Gemini CLI

```bash
gemini skills install https://github.com/streamlit/agent-skills.git
```

Defaults to `~/.gemini/skills/` (user scope). Add `--scope workspace` to install locally instead. See the [Gemini CLI skills docs](https://geminicli.com/docs/cli/skills/).

### OpenAI Codex

Codex installs skills interactively. From inside a Codex session, run:

```
$skill-installer
```

Then point the installer at `streamlit/agent-skills`. Skills land in `~/.codex/skills/` (user). See the [Codex skills docs](https://developers.openai.com/codex/skills/).

### Snowflake Cortex Code

```bash
cortex skill add streamlit/agent-skills
```

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
