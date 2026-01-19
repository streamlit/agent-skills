---
name: developing-with-streamlit
description: Build production-grade Streamlit apps. Use when creating, editing, debugging, or deploying Streamlit applications. Routes to specialized sub-skills for performance, layouts, design, data display, and more.
---

# Developing with Streamlit

A collection of skills for building production-grade Streamlit apps. Each skill focuses on a specific aspect of Streamlit development.

## When to Activate

Activate these skills when:
- Creating new Streamlit apps from scratch
- Adding features to existing apps
- Debugging performance issues
- Improving app design and UX
- Setting up project structure and environments
- Connecting to data sources like Snowflake

## Skill Map

### Performance & Optimization

**Optimizing Performance**
Caching strategies with `@st.cache_data` and `@st.cache_resource`, when to use `st.fragment` for partial reruns, forms for batching inputs, and static vs dynamic widget patterns. Load `optimizing-streamlit-performance` for slow apps or expensive computations.

### UI & Layout

**Choosing Selection Widgets**
Decision framework for picking between `st.selectbox`, `st.radio`, `st.segmented_control`, `st.pills`, and `st.multiselect`. Covers single vs multi-select, few vs many options, and navigation vs filtering use cases. Load `choosing-streamlit-selection-widgets` when building input forms.

**Using Layouts**
Sidebar, columns, containers, tabs, expanders, popovers, and dialogs. Alignment, spacing, and sizing options. Load `using-streamlit-layouts` when structuring app UI.

**Improving Design**
Icons, badges, colored text, and visual polish. Material icons in buttons, callouts, and expanders. Load `improving-streamlit-design` when refining app appearance.

### Data Display

**Displaying Data**
Dataframes with column configuration, charts, and data visualization. Load `displaying-streamlit-data` when showing data to users.

**Building Dashboards**
KPI cards, metrics with deltas, dashboard layouts, and summary views. Load `building-streamlit-dashboards` for analytics and reporting apps.

### App Architecture

**Multi-page Apps**
Page structure with `pages/` directory, navigation, and shared state across pages. Load `building-streamlit-multipage-apps` when apps need multiple pages.

**Organizing Code**
When to split into modules, separating UI from business logic. Load `organizing-streamlit-code` when apps grow complex.

**Setting Up Environment**
Python environment setup, dependency management. Load `setting-up-streamlit-environment` when starting new projects.

### Specialized Features

**Building Chat UI**
Chat interfaces with `st.chat_message` and `st.chat_input`, streaming responses, message history. Load `building-streamlit-chat-ui` for chatbots and AI assistants.

**Customizing Theme**
Custom colors via `.streamlit/config.toml`, light/dark modes. Load `customizing-streamlit-theme` for brand customization.

**Using Custom Components**
Third-party components from the community. Load `using-streamlit-custom-components` when core Streamlit lacks needed features.

**Connecting to Snowflake**
`st.connection("snowflake")`, query caching, credential management. Load `connecting-streamlit-to-snowflake` for Snowflake data apps.

## Practical Guidance

Each skill can be used independently or in combination. For new apps, start with `setting-up-streamlit-environment` and `using-streamlit-layouts`. Add specialized skills as needed based on app requirements.

## References

Internal skills in this collection:
- [building-streamlit-chat-ui](skills/building-streamlit-chat-ui/SKILL.md)
- [building-streamlit-dashboards](skills/building-streamlit-dashboards/SKILL.md)
- [building-streamlit-multipage-apps](skills/building-streamlit-multipage-apps/SKILL.md)
- [choosing-streamlit-selection-widgets](skills/choosing-streamlit-selection-widgets/SKILL.md)
- [connecting-streamlit-to-snowflake](skills/connecting-streamlit-to-snowflake/SKILL.md)
- [customizing-streamlit-theme](skills/customizing-streamlit-theme/SKILL.md)
- [displaying-streamlit-data](skills/displaying-streamlit-data/SKILL.md)
- [improving-streamlit-design](skills/improving-streamlit-design/SKILL.md)
- [optimizing-streamlit-performance](skills/optimizing-streamlit-performance/SKILL.md)
- [organizing-streamlit-code](skills/organizing-streamlit-code/SKILL.md)
- [setting-up-streamlit-environment](skills/setting-up-streamlit-environment/SKILL.md)
- [using-streamlit-custom-components](skills/using-streamlit-custom-components/SKILL.md)
- [using-streamlit-layouts](skills/using-streamlit-layouts/SKILL.md)

External resources:
- [Streamlit Documentation](https://docs.streamlit.io/develop/api-reference)
