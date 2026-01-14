---
name: streamlit-app-basics
description: Build Streamlit applications following best practices. Use when creating dashboards, data apps, or interactive visualizations with Streamlit.
license: Apache-2.0
---

# Streamlit App Basics

## App Structure

```python
import streamlit as st

st.set_page_config(page_title="My App", page_icon="📊", layout="wide")
st.title("My Application")

# App content here
```

`st.set_page_config()` must be the first Streamlit command.

## Session State

Use `st.session_state` to persist data across reruns:

```python
if "counter" not in st.session_state:
    st.session_state.counter = 0

if st.button("Increment"):
    st.session_state.counter += 1
```

Always check if key exists before initializing.

## Caching

```python
@st.cache_data
def load_data(path):
    return pd.read_csv(path)

@st.cache_resource
def load_model():
    return SomeModel.load("model.pkl")
```

- `@st.cache_data` for data (DataFrames, dicts, lists)
- `@st.cache_resource` for objects (models, connections)

## Layout

```python
# Horizontal container
with st.container(horizontal=True):
    st.button("One")
    st.button("Two")

# Sidebar
with st.sidebar:
    option = st.selectbox("Choose", ["A", "B"])

# Tabs
tab1, tab2 = st.tabs(["Data", "Chart"])
```

## Forms

Batch inputs to avoid reruns on every interaction:

```python
with st.form("my_form"):
    name = st.text_input("Name")
    submitted = st.form_submit_button("Submit")
    if submitted:
        st.write(f"Hello {name}")
```

## References

- [Streamlit Documentation](https://docs.streamlit.io)
- [API Reference](https://docs.streamlit.io/develop/api-reference)
