---
name: using-streamlit-markdown
description: Covers all markdown features in Streamlit including GitHub-flavored syntax plus Streamlit extensions like colored text, badges, Material icons, and LaTeX. Use when formatting text, labels, tooltips, or any text-rendering element.
license: Apache-2.0
---

# Using markdown in Streamlit

Streamlit supports markdown throughout its API—in `st.markdown()`, widget labels, help tooltips, metrics, table cells, and more. Beyond standard GitHub-flavored Markdown, Streamlit adds colored text, badges, icons, and LaTeX.

## Quick reference

| Feature | Syntax | Example |
|---------|--------|---------|
| Bold | `**text**` | `**Bold**` |
| Italic | `*text*` | `*Italic*` |
| Strikethrough | `~text~` | `~Strikethrough~` |
| Inline code | `` `code` `` | `` `variable` `` |
| Code block | ` ```lang...``` ` | ` ```python...``` ` |
| Link | `[text](url)` | `[Streamlit](https://streamlit.io)` |
| Image | `![alt](path)` | `![Logo](logo.png)` |
| Heading | `# ` to `###### ` | `## Section` |
| Blockquote | `> text` | `> Note` |
| Horizontal rule | `---` | `---` |
| Unordered list | `- item` | `- First`<br>`- Second` |
| Ordered list | `1. item` | `1. First`<br>`2. Second` |
| Task list | `- [ ]` / `- [x]` | `- [x] Done`<br>`- [ ] Todo` |
| Table | `\| a \| b \|` | `\| H1 \| H2 \|`<br>`\|--\|--\|` |
| Emoji | Direct or shortcode | `🎉` or `:tada:` |
| Streamlit logo | `:streamlit:` | `:streamlit:` |
| Material icon | `:material/icon_name:` | `:material/check_circle:` |
| Colored text | `:color[text]` | `:red[Error]` |
| Colored background | `:color-background[text]` | `:blue-background[Info]` |
| Badge | `:color-badge[text]` | `:green-badge[Success]` |
| Small text | `:small[text]` | `:small[footnote]` |
| LaTeX (inline) | `$formula$` | `$ax^2 + bx + c$` |
| LaTeX (block) | `$$formula$$` | `$$\int_0^1 x^2 dx$$` |
| Arrows/symbols | Auto-converted | `->` becomes → |

## Where markdown works

| Context | Full markdown | Label subset |
|---------|---------------|--------------|
| `st.markdown()` body | Yes | - |
| `st.write()` | Yes | - |
| `st.title()`, `st.header()`, `st.subheader()` | Yes | - |
| Widget labels (`st.button`, `st.selectbox`, etc.) | - | Yes |
| `help` tooltips | Yes | - |
| `st.metric()` label, value, delta | - | Yes |
| `st.table()` cells and headers | Yes | - |
| `st.info()`, `st.warning()`, `st.error()`, `st.success()` | Yes | - |
| `st.caption()` | Yes | - |
| `st.expander()` label | - | Yes |
| `st.tabs()` labels | - | Yes |

**Label subset** supports: bold, italic, strikethrough, inline code, links, images, colored text, Material icons, and emojis. Unsupported elements are stripped to text content. Escape with backslash to show literally: `"1\. Not a list"`.

## Basic formatting (GitHub-flavored)

```python
st.markdown("""
**Bold** and *italic* and ~~strikethrough~~

`inline code` for variables

[Link text](https://streamlit.io)

> Blockquote for callouts

---
""")
```

### Code blocks

Fenced code blocks with optional syntax highlighting:

~~~python
st.markdown("""
```python
def hello():
    return "Hello, World!"
```
""")
~~~

Supported languages include `python`, `javascript`, `sql`, `json`, `bash`, `yaml`, and many more.

### Lists

```python
st.markdown("""
- Unordered item
- Another item
  - Nested item

1. Ordered item
2. Second item

- [ ] Task list item
- [x] Completed task
""")
```

### Tables

```python
st.markdown("""
| Feature | Status |
|---------|--------|
| Columns | Yes |
| Alignment | Yes |
""")
```

### Headings

