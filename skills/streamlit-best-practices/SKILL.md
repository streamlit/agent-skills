---
name: streamlit-best-practices
description: Opinionated best practices and coding conventions for Streamlit apps. Use when starting a new Streamlit project, reviewing code quality, or seeking guidance on recommended patterns and anti-patterns.
---

# Streamlit Best Practices

Opinionated guidelines for writing clean, performant, and maintainable Streamlit apps.

## Styling

**Don't use custom CSS.** Rely on native features and theming instead.

```python
# BAD: Custom CSS
st.markdown("<style>div { color: red; }</style>", unsafe_allow_html=True)

# GOOD: Use theming in .streamlit/config.toml
# [theme]
# primaryColor = "#FF4B4B"
# backgroundColor = "#FFFFFF"
```

**Prefer Material Icons over emojis** for a professional look:

```python
# BAD: Emojis
st.page_link("home.py", label="Home", icon="🏠")

# GOOD: Material Icons
st.page_link("home.py", label="Home", icon=":material/home:")
```

## Layout

**Prefer `st.container(border=True)` for visual grouping:**

```python
# GOOD: Clean visual grouping
with st.container(border=True):
    st.metric("Revenue", "$1M")
    st.caption("Last 30 days")
```

**Use `width` parameter instead of deprecated `use_container_width`:**

```python
# BAD: Deprecated
st.dataframe(df, use_container_width=True)

# GOOD: New parameter
st.dataframe(df, width="stretch")  # Was use_container_width=True
st.dataframe(df, width="content")  # Was use_container_width=False
```

**Prefer flex containers over columns** for simple row layouts:

```python
# BAD: Columns for simple button row
col1, col2, col3 = st.columns(3)
col1.button("A")
col2.button("B")
col3.button("C")

# GOOD: Flex container with alignment
with st.container(horizontal=True, horizontal_alignment="right"):
    st.button("Cancel")
    st.button("Save", type="primary")

# GOOD: Distributed metrics
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.metric("Revenue", "$1M")
    st.metric("Users", "5K")
    st.metric("Orders", "1.2K")
```

**When to use columns vs flex:**
- Columns: Fixed grid layouts with precise width ratios
- Flex: Dynamic items, alignment control, wrapping behavior


## Navigation

**Prefer `st.navigation` over `pages/` folder** for multipage apps:

```python
# GOOD: Explicit control, conditional pages, custom icons
pages = [
    st.Page("app_pages/home.py", title="Home", icon=":material/home:"),
    st.Page("app_pages/dashboard.py", title="Dashboard", icon=":material/dashboard:"),
]
nav = st.navigation(pages)
nav.run()
```

## Caching

**Always cache expensive operations with appropriate limits:**

```python
# BAD: No TTL, unbounded growth
@st.cache_data
def load_data():
    return fetch_from_api()

# GOOD: TTL and max_entries prevent issues
@st.cache_data(ttl=3600, max_entries=100)
def load_data():
    return fetch_from_api()
```

**Cache at the right granularity:**

```python
# BAD: Caching too much
@st.cache_data
def get_and_filter_data(filter_value):  # New cache entry per filter!
    data = load_all_data()
    return data[data["col"] == filter_value]

# GOOD: Cache the expensive part, filter separately
@st.cache_data(ttl=3600)
def load_all_data():
    return fetch_from_database()

data = load_all_data()
filtered = data[data["col"] == filter_value]
```

## Charts

**Prefer Vega-based charts** over pyplot (matplotlib) and plotly:

```python
# GOOD: Native, fast, consistent styling
st.line_chart(df, x="date", y="value")
st.bar_chart(df, x="category", y="count")
st.scatter_chart(df, x="x", y="y", color="category")
st.area_chart(df, x="date", y="value")

# For complex charts, use Altair
import altair as alt
chart = alt.Chart(df).mark_line().encode(x="date:T", y="value:Q")
st.altair_chart(chart, width="stretch")
```

**Why avoid pyplot/plotly:**
- Inconsistent theming
- Slower rendering
- More dependencies

## Session State

**Initialize all session state in one place:**

```python
# GOOD: Clear initialization at top of app
def init_state():
st.session_state.setdefault("user", None)
st.session_state.setdefault("page", "home")
st.session_state.setdefault("filters", {})
```

**Avoid module-level mutable state:**

```python
# BAD: In imported modules, module-level state is shared across all users!
# utils.py
cache = {}  # This persists across reruns and users

# GOOD: Use session state for per-user data
st.session_state.setdefault("cache", {})
```

## Widget Best Practices

**Consider setting a `key` for widgets if:**

1. **You have identical widgets** - Avoids `DuplicateWidgetID` errors when multiple widgets share the same label
2. **Parameters change dynamically** - With a key, changing label, placeholder, help text, or default value won't reset the widget
3. **You need programmatic access** - Read/write widget values via `st.session_state["key"]`

```python
# Without key: changing the label resets the widget value
st.text_input(f"Search {category}")  # Resets when category changes

# With key: widget keeps its value even if label changes
st.text_input(f"Search {category}", key="search_query")

# Access the value programmatically
if st.session_state.get("search_query"):
    results = search(st.session_state.search_query)
```

**Use callbacks for immediate state changes:**

```python
# GOOD: State updated before rerun
def on_submit():
    st.session_state.submitted = True
    st.session_state.result = process(st.session_state.input_value)

st.text_input("Input", key="input_value")
st.button("Submit", on_click=on_submit)
```

## Page Configuration

**It is recommended to set page config at the top of each page:**

```python
import streamlit as st

st.set_page_config(
    page_title="My App",
    page_icon=":material/dashboard:",
    layout="wide",
)

# All other imports and code below
```

## Error Handling

Use `print`/`logger` for developer logs (server-side, not visible to users). Use Streamlit's status elements (`st.error`, `st.warning`, `st.success`, `st.info`) for user-facing feedback.

```python
# BAD: User won't see this - only appears in server logs
print("Processing complete!")
logger.error(f"Validation failed: {e}")

# GOOD: User-friendly feedback with status elements
try:
    result = process_data(data)
    st.success("Processing complete!")
except ValidationError as e:
    st.error(f"Invalid input: {e}")
except Exception as e:
    logger.exception("Unexpected error")  # For developer debugging
    st.error("An error occurred. Please try again.")  # For user
```

## File Organization

**Keep pages focused, extract shared logic:**

```
my_app/
├── streamlit_app.py              # `st.navigation` only
├── app_pages/              # Page files (UI logic)
│   ├── home.py
│   └── dashboard.py
├── utils/              # Shared business logic
│   ├── data.py
│   └── auth.py
└── .streamlit/
    ├── config.toml
    └── secrets.toml
```

## Performance Tips

1. **Profile before optimizing** - Use `st.spinner` to identify slow operations
2. **Lazy load heavy components** - Use `st.fragment` for independent sections
3. **Truncate large data** - Don't load 1M rows into a dataframe

## Reference

- [Theming docs](https://docs.streamlit.io/develop/concepts/configuration/theming)
- [Material Icons](https://fonts.google.com/icons)
- [st.navigation](https://docs.streamlit.io/develop/api-reference/navigation/st.navigation)
