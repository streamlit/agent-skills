---
name: streamlit-visual-design
description: Streamlit visual design patterns. Use when styling apps with icons, badges, spacing, or text. Covers Material icons, badge syntax, divider alternatives, and text casing conventions.
license: Apache-2.0
---

# Streamlit Visual Design

Small touches that make apps feel polished.

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

## Badges for Status

```python
st.markdown(":green-badge[Active]")
st.markdown(":orange-badge[Pending]")
st.markdown(":red-badge[Deprecated]")
st.markdown(":blue-badge[New]")
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

## Text Alignment

```python
st.title("Centered title", text_alignment="center")
st.write("Right aligned", text_alignment="right")
st.caption("Justified text", text_alignment="justify")
```

Options: `"left"` (default), `"center"`, `"right"`, `"justify"`