```python
st.markdown("# Heading 1")
st.markdown("## Heading 2")
st.markdown("### Heading 3")
```

Headings automatically get anchor links for in-page navigation.

## Colored text

Wrap text in `:color[text]` syntax.

```python
st.markdown(":red[Error] - Something went wrong")
st.markdown(":green[Success] - Operation completed")
st.markdown(":blue[Info] - FYI")
st.markdown(":orange[Warning] - Be careful")
st.markdown(":violet[Note] - Something special")
st.markdown(":gray[Disabled] - Not available")
st.markdown(":rainbow[Celebration!]")
st.markdown(":primary[Themed] - Uses your primary color")
```

**Available colors:** `red`, `orange`, `yellow`, `green`, `blue`, `violet`, `gray` (or `grey`), `rainbow`, `primary`

## Colored backgrounds

Add `-background` suffix for highlighted text.

```python
st.markdown(":red-background[Critical alert]")
st.markdown(":green-background[All systems go]")
st.markdown(":blue-background[New feature]")
st.markdown(":orange-background[Deprecation notice]")
```

**Available:** `red`, `orange`, `yellow`, `green`, `blue`, `violet`, `gray`/`grey`, `primary`. Note: `rainbow` is not supported for backgrounds.

## Badges

For status indicators and labels.

### Inline badge syntax

```python
st.markdown(":green-badge[Active] :red-badge[Inactive] :blue-badge[Beta]")
st.markdown("Version :gray-badge[v2.1.0]")
```

### Standalone badges

```python
st.badge("Active", icon=":material/check:", color="green")
st.badge("Pending", icon=":material/schedule:", color="orange")
st.badge("Deprecated", color="red")
st.badge("New", color="blue")
```

**Available colors:** `red`, `orange`, `yellow`, `green`, `blue`, `violet`, `gray`/`grey`, `primary`. Note: `rainbow` is not supported for badges.

## Small text

Render text in a smaller size.

```python
st.markdown(":small[Fine print goes here]")
st.markdown("Regular text with :small[small annotation]")
```

## Material icons

Use Google Material Symbols with `:material/icon_name:` syntax.

```python
st.markdown(":material/home: Home")
st.markdown(":material/settings: Settings")
st.markdown(":material/check_circle: Complete")
st.markdown(":material/warning: Warning")
st.markdown(":material/search: Search")
```

