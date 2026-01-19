# Streamlit Agent Skills

A collection of agent skills for building production-grade Streamlit apps. Each skill focuses on a specific aspect of Streamlit development, from performance optimization to visual design.

## Skills by Priority

| Priority | Skill | Impact | When to Use |
|----------|-------|--------|-------------|
| 1 | [optimizing-streamlit-performance](optimizing-streamlit-performance/) | CRITICAL | Caching, fragments, static vs dynamic widgets |
| 2 | [choosing-streamlit-widgets](choosing-streamlit-widgets/) | HIGH | Choosing the right selection widget |
| 3 | [structuring-streamlit-layout](structuring-streamlit-layout/) | HIGH | Sidebar, columns, containers, dialogs |
| 4 | [designing-streamlit-visuals](designing-streamlit-visuals/) | MEDIUM | Icons, badges, spacing, text styling |
| 5 | [displaying-streamlit-data](displaying-streamlit-data/) | MEDIUM | Charts, dataframes, metrics with sparklines |
| 6 | [building-streamlit-multipage-apps](building-streamlit-multipage-apps/) | MEDIUM | Multi-page app structure and navigation |
| 7 | [organizing-streamlit-code](organizing-streamlit-code/) | MEDIUM | Separating UI from business logic, modules |
| 8 | [setting-up-streamlit-environment](setting-up-streamlit-environment/) | MEDIUM | Python environment with uv |
| 9 | [building-streamlit-chat](building-streamlit-chat/) | MEDIUM | Chat interfaces, chatbots, AI assistants |
| 10 | [theming-streamlit-apps](theming-streamlit-apps/) | LOW | Custom colors via config.toml, avoiding CSS |
| 11 | [using-streamlit-components](using-streamlit-components/) | LOW | Third-party components from the community |
| 12 | [connecting-streamlit-to-snowflake](connecting-streamlit-to-snowflake/) | LOW | Connecting to Snowflake with st.connection |

## How to Route

**Performance issues or slow apps?** → `optimizing-streamlit-performance`

**Building a new UI?** → Start with `choosing-streamlit-widgets` + `structuring-streamlit-layout`

**Making it look good?** → `designing-streamlit-visuals` + `choosing-streamlit-widgets` + `displaying-streamlit-data` + `structuring-streamlit-layout`

**Multi-page architecture?** → `building-streamlit-multipage-apps`

**Customizing appearance?** → `theming-streamlit-apps`

**Setting up a project?** → `setting-up-streamlit-environment`

**App getting complex?** → `organizing-streamlit-code`

**Connecting to Snowflake?** → `connecting-streamlit-to-snowflake`

**Building a chatbot or AI assistant?** → `building-streamlit-chat`

**Need features not in core Streamlit?** → `using-streamlit-components`

## Quick Wins Checklist

- [ ] Replace `st.radio(..., horizontal=True)` → `st.segmented_control`
- [ ] Add `@st.cache_data` to data loading functions
- [ ] Add `@st.cache_resource` to connections
- [ ] Use `@st.fragment` for isolated UI components
- [ ] Replace static widgets with dynamic ones for heavy content
- [ ] Use Material icons instead of emojis
- [ ] Use sentence casing for titles
- [ ] Configure dataframe columns with `column_config`

## Resources

- [Streamlit Documentation](https://docs.streamlit.io/develop/api-reference)
