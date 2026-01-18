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
uv add streamlit-keyup
```

Then import and use:

```python
from st_keyup import st_keyup

# Unlike st.text_input, this updates on every keystroke
query = st_keyup("Search", debounce=300)
```

## Use with Caution

Components are not maintained by Streamlit. Before adopting:

- **Check maintenance** - Is it actively maintained? Recent commits?
- **Check compatibility** - Does it work with your Streamlit version?
- **Check popularity** - GitHub stars, downloads, community usage
- **Consider alternatives** - Can you achieve this with core Streamlit?

Components can break when Streamlit updates, so prefer core features when possible.

## Popular Components

### streamlit-keyup

Text input that fires on every keystroke instead of waiting for enter/blur. Useful for live search.

```bash
uv add streamlit-keyup
```

```python
from st_keyup import st_keyup

query = st_keyup("Search", debounce=300)  # 300ms debounce
filtered = df[df["name"].str.contains(query, case=False)]
st.dataframe(filtered)
```

### streamlit-aggrid

Interactive dataframes with sorting, filtering, and cell editing.

```bash
uv add streamlit-aggrid
```

```python
from st_aggrid import AgGrid

AgGrid(df, editable=True, filter=True)
```

### streamlit-folium

Interactive maps powered by Folium.

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

Tableau-like drag-and-drop data exploration.

```bash
uv add pygwalker
```

```python
import pygwalker as pyg

pyg.walk(df, env="Streamlit")
```

### streamlit-extras

A collection of community utilities. Cherry-pick what you need.

```bash
uv add streamlit-extras
```

```python
from streamlit_extras.image_selector import image_selector

# Let users click on regions of an image
selection = image_selector(image, selections=["Region A", "Region B"])
```

```python
from streamlit_extras.markdownlit import mdlit

# Extended markdown with colors and formatting
mdlit("This is [blue]colored[/blue] and **bold**")
```

## Discover More

Browse the component gallery: https://streamlit.io/components

Filter by category, popularity, and recency to find components for your use case.
