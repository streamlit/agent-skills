# Streamlit Agent Skills

This directory contains agent skills for building Streamlit applications. These skills are designed to help AI coding assistants provide better guidance when developers are building Streamlit apps.

## Available Skills

| Skill | Description | Lines |
|-------|-------------|-------|
| [streamlit-best-practices](./streamlit-best-practices/) | Opinionated coding conventions and anti-patterns | 252 |
| [building-streamlit-apps](./building-streamlit-apps/) | Core execution model, session state, widget patterns, caching basics | 189 |
| [optimizing-streamlit-performance](./optimizing-streamlit-performance/) | Caching strategies, fragments, forms, large data handling | 202 |
| [building-streamlit-chat-apps](./building-streamlit-chat-apps/) | Chat interfaces, LLM integration, streaming responses | 217 |
| [displaying-streamlit-data](./displaying-streamlit-data/) | DataFrames, charts, metrics, column configuration | 228 |
| [designing-streamlit-layouts](./designing-streamlit-layouts/) | Columns, sidebar, tabs, dialogs, status elements | 243 |
| [building-streamlit-multipage-apps](./building-streamlit-multipage-apps/) | Navigation, cross-page state, URL parameters | 181 |
| [connecting-streamlit-data](./connecting-streamlit-data/) | Database connections, st.connection, secrets | 152 |
| [securing-streamlit-apps](./securing-streamlit-apps/) | Secrets management, OIDC authentication, security | 220 |
| [testing-streamlit-apps](./testing-streamlit-apps/) | AppTest framework, pytest integration | 253 |

## Skill Format

Each skill follows the [Agent Skills specification](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview):

- **YAML frontmatter** with `name` and `description`
- **Concise instructions** (all files under 500 lines)
- **Code examples** showing good vs bad patterns
- **Reference links** to official documentation

## Usage

These skills can be used with:
- [Claude Code](https://code.claude.com/)
- [Claude Agent SDK](https://docs.anthropic.com/en/agent-sdk/)
- [Anthropic API](https://docs.anthropic.com/)
- [Cursor](https://cursor.com/)
- Other AI coding assistants that support agent skills

## Skill Triggering

Skills are triggered based on their descriptions. Key trigger phrases for each:

- **streamlit-best-practices**: "best practices", "conventions", "code quality", "anti-patterns"
- **building-streamlit-apps**: "Streamlit app", "session state", "widget", "rerun"
- **optimizing-streamlit-performance**: "slow", "performance", "cache", "large data"
- **building-streamlit-chat-apps**: "chat", "chatbot", "LLM", "OpenAI", "streaming"
- **displaying-streamlit-data**: "dataframe", "chart", "metric", "visualization"
- **designing-streamlit-layouts**: "layout", "columns", "sidebar", "tabs", "dialog"
- **building-streamlit-multipage-apps**: "multipage", "navigation", "pages"
- **connecting-streamlit-data**: "database", "connection", "SQL", "API"
- **securing-streamlit-apps**: "secrets", "authentication", "security", "login"
- **testing-streamlit-apps**: "test", "pytest", "AppTest", "CI/CD"

## Contributing

When updating skills:
1. Keep files under 500 lines
2. Use concise language (Claude already knows basics)
3. Provide good/bad code examples
4. Include links to official docs
5. Test with multiple Claude models (Haiku, Sonnet, Opus)