Find icons at [fonts.google.com/icons](https://fonts.google.com/icons)

**Common icons:**

| Category | Icons |
|----------|-------|
| Navigation | `home`, `menu`, `arrow_back`, `arrow_forward`, `search` |
| Actions | `send`, `save`, `delete`, `edit`, `refresh`, `download`, `upload` |
| Status | `check_circle`, `error`, `warning`, `info`, `pending`, `help` |
| Content | `folder`, `description`, `article`, `code`, `chat` |
| Data | `table_chart`, `bar_chart`, `analytics`, `database` |

### Icons in buttons and widgets

```python
st.button("Save", icon=":material/save:")
st.button("Delete", icon=":material/delete:")

with st.expander("Settings", icon=":material/settings:"):
    st.write("Configure options")

st.info("Complete!", icon=":material/check_circle:")
```

## Emojis

Both Unicode emojis and shortcodes work.

```python
st.markdown("Hello! :wave:")
st.markdown("Great job! :+1: :tada:")
st.markdown("Status: :white_check_mark: Passed")
```

Or use Unicode directly:

```python
st.markdown("Hello! 👋")
st.markdown("Great job! 👍 🎉")
```

## Streamlit logo

```python
st.markdown("Built with :streamlit:")
```

## LaTeX math

Single `$` for inline, double `$$` for display mode. Inline math requires non-whitespace after `$` to avoid conflicts with currency (e.g., "$5" won't be parsed as math).

```python
# Inline math
st.markdown("The quadratic formula is $x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}$")

# Display math (centered, larger)
st.markdown("""
$$
\\sum_{i=1}^{n} x_i = x_1 + x_2 + ... + x_n
$$
""")

# Dedicated LaTeX element
st.latex(r"\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}")
```

## Typographic symbols

These character sequences auto-convert to proper typography:

| Input | Output | Description |
|-------|--------|-------------|
| `--` | – | En dash |
| `---` | — | Em dash |
| `->` | → | Right arrow |
| `<-` | ← | Left arrow |
| `<->` | ↔ | Bidirectional arrow |
| `>=` | ≥ | Greater than or equal |
| `<=` | ≤ | Less than or equal |
| `~=` | ≈ | Approximately equal |
| `!=` | ≠ | Not equal |

```python
st.markdown("Option A -> Option B -> Option C")
st.markdown("The value is >= 100")
st.markdown("A <-> B (bidirectional)")
```

## Text alignment and width

Control layout with `text_alignment` and `width` parameters.

```python
st.markdown("Centered heading", text_alignment="center")
st.markdown("Right-aligned text", text_alignment="right")
st.markdown("Justified paragraph with longer content...", text_alignment="justify")
```

**Alignment options:** `"left"` (default), `"center"`, `"right"`, `"justify"`

```python
# Control width
st.markdown("Full width (default)", width="stretch")
st.markdown("Content width only", width="content")
st.markdown("Fixed 400px", width=400)
```

**Width options:** `"stretch"` (default), `"content"`, or integer pixels

## Images in markdown

```python
st.markdown("![Alt text](https://example.com/image.png)")
```

In labels, images display as icons with max height equal to font height.

## HTML (use sparingly)

Enable raw HTML with `unsafe_allow_html=True`. Use only when necessary—prefer native markdown.

```python
st.markdown(
    "<span style='color: coral'>Custom styled</span>",
    unsafe_allow_html=True
)
```

For pure HTML without markdown processing, use `st.html()`:

```python
st.html("<div class='custom'>Content</div>")
```

## Markdown in tables

`st.table()` renders markdown in all cells including headers.

```python
import pandas as pd

df = pd.DataFrame({
    "Status": [":green-badge[Active]", ":red-badge[Inactive]"],
    "Type": [":material/devices: Device", ":material/cloud: Cloud"],
    "Priority": [":red[High]", ":gray[Low]"]
})
st.table(df)
```

## Markdown in metrics

Labels, values, and deltas support the label subset.

```python
st.metric(
    label=":material/trending_up: Revenue",
    value="$1.2M",
    delta=":green[+12%]"
)
```

## Markdown in widget labels

Widget labels accept the label subset.

```python
st.selectbox(":material/language: Language", ["English", "Spanish", "French"])
st.checkbox(":material/notifications: Enable notifications")
st.slider(":material/volume_up: Volume", 0, 100)
```

## Markdown in container labels

Tabs, popovers, and dialogs support markdown in their labels.

```python
tab1, tab2 = st.tabs([":material/home: Home", ":material/settings: Settings"])

with st.popover(":blue[Options]"):
    st.write("Menu items here")

@st.dialog(":material/edit: Edit Item")
def edit_dialog():
    st.text_input("Name")
```

## Escaping special characters

Use backslash to show literal characters or prevent markdown parsing.

```python
# Escape brackets in colored text
st.markdown(":blue[Array notation: \\[1, 2, 3\\]]")

# Escape in widget labels to prevent list parsing
st.button("1\\. Not an ordered list")

# Show literal asterisks
st.markdown("\\*not italic\\*")
```

## Combining features

Mix multiple features for rich formatting.

```python
st.markdown("""
### :material/rocket: Launch status

| Phase | Status | Notes |
|-------|--------|-------|
| Build | :green-badge[Complete] | All tests passing |
| Deploy | :orange-badge[In Progress] | ETA: 2 hours |
| Monitor | :gray-badge[Pending] | Waiting on deploy |

:small[Last updated: just now]
""")
```

## References

- [st.markdown](https://docs.streamlit.io/develop/api-reference/text/st.markdown)
- [st.latex](https://docs.streamlit.io/develop/api-reference/text/st.latex)
- [GitHub-flavored Markdown spec](https://github.github.com/gfm)
- [Material Symbols](https://fonts.google.com/icons)
- [KaTeX supported functions](https://katex.org/docs/supported.html)
