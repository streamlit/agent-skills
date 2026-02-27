---
name: developing-with-streamlit
description: "**[REQUIRED]** Use for ALL Streamlit tasks: creating, editing, debugging, beautifying, styling, theming, optimizing, or deploying Streamlit applications. Also required for building custom components (inline or packaged), using st.components.v2, or any HTML/JS/CSS component work. Triggers: streamlit, st., dashboard, app.py, beautify, style, CSS, color, background, theme, button, widget styling, custom component, st.components, packaged component, pyproject.toml, asset_dir, CCv2, HTML/JS component."
---

# Developing with Streamlit

This is a **routing skill** that directs you to specialized sub-skills for Streamlit development.

## When to Use

Invoke this skill when the user's request involves:
- Creating a new Streamlit app
- Editing or modifying an existing Streamlit app
- Debugging Streamlit issues (errors, session state bugs, performance problems)
- Beautifying or improving the visual design of a Streamlit app
- Optimizing Streamlit performance (caching, fragments, reruns)
- Deploying Streamlit apps (locally or to Snowflake)
- Styling widgets (button colors, backgrounds, CSS customization)
- Any question about Streamlit widgets, layouts, or components

**Trigger phrases:** "streamlit", "st.", "dashboard", "app.py", "beautify app", "make it look better", "style", "CSS", "color", "background", "theme", "button", "slow rerun", "session state", "performance", "faster", "cache", "deploy"

## Workflow

```
Step 1: Locate the Streamlit source code
    ↓
Step 2: Identify task type and load appropriate sub-skill(s)
    ↓
Step 3: Apply guidance from sub-skill to edit code
    ↓
Step 4: Check if app is running and offer to run it
```

### Step 1: Locate the Streamlit Source Code (if needed)

**Goal:** Identify the app file(s) to edit. **Skip this step if already clear from context.**

**When to skip:**
- User mentioned a specific file path (e.g., "edit `src/app.py`")
- User has file(s) already in conversation context
- Working directory has an obvious single entry point (`app.py`, `streamlit_app.py`)

**When to search:**
- User says "my streamlit app" without specifying which file
- Multiple Python files exist and it's unclear which is the entry point

**If searching is needed:**

1. **Quick scan** for Streamlit files:
   ```bash
   find . -name "*.py" -type f | xargs grep -l "import streamlit\|from streamlit" 2>/dev/null | head -10
   ```

2. **Apply entry point heuristics** (in priority order):
   - `streamlit_app.py` at root → **this is the entry point** (canonical name)
   - `app.py` at root → likely entry point
   - File using `st.navigation` → entry point for multi-page apps
   - Single `.py` file at root with streamlit import → entry point
   - Files in `pages/` or `app_pages/` subdirectory → **NOT entry points** (these are sub-pages)

3. **If entry point is obvious** → use it, no confirmation needed

   Example: Found `streamlit_app.py` and `pages/metrics.py` → use `streamlit_app.py`

4. **Only ask if genuinely ambiguous** (e.g., multiple root-level candidates, none named `streamlit_app.py`):
   ```
   Found multiple potential entry points:
   - dashboard.py
   - main.py

   Which is your main app?
   ```

**Output:** Path to the main Streamlit source file(s)

### Step 2: Identify Task Type and Route to Sub-Skill

**Goal:** Determine what the user needs and load the appropriate guidance.

Use this routing table to select sub-skill(s). **Always read the sub-skill file** before making changes:

