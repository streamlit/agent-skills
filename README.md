# Streamlit Agent Skills

A collection of agent skills for building production-grade Streamlit apps. Each skill focuses on a specific aspect of Streamlit development, from performance optimization to visual design.

## Skills by Priority

| Priority | Skill | Impact | When to Use |
|----------|-------|--------|-------------|
| 1 | [streamlit-performance](skills/streamlit-performance/) | CRITICAL | Caching, fragments, static vs dynamic widgets |
| 2 | [streamlit-widgets](skills/streamlit-widgets/) | HIGH | Choosing the right widget for the job |
| 3 | [streamlit-layout](skills/streamlit-layout/) | HIGH | Sidebar, columns, containers, structure |
| 4 | [streamlit-visual-design](skills/streamlit-visual-design/) | MEDIUM | Icons, badges, spacing, text styling |
| 5 | [streamlit-charts-and-data](skills/streamlit-charts-and-data/) | MEDIUM | Charts, dataframes, metrics with sparklines |
| 6 | [streamlit-multipage](skills/streamlit-multipage/) | MEDIUM | Multi-page app structure and navigation |
| 7 | [streamlit-error-handling](skills/streamlit-error-handling/) | MEDIUM | Global exception handlers, logging, alerts |
| 8 | [streamlit-theming](skills/streamlit-theming/) | LOW | Custom colors via config.toml, avoiding CSS |
| 9 | [streamlit-testing](skills/streamlit-testing/) | LOW | AppTest framework, pytest integration |
| 10 | [streamlit-environment](skills/streamlit-environment/) | LOW | Python environment with uv |

## How to Route

**Performance issues or slow apps?** → `streamlit-performance`

**Building a new UI?** → Start with `streamlit-widgets` + `streamlit-layout`

**Making it look good?** → `streamlit-visual-design` + `streamlit-charts`

**Multi-page architecture?** → `streamlit-multipage`

**Production deployment?** → `streamlit-error-handling` + `streamlit-testing`

**Customizing appearance?** → `streamlit-theming`

**Setting up a project?** → `streamlit-environment`

## Quick Wins Checklist

- [ ] Replace `st.radio(..., horizontal=True)` → `st.segmented_control`
- [ ] Add `@st.cache_data` to data loading functions
- [ ] Add `@st.cache_resource` to connections
- [ ] Use `@st.fragment` for isolated UI components
- [ ] Replace static widgets with dynamic ones for heavy content
- [ ] Use Material icons instead of emojis
- [ ] Use sentence casing for titles
- [ ] Configure dataframe columns with `column_config`
- [ ] Set up global exception handler for production

## Resources

- [Streamlit Documentation](https://docs.streamlit.io/develop/api-reference)
- [streamlit-extras](https://github.com/arnaudmiribel/streamlit-extras)