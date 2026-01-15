---
name: streamlit-best-practices
description: Streamlit app development best practices from daily production use. Use when writing, reviewing, or refactoring Streamlit apps. Triggers on tasks involving Streamlit widgets, layouts, charts, multi-page apps, theming, testing, caching, fragments, error handling, or performance optimization.
license: Apache-2.0
---

# Streamlit Best Practices

Practical guidance for building production-grade Streamlit apps. Rules are prioritized by impact.

## 1. Performance (CRITICAL)

### Caching

Use `@st.cache_data` for data loading, `@st.cache_resource` for connections.

```python
@st.cache_data
def load_data(path):
    return pd.read_csv(path)

@st.cache_resource
def get_connection():
    return snowflake.connector.connect(...)

@st.cache_data(ttl=300)  # 5 min TTL for fresh data
def get_metrics():
    return api.fetch()
```

### Fragments

Use `@st.fragment` to isolate reruns for self-contained UI pieces.

```python
@st.fragment
def live_metrics():
    st.metric("Users", get_count())
    st.button("Refresh")

live_metrics()  # Only this reruns on button click
```

### Static vs Dynamic Widgets

**Static widgets** (`st.tabs`, `st.expander`, `st.popover`) load ALL content even when hidden. For heavy content, use **dynamic widgets** instead.

```python
# BAD: Heavy content loads even when tab not visible
tab1, tab2 = st.tabs(["Light", "Heavy"])
with tab2:
    expensive_chart()  # Always computed!

# GOOD: Content only loads when selected
view = st.segmented_control("View", ["Light", "Heavy"])
if view == "Heavy":
    expensive_chart()  # Only computed when selected
```

Dynamic alternatives: `st.segmented_control`, `st.toggle`, `st.dialog`

## 2. Widget Selection (HIGH)

| Options | Single Select | Multi Select |
|---------|--------------|--------------|
| 2-4 | `st.segmented_control` | `st.pills` |
| 5+ | `st.selectbox` | `st.multiselect` |

```python
# BAD
status = st.radio("Status", ["Draft", "Published"], horizontal=True)

# GOOD
status = st.segmented_control("Status", ["Draft", "Published"])
```

### Dialogs for Settings

```python
@st.dialog("Settings")
def show_settings():
    st.text_input("API key")

if st.button(":material/settings:"):
    show_settings()
```

## 3. Layout (HIGH)

### Sidebar: Navigation + Global Filters Only

```python
with st.sidebar:
    st.page_link("pages/home.py", label="Home")
    date_range = st.date_input("Date range")
```

### Columns: Max 4, Set Alignment

```python
cols = st.columns(4, vertical_alignment="center")
```

### Horizontal Containers for Button Groups

```python
with st.container(horizontal=True, horizontal_alignment="center"):
    st.button("Cancel")
    st.button("Save")
```

### Bordered Containers for Dashboard Cards

```python
with st.container(border=True):
    st.metric("Revenue", "$1.2M", chart_data=data, chart_type="line")
```

## 4. Visual Design (MEDIUM)

### Icons Over Emojis

```python
st.markdown(":material/settings:")  # Preferred
st.markdown("🎉")  # Special occasions only
```

### Badges for Status

```python
st.markdown(":green-badge[Active]")
st.markdown(":red-badge[Deprecated]")
```

### Sentence Casing

```python
st.title("Upload your data")  # GOOD
st.title("Upload Your Data")  # BAD
```

### Caption Over Info

```python
st.caption("Updated 5 min ago")  # Lighter
st.info("Updated 5 min ago")     # Too heavy
```

### Remove Dividers

Just remove them. Streamlit's default spacing is usually enough.

## 5. Charts & Data (MEDIUM)

### Native Charts First

```python
st.line_chart(df, x="date", y="revenue")
```

### Human-Readable Labels

```python
st.line_chart(df, x="date", y="revenue")  # GOOD
st.line_chart(df, x="dt", y="rev")        # BAD
```

### Configure Dataframes

```python
st.dataframe(df, column_config={
    "revenue": st.column_config.NumberColumn("Revenue", format="$%.2f"),
    "url": st.column_config.LinkColumn("Website")
}, hide_index=True)
```

### Sparklines in Metrics

```python
st.metric("Users", "762k", "-7%", chart_data=values, chart_type="line")
```

## 6. Multi-Page Apps (MEDIUM)

### Structure

```
streamlit_app.py
app_pages/
    home.py
    analytics.py
```

### Navigation

```python
# streamlit_app.py
st.session_state.api = init_client()  # Global state

page = st.navigation([
    st.Page("app_pages/home.py", title="Home", icon=":material/home:"),
], position="top")  # "top" for 3-7 pages
page.run()
```

## 7. Error Handling (MEDIUM)

### Global Exception Handler

```python
from streamlit_extras.exception_handler import set_global_exception_handler

def handler(e):
    st.exception(e)
    log_exception(e)
    notify_slack(e)

set_global_exception_handler(handler)
```

Install: `pip install streamlit-extras`

## 8. Theming (LOW)

### Use config.toml

```toml
# .streamlit/config.toml
[theme]
primaryColor = "#FF4B4B"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
```

Avoid custom CSS—it breaks with updates.

## 9. Testing (LOW)

### AppTest

```python
from streamlit.testing.v1 import AppTest

def test_loads():
    at = AppTest.from_file("streamlit_app.py")
    at.run()
    assert not at.exception
```

Run: `pytest tests/`

## 10. Python Environment (LOW)

### Use uv

```bash
uv run streamlit run streamlit_app.py
```

uv handles dependencies from `pyproject.toml` automatically.

## Quick Wins Checklist

- [ ] Replace `st.radio(..., horizontal=True)` → `st.segmented_control`
- [ ] Add `@st.cache_data` to data loading functions
- [ ] Add `@st.cache_resource` to connections
- [ ] Use `@st.fragment` for isolated UI
- [ ] Replace static widgets with dynamic ones for heavy content
- [ ] Use Material icons instead of emojis
- [ ] Use sentence casing
- [ ] Configure dataframe columns
- [ ] Set up global exception handler
