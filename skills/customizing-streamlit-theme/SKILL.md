---
name: customizing-streamlit-theme
description: Customizing Streamlit app themes. Use when changing app colors or appearance. Covers config.toml theming, avoiding CSS, and targeted styling when necessary.
license: Apache-2.0
---

# Streamlit Theming

Custom colors and styling. Stick to config.toml—avoid CSS.

## Basic Theme

Configure your app's colors in `.streamlit/config.toml`:

```toml
[theme]
base = "light"  # or "dark"
primaryColor = "#FF4B4B"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
textColor = "#262730"
font = "sans serif"
```

**Core options:**
- `base` → Start from `"light"` or `"dark"` theme
- `primaryColor` → Interactive elements (buttons, links, sliders)
- `backgroundColor` → Main content area
- `secondaryBackgroundColor` → Sidebar and widget backgrounds
- `textColor` → All text
- `font` → `"sans serif"`, `"serif"`, or `"monospace"`

## Separate Light and Dark Themes

Define both themes and let users choose:

```toml
[theme.light]
primaryColor = "#FF4B4B"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
textColor = "#262730"

[theme.dark]
primaryColor = "#FF6B6B"
backgroundColor = "#0E1117"
secondaryBackgroundColor = "#262730"
textColor = "#FAFAFA"
```

When both are defined, users can switch between them in the settings menu.

## Sidebar Styling

Style the sidebar separately:

```toml
[theme]
base = "light"
primaryColor = "slateBlue"
backgroundColor = "mintCream"

[theme.sidebar]
backgroundColor = "aliceBlue"
secondaryBackgroundColor = "skyBlue"
```

## Detect Current Theme

```python
if st.context.theme.base == "dark":
    # Dark mode specific logic
    chart_color = "#FF6B6B"
else:
    chart_color = "#FF4B4B"
```

Use `st.context.theme.base` to detect if the user is in light or dark mode.

## Avoid Custom CSS/HTML

Custom CSS makes apps hard to maintain and breaks with Streamlit updates.

```python
# BAD: Will break with updates
st.markdown("""
<style>
.stButton button {
    background-color: #FF4B4B;
    border-radius: 20px;
}
</style>
""", unsafe_allow_html=True)

# GOOD: Use config.toml
# [theme]
# primaryColor = "#FF4B4B"
```

## When You Must Use CSS

If you absolutely need custom styling, use the `key=` parameter to create targetable CSS classes.

```python
st.text_input("Username", key="username")
st.button("Submit", key="submit")
```

Generated CSS classes:
```css
.st-key-username { ... }
.st-key-submit { ... }
```

Apply styles:
```python
st.html("""
<style>
.st-key-submit button {
    width: 100%;
}
</style>
""")
```

**Only use this as a last resort.**

## References

- [Theming](https://docs.streamlit.io/develop/concepts/configuration/theming)
- [st.context](https://docs.streamlit.io/develop/api-reference/caching-and-state/st.context)
