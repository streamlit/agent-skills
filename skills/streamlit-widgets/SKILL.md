---
name: streamlit-widgets
description: Streamlit widget selection patterns. Use when choosing between radio buttons, selectbox, segmented control, pills, or other input widgets. Helps pick the right widget for the number of options and selection type.
license: Apache-2.0
---

# Streamlit Widget Selection

The right widget for the job. Streamlit has evolved—many old patterns are now anti-patterns.

## Selection Widgets by Option Count

| Options | Single Select | Multi Select |
|---------|--------------|--------------|
| 2-4 | `st.segmented_control` | `st.pills` |
| 5+ | `st.selectbox` | `st.multiselect` |

## Segmented Control (2-4 options, single select)

```python
# BAD
status = st.radio("Status", ["Draft", "Published"], horizontal=True)

# GOOD
status = st.segmented_control("Status", ["Draft", "Published"])
```

For vertical layouts, `st.radio(..., horizontal=False)` is still a great choice.

Cleaner, more modern look than horizontal radio buttons.

## Pills (2-5 options, multi-select)

```python
# Multi-select with few options
selected = st.pills(
    "Tags",
    ["Python", "SQL", "dbt", "Streamlit"],
    selection_mode="multi"
)
```

Can also be used to mimic an "example" widget, especially with `label_visibility="collapsed"`:
```python
st.pills("Examples", ["Show me sales data", "Top customers"], label_visibility="collapsed")
```

More visual and easier to use than `st.multiselect` for small option sets.

## Selectbox (5+ options, single select)

```python
country = st.selectbox(
    "Select a country",
    ["USA", "UK", "Canada", "Germany", "France", ...]
)
```

Dropdowns scale better than radio/pills for long lists.

## Multiselect (5+ options, multi-select)

```python
countries = st.multiselect(
    "Select countries",
    ["USA", "UK", "Canada", "Germany", "France", ...]
)
```

## Dialogs for Settings

Use `@st.dialog` for settings, configuration, or any UI that doesn't need to be always visible.

```python
@st.dialog("Settings")
def show_settings():
    st.text_input("API key")
    st.selectbox("Theme", ["Light", "Dark"])
    if st.button("Save"):
        st.session_state.saved = True
        st.rerun()

if st.button(":material/settings: Settings"):
    show_settings()
```

Dialogs reduce sidebar clutter and keep the main UI focused.

## Toggle vs Checkbox

Prefer `st.toggle` for on/off settings—more modern look.

```python
# GOOD
dark_mode = st.toggle("Dark mode")

# FINE (but looks older)
dark_mode = st.checkbox("Dark mode")
```
