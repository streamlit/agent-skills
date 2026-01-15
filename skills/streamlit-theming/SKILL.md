---
name: streamlit-theming
description: Streamlit theming and styling. Use when customizing app colors or appearance. Covers config.toml theming, avoiding CSS, and targeted styling when necessary.
license: Apache-2.0
---

# Streamlit Theming

Custom colors and styling. Stick to config.toml—avoid CSS.

## Use config.toml

Configure your app's colors in `.streamlit/config.toml`.

```toml
# .streamlit/config.toml
[theme]
primaryColor = "#FF4B4B"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
textColor = "#262730"
font = "sans serif"
```

**Color variables:**
- `primaryColor` → Interactive elements (buttons, links, sliders)
- `backgroundColor` → Main content area
- `secondaryBackgroundColor` → Sidebar and expanders
- `textColor` → All text
- `font` → `"sans serif"`, `"serif"`, or `"monospace"`

This is the proper way to customize colors—no CSS required.

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
st.text_input("Username", key="login_username")
st.button("Submit", key="login_submit")
```

Generated CSS classes:
```css
.st-key-login_username { ... }
.st-key-login_submit { ... }
```

Apply styles:
```python
st.markdown("""
<style>
.st-key-login_submit button {
    width: 100%;
}
</style>
""", unsafe_allow_html=True)
```

**Only use this as a last resort.**

## Dark Mode

Streamlit automatically supports dark mode based on user system preferences. Your `config.toml` colors apply to light mode; Streamlit derives dark mode colors automatically.

To test dark mode: Change your system appearance settings.
