# Agent Skills for Streamlit Development

A lightweight **meta-skill** that teaches AI coding assistants (Claude Code, Cursor, and others) how to discover and load the Streamlit development skills bundled inside the Streamlit pip package (1.57+).

## What are Agent Skills?

Agent Skills are specialized instruction sets that enhance AI coding assistants' capabilities for specific tasks. Each skill contains instructions, scripts, and resources that the AI loads dynamically to improve performance on Streamlit development workflows.

The actual skill content (dashboards, themes, layouts, session state, custom components, etc.) ships with Streamlit itself — this repo only contains the entry point that bootstraps discovery.

## How it works

Starting with Streamlit 1.57, the full set of Streamlit development skills ships **inside the Streamlit pip package** itself. This repository provides a lightweight **meta-skill** that teaches agents how to discover and load those bundled skills.

The meta-skill ([`developing-with-streamlit/SKILL.md`](developing-with-streamlit/SKILL.md)):

1. Detects the active Python interpreter (virtualenv, conda, pipenv, poetry, pdm, uv, or system)
2. Locates the installed Streamlit package path
3. Points the agent to the bundled skills at `<streamlit_path>/.agents/skills/`
4. Falls back to the [online docs](https://docs.streamlit.io/llms-full.txt) for older Streamlit versions

### Install once, works with every project

Because discovery happens dynamically against whichever interpreter is active, a single **user-level install** of this meta-skill works across every project on your machine — regardless of which Streamlit version each project pins. Upgrade a project's Streamlit and the agent automatically picks up the newer bundled skills; no re-install needed.

## Installation

This repository contains a single meta-skill (`developing-with-streamlit`). **Install it once at the user level** — the meta-skill resolves the bundled skills dynamically from whichever Python interpreter is active, so one global install works across every project and every Streamlit version you use.

### Cross-agent: `npx skills` (recommended)

[`skills`](https://github.com/vercel-labs/skills) ([docs](https://skills.sh)) is a Vercel-published cross-agent installer that supports Claude Code, Cursor, Copilot, Gemini CLI, Codex, and others — one command, all agents:

```bash
npx skills add streamlit/agent-skills -s developing-with-streamlit -g
```

`-s` picks the specific skill from this repo; `-g` installs at the user level (global) so it works across every project. Drop `-g` to install into the current project's `.<agent>/skills/` directory instead. See `npx skills add --help` for the full flag list.

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

Already installed — Cortex Code ships this skill by default; no manual step required.

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
