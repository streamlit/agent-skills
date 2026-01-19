# Streamlit Agent Skills

A collection of agent skills for building production-grade Streamlit apps. Each skill focuses on a specific aspect of Streamlit development, from performance optimization to visual design.

## Skills by Priority

| Priority | Skill | Impact | When to Use |
|----------|-------|--------|-------------|
| 1 | [optimizing-streamlit-performance](optimizing-streamlit-performance/) | CRITICAL | Caching, fragments, static vs dynamic widgets |
| 2 | [choosing-streamlit-selection-widgets](choosing-streamlit-selection-widgets/) | HIGH | Choosing the right selection widget |
| 3 | [using-streamlit-layouts](using-streamlit-layouts/) | HIGH | Sidebar, columns, containers, dialogs |
| 4 | [improving-streamlit-design](improving-streamlit-design/) | MEDIUM | Icons, badges, spacing, text styling |
| 5 | [displaying-streamlit-data](displaying-streamlit-data/) | MEDIUM | Charts, dataframes, column configuration |
| 6 | [building-streamlit-dashboards](building-streamlit-dashboards/) | MEDIUM | KPI cards, metrics, dashboard layouts |
| 7 | [building-streamlit-multipage-apps](building-streamlit-multipage-apps/) | MEDIUM | Multi-page app structure and navigation |
| 8 | [organizing-streamlit-code](organizing-streamlit-code/) | MEDIUM | Separating UI from business logic, modules |
| 9 | [setting-up-streamlit-environment](setting-up-streamlit-environment/) | MEDIUM | Python environment with uv |
| 10 | [building-streamlit-chat-ui](building-streamlit-chat-ui/) | MEDIUM | Chat interfaces, chatbots, AI assistants |
| 11 | [customizing-streamlit-theme](customizing-streamlit-theme/) | LOW | Custom colors via config.toml, avoiding CSS |
| 12 | [using-streamlit-custom-components](using-streamlit-custom-components/) | LOW | Third-party custom components from the community |
| 13 | [connecting-streamlit-to-snowflake](connecting-streamlit-to-snowflake/) | LOW | Connecting to Snowflake with st.connection |

## How to Route

**Performance issues or slow apps?** → `optimizing-streamlit-performance`

**Building a new UI?** → Start with `choosing-streamlit-selection-widgets` + `using-streamlit-layouts`

**Building a dashboard?** → `building-streamlit-dashboards` + `displaying-streamlit-data`

**Making it look good?** → `improving-streamlit-design` + `choosing-streamlit-selection-widgets` + `displaying-streamlit-data` + `using-streamlit-layouts`

**Multi-page architecture?** → `building-streamlit-multipage-apps`

**Customizing appearance?** → `customizing-streamlit-theme`

**Setting up a project?** → `setting-up-streamlit-environment`

**App getting complex?** → `organizing-streamlit-code`

**Connecting to Snowflake?** → `connecting-streamlit-to-snowflake`

**Building a chatbot or AI assistant?** → `building-streamlit-chat-ui`

**Need features not in core Streamlit?** → `using-streamlit-custom-components`

## Resources

- [Streamlit Documentation](https://docs.streamlit.io/develop/api-reference)
