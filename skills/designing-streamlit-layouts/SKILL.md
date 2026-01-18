---
name: designing-streamlit-layouts
description: Designs Streamlit app layouts using columns, sidebar, tabs, containers, and dialogs. Use when organizing UI elements, creating dashboards, building navigation, or structuring app content.
---

# Designing Streamlit Layouts

Organize your app's UI with layout containers for professional, scannable interfaces.

## Core Layout Components

### Columns

```python
# Equal columns
col1, col2, col3 = st.columns(3)

# Custom widths (ratios)
col1, col2 = st.columns([2, 1])  # 2:1 ratio

# With gap control
col1, col2 = st.columns(2, gap="large")  # small, medium, large

# Usage
with col1:
    st.metric("Revenue", "$1M")
with col2:
    st.metric("Users", "5K")

# Or without context manager
col1.metric("Revenue", "$1M")
col2.metric("Users", "5K")
```

**Limitation:** Nested columns are restricted. Design layouts without deep nesting.

### Sidebar

```python
# Method 1: Context manager
with st.sidebar:
    st.title("Settings")
    option = st.selectbox("Choose", ["A", "B"])

# Method 2: Direct access
st.sidebar.title("Settings")
option = st.sidebar.selectbox("Choose", ["A", "B"])
```

**Best practice:** Place filters, settings, and navigation in sidebar to keep main content clean.

### Tabs

```python
tab1, tab2, tab3 = st.tabs(["Chart", "Data", "Settings"])

with tab1:
    st.line_chart(data)
with tab2:
    st.dataframe(df)
with tab3:
    st.slider("Threshold", 0, 100)
```

### Expander

```python
with st.expander("See details"):
    st.write("Hidden content here")
    st.code("print('hello')")

# Expanded by default
with st.expander("Configuration", expanded=True):
    st.text_input("API Key")
```

### Container

Control element ordering:

```python
# Placeholder for later content
header = st.container()
main = st.container()

# Write to main first
with main:
    result = expensive_computation()

# Then update header
with header:
    st.write(f"Computed: {result}")
```

### Flex Containers

Use `horizontal=True` for flexible row layouts:

```python
# Basic horizontal layout
with st.container(horizontal=True):
    st.button("Action 1")
    st.button("Action 2")
    st.button("Action 3")

# Right-aligned buttons
with st.container(horizontal=True, horizontal_alignment="right"):
    st.button("Cancel")
    st.button("Save", type="primary")

# Centered with custom gap
with st.container(horizontal=True, horizontal_alignment="center", gap="medium"):
    st.metric("Revenue", "$1M")
    st.metric("Users", "5K")
    st.metric("Orders", "1.2K")

# Distributed (evenly spaced)
with st.container(horizontal=True, horizontal_alignment="distribute"):
    for i in range(4):
        st.button(f"Option {i+1}")
```

**Alignment options:**
- `horizontal_alignment`: `"left"`, `"center"`, `"right"`, `"distribute"`
- `vertical_alignment`: `"top"`, `"center"`, `"bottom"`, `"distribute"`

**Gap sizes:** `"xxsmall"`, `"xsmall"`, `"small"` (default), `"medium"`, `"large"`, `"xlarge"`, `"xxlarge"`, `None`

**When to use flex vs columns:**
- Flex (`horizontal=True`): Dynamic number of items, wrapping, alignment control
- Columns: Fixed grid layout, precise width ratios

### Empty

Single-element placeholder that can be updated:

```python
placeholder = st.empty()

# Update the placeholder
placeholder.text("Loading...")
result = load_data()
placeholder.dataframe(result)

# Clear it
placeholder.empty()
```

For multiple elements in a placeholder:

```python
placeholder = st.empty()

with placeholder.container():
    st.write("Line 1")
    st.write("Line 2")
```

## Dialogs

Modal overlays for focused interactions:

```python
@st.dialog("Edit User")
def edit_user(user_id):
    name = st.text_input("Name", value=get_name(user_id))
    if st.button("Save"):
        save_user(user_id, name)
        st.rerun()  # Close dialog and refresh

# Trigger dialog
if st.button("Edit"):
    edit_user(user_id)
```

**Key points:**
- Dialogs rerun independently from the main script
- Call `st.rerun()` to close dialog and refresh main app
- Use `dismissible=False` for forced actions and `on_dismiss` for cleanup
- `st.sidebar` is not supported inside dialogs
- Use for forms, confirmations, detail views

## Status Elements

### Spinner (Blocking)

```python
with st.spinner("Loading data..."):
    data = load_data()
st.success("Done!")
```

### Progress Bar

```python
progress = st.progress(0, text="Processing...")
for i in range(100):
    progress.progress(i + 1, text=f"Processing {i+1}%")
```

### Status Container (Multi-step)

```python
with st.status("Downloading data...", expanded=True) as status:
    st.write("Fetching from API...")
    fetch_data()
    st.write("Processing...")
    process_data()
    status.update(label="Complete!", state="complete", expanded=False)
```

### Toast (Non-blocking)

```python
st.toast("File saved!", icon="✅")
```

### Alerts

```python
st.success("Operation completed")
st.info("FYI: New features available")
st.warning("Check your input")
st.error("Something went wrong")
st.exception(e)  # Display exception with traceback
```

## Common Layout Patterns

### Dashboard Header

```python
st.title("Dashboard")

col1, col2, col3, col4 = st.columns(4)
col1.metric("Revenue", "$1.2M", "+12%")
col2.metric("Users", "5,432", "+8%")
col3.metric("Orders", "1,234", "-2%")
col4.metric("Conversion", "2.4%", "+0.3%")

st.divider()
```

### Sidebar Filters

```python
with st.sidebar:
    st.header("Filters")
    date_range = st.date_input("Date range", [])
    category = st.multiselect("Category", categories)
    st.divider()
    if st.button("Reset filters"):
        st.rerun()
```

### Two-Panel Layout

```python
left, right = st.columns([1, 2])

with left:
    st.subheader("Selection")
    selected = st.selectbox("Item", items)

with right:
    st.subheader("Details")
    st.write(get_details(selected))
```

## Popover

Hover/click to reveal content:

```python
with st.popover("Settings ⚙️"):
    st.checkbox("Dark mode")
    st.slider("Font size", 10, 24)
```

## Reference

- [Layout docs](https://docs.streamlit.io/develop/api-reference/layout)
- [Status elements](https://docs.streamlit.io/develop/api-reference/status)
- [st.dialog API](https://docs.streamlit.io/develop/api-reference/execution-flow/st.dialog)