| User Need | Sub-skill to Read |
|-----------|-------------------|
| **Performance issues, slow apps, caching** | `read skills/optimizing-streamlit-performance/SKILL.md` |
| **Building a dashboard with KPIs/metrics** | `read skills/building-streamlit-dashboards/SKILL.md` |
| **Improving visual design, icons, polish** | `read skills/improving-streamlit-design/SKILL.md` |
| **Choosing widgets (selectbox vs radio vs pills)** | `read skills/choosing-streamlit-selection-widgets/SKILL.md` |
| **Styling widgets (button colors, backgrounds, CSS)** | `read skills/creating-streamlit-themes/SKILL.md` |
| **Layouts (columns, tabs, sidebar, containers)** | `read skills/using-streamlit-layouts/SKILL.md` |
| **Displaying data (dataframes, charts)** | `read skills/displaying-streamlit-data/SKILL.md` |
| **Multi-page app architecture** | `read skills/building-streamlit-multipage-apps/SKILL.md` |
| **Session state and callbacks** | `read skills/using-streamlit-session-state/SKILL.md` |
| **Markdown, colored text, badges** | `read skills/using-streamlit-markdown/SKILL.md` |
| **Custom themes and colors** | `read skills/creating-streamlit-themes/SKILL.md` |
| **Comprehensive theme design and brand alignment** | `read skills/creating-streamlit-themes/SKILL.md` |
| **Chat interfaces and AI assistants** | `read skills/building-streamlit-chat-ui/SKILL.md` |
| **Connecting to Snowflake** | `read skills/connecting-streamlit-to-snowflake/SKILL.md` |
| **Building or packaging a custom component, triggering events back to Python from JS/HTML, custom HTML/JS with event handling (CCv2), OR any UI element that doesn't exist as a native Streamlit widget** (e.g., drag-and-drop, custom interactive visualization, canvas drawing) | `read skills/building-streamlit-custom-components-v2/SKILL.md` — **IMPORTANT: `st.components.v1` is deprecated. Never use v1 for new components; always use `st.components.v2.component()`.** |
| **Third-party components** | `read skills/using-streamlit-custom-components/SKILL.md` |
| **Code organization** | `read skills/organizing-streamlit-code/SKILL.md` |
| **Environment setup** | `read skills/setting-up-streamlit-environment/SKILL.md` |
| **CLI commands** | `read skills/using-streamlit-cli/SKILL.md` |

**Fallback — "this widget doesn't exist in Streamlit":**

If the user asks for a UI element or interaction that **has never been part of Streamlit's API** and cannot be built with any combination of native widgets (e.g., drag-and-drop, canvas drawing, custom interactive visualizations), **route to the CCv2 sub-skill** (`skills/building-streamlit-custom-components-v2/SKILL.md`). **Do not** route to CCv2 for features that exist in newer Streamlit versions (e.g., `st.connection`, `st.segmented_control`) — suggest upgrading instead.

**Common combinations:**

For **beautifying/improving an app**, read in order:
1. `skills/improving-streamlit-design/SKILL.md`
2. `skills/using-streamlit-layouts/SKILL.md`
3. `skills/choosing-streamlit-selection-widgets/SKILL.md`

For **building a dashboard**, read:
1. `skills/building-streamlit-dashboards/SKILL.md`
2. `skills/displaying-streamlit-data/SKILL.md`

**IMPORTANT - Use templates:**

When creating a **new dashboard app**, prefer starting from a template in `templates/apps/`:
- If a template closely matches the request, copy it and adapt:
  - `dashboard-metrics` / `dashboard-metrics-snowflake` — KPI cards with time-series charts
  - `dashboard-companies` — company/entity comparison
  - `dashboard-compute` / `dashboard-compute-snowflake` — resource/credit monitoring
  - `dashboard-feature-usage` — feature adoption tracking
  - `dashboard-seattle-weather` — public dataset exploration (local only)
  - `dashboard-stock-peers` / `dashboard-stock-peers-snowflake` — financial peer analysis
- If no template is a close match, start from scratch but borrow relevant patterns from the templates (e.g., caching with `@st.cache_data`, `filter_by_time_range()`, `st.set_page_config()`, chart utilities, layout structure)
- See `templates/apps/README.md` for template descriptions

When **editing an existing app**, use templates as reference for best practices:
- Check `templates/apps/` for caching patterns, layout structure, and Snowflake integration
- Apply consistent patterns from templates to improve the existing code

When applying a **custom theme**, use a template from `templates/themes/`:
- Copy a theme directory (snowflake, dracula, nord, stripe, solarized-light, spotify, github, minimal)
- Themes use Google Fonts for easy setup
- See `templates/themes/README.md` for theme previews

For **performance optimization**, read:
1. `skills/optimizing-streamlit-performance/SKILL.md`

