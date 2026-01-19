---
name: structuring-streamlit-layout
description: Structuring Streamlit app layouts. Use when placing content in sidebars, columns, containers, or dialogs. Covers sidebar usage, column limits, horizontal containers, dialogs, and bordered cards.
license: Apache-2.0
---

# Streamlit Layout

How you structure your app affects usability more than you think.

## Sidebar: Navigation + Global Filters Only

The sidebar should only contain navigation and app-level filters. Main content goes in the main area.

```python
# GOOD
with st.sidebar:
    date_range = st.date_input("Date range")
    region = st.selectbox("Region", ["All", "US", "EU", "APAC"])
    st.caption("App v1.2.3")
```

```python
# BAD: Too much content in sidebar
with st.sidebar:
    st.title("Dashboard")
    st.dataframe(df)  # Don't put main content here
    st.bar_chart(data)
```

**What goes in sidebar:**
- Global filters (date range, user selection, region)
- App info (version, feedback link)

**What stays out:**
- Main content, charts, tables, results

## Columns: Max 4, Set Alignment

Don't use too many columns—they get cramped.

```python
# GOOD
col1, col2 = st.columns(2)

# OK with alignment
cols = st.columns(4, vertical_alignment="center")

# BAD: Too many, cramped
col1, col2, col3, col4, col5, col6 = st.columns(6)
```

## Horizontal Containers for Button Groups

Use `st.container(horizontal=True)` instead of columns for button groups.

```python
with st.container(horizontal=True, horizontal_alignment="center"):
    st.button("Cancel")
    st.button("Save")
    st.button("Submit")
```

Alignment options: `"left"` (default), `"center"`, `"right"`, `"distribute"`

## Centering Elements

```python
with st.container(horizontal_alignment="center"):
    st.image("logo.png", width=200)
    st.title("Welcome")
```

## Bordered Containers for Dashboard Cards

Use `border=True` directly in metrics for clear visual separation.

```python
cols = st.columns(4)
with cols[0]:
    st.metric(
        "Revenue",
        "$1.2M",
        "-7%",
        border=True,
        chart_data=data,
        chart_type="line",
    )

with cols[1]:
    st.metric(
        "Users",
        "762k",
        "+12%",
        border=True,
        chart_data=data,
        chart_type="line",
    )
```

**Why bordered containers work:**
- Clear visual separation
- Makes dashboards feel organized
- Helps users scan information
- Great for KPI cards

## Dialogs for Settings and Forms

Use `@st.dialog` for settings, configuration, or any UI that doesn't need to be always visible.

```python
@st.dialog("Settings")
def show_settings():
    st.text_input("API key")
    st.selectbox("Theme", ["Light", "Dark"])
    if st.button("Save"):
        st.session_state.saved = True
        st.rerun()

if st.button("Settings", icon=":material/settings:"):
    show_settings()
```

**When to use dialogs:**
- Settings panels
- Confirmation prompts
- Forms that don't need to be always visible
- Any UI that would clutter the sidebar

Dialogs reduce sidebar clutter and keep the main UI focused.

## Tight Layouts with gap=None

Remove default spacing between elements in containers:

```python
with st.container(gap=None, border=True):
    for item in items:
        with st.container(horizontal=True):
            st.checkbox(item.text)
            st.button(":material/delete:", type="tertiary")
```

Useful for list-like UIs where default spacing feels too loose.

## Stretch to Fill Available Space

Use `height="stretch"` to make containers fill available vertical space:

```python
cols = st.columns(2)
with cols[0].container(border=True, height="stretch"):
    st.subheader("Chart")
    st.altair_chart(chart)

with cols[1].container(border=True, height="stretch"):
    st.subheader("Data")
    st.dataframe(df)
```

Both columns will have equal height regardless of content.

## References

- [st.container](https://docs.streamlit.io/develop/api-reference/layout/st.container)
- [st.columns](https://docs.streamlit.io/develop/api-reference/layout/st.columns)
- [st.sidebar](https://docs.streamlit.io/develop/api-reference/layout/st.sidebar)
- [st.dialog](https://docs.streamlit.io/develop/api-reference/execution-flow/st.dialog)
