---
name: streamlit-components
description: Using third-party Streamlit components. Use when looking to extend Streamlit with community packages. Covers installation, popular components, and when to use them.
license: Apache-2.0
---

# Streamlit Components

Extend Streamlit with third-party components from the community.

## What Are Components?

Components are standalone Python libraries that add features not in Streamlit's core API. They're built by the community and can be installed like any Python package.

## Installation

```bash
uv add streamlit-extras
```

Then import and use:

```python
import streamlit as st
from streamlit_extras.add_vertical_space import add_vertical_space

st.title("My App")
add_vertical_space(3)
st.write("Content below some space")
```

## Use with Caution

Components are not maintained by Streamlit. Before adopting:

- **Check maintenance** - Is it actively maintained? Recent commits?
- **Check compatibility** - Does it work with your Streamlit version?
- **Check popularity** - GitHub stars, downloads, community usage
- **Consider alternatives** - Can you achieve this with core Streamlit?

Components can break when Streamlit updates, so prefer core features when possible.

## Popular Components

### streamlit-extras

A collection of useful utilities and widgets.

```bash
uv add streamlit-extras
```

```python
from streamlit_extras.switch_page_button import switch_page_button
from streamlit_extras.add_vertical_space import add_vertical_space
from streamlit_extras.colored_header import colored_header

colored_header("Section Title", description="A nice header")
add_vertical_space(2)
switch_page_button("Go to Settings")
```

### streamlit-aggrid

Interactive dataframes with sorting, filtering, and editing.

```bash
uv add streamlit-aggrid
```

```python
from st_aggrid import AgGrid

AgGrid(df, editable=True, filter=True)
```

### streamlit-folium

Interactive maps with Folium.

```bash
uv add streamlit-folium
```

```python
import folium
from streamlit_folium import st_folium

m = folium.Map(location=[37.7749, -122.4194], zoom_start=12)
st_folium(m, width=700)
```

### pygwalker

Tableau-like data exploration interface.

```bash
uv add pygwalker
```

```python
import pygwalker as pyg

pyg.walk(df, env="Streamlit")
```

### streamlit-keyup

Text input that updates on every keystroke (not just on enter).

```bash
uv add streamlit-keyup
```

```python
from st_keyup import st_keyup

value = st_keyup("Search", debounce=300)
```

## Discover More

Browse the component gallery: https://streamlit.io/components

Filter by category, popularity, and recency to find components for your use case.