### Step 3: Apply Guidance to Edit Code

**Goal:** Make changes to the Streamlit app following sub-skill best practices.

**Actions:**

1. Apply the patterns and recommendations from the loaded sub-skill(s)
2. Make edits to the source file(s) identified in Step 1
3. Preserve existing functionality while adding improvements

### Step 4: Check Running Apps and Offer to Run

**Goal:** Help the user see their changes by checking if their app is running.

**Actions:**

1. **Check** for running Streamlit apps on ports 850*:
   ```bash
   lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | grep -i python | awk '{print $2, $9}' | grep ':85' || echo "No Streamlit apps detected on ports 850*"
   ```

2. **Present** findings to user:

   **If app is running:**
   ```
   Found Streamlit app running:
   - PID: [pid] at http://localhost:[port]

   Your changes should be visible after a page refresh (Streamlit hot-reloads on file save).
   ```

   **If no app is running:**
   ```
   No Streamlit app detected on ports 850*.

   Would you like me to run the app? I can start it with:
     streamlit run [app_file.py]
   ```

3. **If user wants to run the app**, start it:
   ```bash
   streamlit run [path/to/app.py] --server.port 8501
   ```

## Stopping Points

- **Step 2**: If multiple sub-skills seem relevant, ask user which aspect to focus on first
- **Step 4**: Ask before starting the Streamlit app

## Skill map

| Skill | Covers |
|-------|--------|
| [building-streamlit-chat-ui](skills/building-streamlit-chat-ui/SKILL.md) | Chat interfaces, streaming responses, message history |
| [building-streamlit-dashboards](skills/building-streamlit-dashboards/SKILL.md) | KPI cards, metrics, dashboard layouts |
| [building-streamlit-multipage-apps](skills/building-streamlit-multipage-apps/SKILL.md) | Page structure, navigation, shared state |
| [building-streamlit-custom-components-v2](skills/building-streamlit-custom-components-v2/SKILL.md) | Streamlit Custom Components v2 (inline and template-based packaged), bidirectional state/trigger callbacks, bundling, theme CSS variables |
| [choosing-streamlit-selection-widgets](skills/choosing-streamlit-selection-widgets/SKILL.md) | Selectbox vs radio vs segmented control vs pills vs multiselect |
| [connecting-streamlit-to-snowflake](skills/connecting-streamlit-to-snowflake/SKILL.md) | st.connection, query caching, credentials |
| [creating-streamlit-themes](skills/creating-streamlit-themes/SKILL.md) | Theme configuration, colors, fonts, light/dark modes, professional brand alignment, CSS avoidance |
| [displaying-streamlit-data](skills/displaying-streamlit-data/SKILL.md) | Dataframes, column config, charts |
| [improving-streamlit-design](skills/improving-streamlit-design/SKILL.md) | Icons, badges, colored text, visual polish |
| [optimizing-streamlit-performance](skills/optimizing-streamlit-performance/SKILL.md) | Caching, fragments, forms, static vs dynamic widgets |
| [organizing-streamlit-code](skills/organizing-streamlit-code/SKILL.md) | When to split into modules, separating UI from logic |
| [setting-up-streamlit-environment](skills/setting-up-streamlit-environment/SKILL.md) | Python environment, dependency management |
| [using-streamlit-custom-components](skills/using-streamlit-custom-components/SKILL.md) | Third-party components from the community |
| [using-streamlit-cli](skills/using-streamlit-cli/SKILL.md) | CLI commands, running apps |
| [using-streamlit-layouts](skills/using-streamlit-layouts/SKILL.md) | Sidebar, columns, containers, tabs, expanders, dialogs, alignment, spacing |
| [using-streamlit-markdown](skills/using-streamlit-markdown/SKILL.md) | Colored text, badges, icons, LaTeX, and all markdown features |
| [using-streamlit-session-state](skills/using-streamlit-session-state/SKILL.md) | Session state, widget keys, callbacks, state persistence |

## Resources

- [Streamlit API Reference](https://docs.streamlit.io/develop/api-reference)
- [Streamlit Gallery](https://streamlit.io/gallery)
