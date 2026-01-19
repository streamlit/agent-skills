---
name: improving-streamlit-design
description: Improving visual design in Streamlit apps. Use when polishing apps with icons, badges, spacing, or text styling. Covers Material icons, badge syntax, divider alternatives, and text casing conventions.
license: Apache-2.0
---

# Streamlit Visual Design

Small touches that make apps feel polished.

**Related skills:** Visual design works hand-in-hand with other skills:
- `choosing-streamlit-widgets` → Choosing the right widget (segmented control, pills, toggle)
- `displaying-streamlit-data` → Column config, sparklines, bordered metrics
- `structuring-streamlit-layout` → Containers, alignment, dashboard cards

## Page Config

**Must be the first Streamlit command in your script.** Set browser tab title, icon, and layout:

```python
st.set_page_config(
    page_title="My Dashboard",
    page_icon=":material/analytics:",
    layout="wide",  # Use "wide" for dashboards with lots of data
)
```

**Layout options:**
- `layout="centered"` (default) → Best for most apps, content is constrained to a readable width
- `layout="wide"` → Full-width, good for dashboards and data-heavy apps

## App Logo

Add a logo to the sidebar/header:

```python
st.logo("logo.png")
```

## Icons Over Emojis

Use Material icons for a cleaner, more professional look.

```python
# GOOD: Material icons
st.markdown(":material/settings:")
st.markdown(":material/calendar_today:")
st.markdown(":material/dashboard:")
st.markdown(":material/person:")

# SPARINGLY: Emojis for special occasions
st.markdown("Celebration! 🎉")
```

Format: `:material/icon_name:`

Find icons: https://fonts.google.com/icons

**Popular icons by category:**

| Category | Icons |
|----------|-------|
| Navigation | `home`, `arrow_back`, `menu`, `settings`, `search` |
| Actions | `send`, `play_arrow`, `refresh`, `download`, `upload`, `save`, `delete`, `edit` |
| Status | `check_circle`, `error`, `warning`, `info`, `pending` |
| Data | `table_chart`, `bar_chart`, `analytics`, `query_stats`, `database` |
| Content | `chat`, `code`, `description`, `article`, `folder` |
| UI | `visibility`, `build`, `tune`, `filter_list` |

## Badges for Status

For standalone badges:
```python
st.badge("Active", icon=":material/check:", color="green")
st.badge("Pending", icon=":material/schedule:", color="orange")
st.badge("Deprecated", color="red")
```

For inline badges in text:
```python
st.markdown("""
:green-badge[Active] :orange-badge[Pending] :red-badge[Deprecated] :blue-badge[New]
""")
```

Avoid the old verbose syntax:
```python
# OLD (still works but cluttered)
st.markdown(":orange-background[:orange[Pending]]")
```

## Spacing: Remove Dividers

Dividers (`st.divider()` or `---`) look heavy. Just remove them—Streamlit's default spacing is usually enough.

```python
# BAD
st.header("Section 1")
st.write("Content")
st.divider()  # Too heavy
st.header("Section 2")

# GOOD
st.header("Section 1")
st.write("Content")
st.header("Section 2")
```

If you genuinely need spacing:
```python
st.space("small")   # Small gap
st.space("medium")  # Medium gap
st.space("large")   # Large gap
```

**Don't** systematically replace dividers with `st.space()`—it can look weird too.

## Sentence Casing

Use sentence casing for titles and labels. Title Case Feels Shouty.

```python
# GOOD
st.title("Upload your data")
st.selectbox("Select a region", options)
st.button("Save changes")

# BAD
st.title("Upload Your Data")
st.selectbox("Select A Region", options)
```

## Caption Over Info

`st.info()` is too heavy for simple informational text.

```python
# GOOD: Lighter
st.caption("Data last updated 5 minutes ago")

# BAD: Too heavy
st.info("Data last updated 5 minutes ago")
```

**When to use what:**
- `st.caption` → Simple info, metadata, timestamps
- `st.info` → Important instructions
- `st.warning` → Caution, potential issues
- `st.error` → Errors that block progress
- `st.success` → Confirmation of action
- `st.toast` → Lightweight confirmation that auto-dismisses

## Text Alignment

```python
st.title("Centered title", text_alignment="center")
st.write("Right aligned", text_alignment="right")
st.caption("Justified text", text_alignment="justify")
```

Options: `"left"` (default), `"center"`, `"right"`, `"justify"`

## References

- [st.set_page_config](https://docs.streamlit.io/develop/api-reference/configuration/st.set_page_config)
- [st.logo](https://docs.streamlit.io/develop/api-reference/media/st.logo)
- [st.badge](https://docs.streamlit.io/develop/api-reference/text/st.badge)
- [st.space](https://docs.streamlit.io/develop/api-reference/layout/st.space)
- [st.markdown](https://docs.streamlit.io/develop/api-reference/text/st.markdown)
- [st.toast](https://docs.streamlit.io/develop/api-reference/status/st.toast)
