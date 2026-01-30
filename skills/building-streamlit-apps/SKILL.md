---
name: building-streamlit-apps
description: Builds Streamlit web applications with proper state management, caching, and widget patterns. Use when creating Streamlit apps, handling session state, managing widget behavior, or encountering unexpected reruns or state issues.
---

# Building Streamlit Apps

Streamlit reruns the entire script top-to-bottom on every user interaction. This execution model requires specific patterns for state management and widget behavior.

## Session State

Variables reset on every rerun unless stored in `st.session_state`.

```python
# BAD: Lost on rerun
count = 0
count += 1

# GOOD: Persists across reruns
if "count" not in st.session_state:
    st.session_state.count = 0
st.session_state.count += 1
```

**Key rules:**
- Always check existence before accessing: `if "key" not in st.session_state`
- Use `st.session_state.get("key", default)` for safe access with defaults
- Session state is per-user, per-tab, and temporary (lost on tab close)

## Widget Keys and State

Widgets can store values in session state via the `key` parameter.

```python
# Widget value accessible via session state
name = st.text_input("Name", key="user_name")
# st.session_state.user_name contains the same value
```

Use the widget's `key` in callbacks, not the return variable:

```python
# BAD: Updates every second click
def increment():
    slide_val += 1  # Wrong - using variable

# GOOD: Use the key
def increment():
    st.session_state.slider += 1  # Correct - using key

st.button("Add", on_click=increment)
slide_val = st.slider("Value", 0, 10, key="slider")
```

## Button Behavior

Buttons return `True` only during the rerun triggered by the click. They do NOT retain state.

```python
# BAD: Content disappears after any other interaction
if st.button("Load data"):
    data = load_data()  # Lost on next rerun!
    st.dataframe(data)

# GOOD: Store result in session state
if st.button("Load data"):
    st.session_state.data = load_data()

if "data" in st.session_state:
    st.dataframe(st.session_state.data)
```

**Anti-patterns to avoid:**
- Nested buttons never work (outer button is `False` when inner clicked)
- Widgets inside `if st.button()` blocks disappear after any interaction
- Don't set `st.session_state.my_button` - button state is not settable

**Toggle pattern:**

```python
if "show_details" not in st.session_state:
    st.session_state.show_details = False

def toggle():
    st.session_state.show_details = not st.session_state.show_details

st.button("Toggle details", on_click=toggle)

if st.session_state.show_details:
    st.write("Details here...")
```

## Caching Basics

Cache expensive operations to avoid recomputation on every rerun.

```python
@st.cache_data  # For data: DataFrames, API responses, computations
def load_data():
    return pd.read_csv("large_file.csv")

@st.cache_resource  # For resources: DB connections, ML models
def get_model():
    return load_ml_model()
```

**When to use which:**
- `@st.cache_data`: Returns a copy each call. Safe for data that might be modified.
- `@st.cache_resource`: Returns the same object. Use for connections/models.

**Important:** Set `ttl` or `max_entries` for data that changes to prevent unbounded memory growth.

```python
@st.cache_data(ttl=3600)  # Refresh after 1 hour
def get_live_data():
    return fetch_from_api()
```

## Callbacks

Use callbacks for immediate state changes before the rerun:

```python
def on_change():
    st.session_state.processed = process(st.session_state.input_text)

st.text_input("Enter text", key="input_text", on_change=on_change)

# processed value available immediately in this rerun
if "processed" in st.session_state:
    st.write(st.session_state.processed)
```

## Custom Classes

Classes defined in the main script are redefined on each rerun, breaking identity checks.

```python
# BAD: Class redefined each rerun
class User:
    def __init__(self, name):
        self.name = name

# isinstance() and == checks may fail unexpectedly
```

**Solutions:**
1. Define classes in separate modules (imported modules aren't redefined)
2. Implement custom `__eq__` and `__hash__` methods
3. Use dataclasses with `frozen=True`
4. Store serializable data (dicts) instead of class instances

## Common Gotchas

1. **Duplicate widget keys**: Each widget needs a unique key if used multiple times
2. **Modifying cached data**: Don't mutate `@st.cache_resource` returns (affects all users)

## Reference

- [Session State docs](https://docs.streamlit.io/develop/concepts/architecture/session-state)
- [Caching docs](https://docs.streamlit.io/develop/concepts/architecture/caching)
- [Widget behavior](https://docs.streamlit.io/develop/concepts/architecture/widget-behavior)
