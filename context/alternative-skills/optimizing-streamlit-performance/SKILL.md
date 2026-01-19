---
name: optimizing-streamlit-performance
description: Optimizes Streamlit app performance using caching, fragments, and efficient data handling. Use when apps are slow, working with large datasets, experiencing unnecessary reruns, or need performance optimization.
---

# Optimizing Streamlit Performance

Streamlit reruns the entire script on every interaction. Use these patterns to minimize recomputation and improve responsiveness.

## Caching Strategy

### @st.cache_data - For Data

Returns a new copy each call. Use for DataFrames, API responses, computed results.

```python
@st.cache_data(ttl=3600)  # Set ttl for live data
def fetch_users():
    return db.query("SELECT * FROM users")

@st.cache_data(max_entries=100)  # Limit memory usage
def compute_stats(data):
    return expensive_computation(data)
```

**Key parameters:**
- `ttl`: Time-to-live in seconds. Recommended for data that changes.
- `max_entries`: Maximum cached results. Prevents memory bloat.
- `show_spinner`: Show loading indicator (default: True)

### @st.cache_resource - For Resources

Returns the same object each call. Use for DB connections, ML models, heavy objects.

```python
@st.cache_resource
def get_database():
    return create_connection()

@st.cache_resource
def load_model():
    return torch.load("model.pt")
```

**Cleanup with `on_release`:** Use to clean up resources when evicted from cache:

```python
def cleanup_connection(conn):
    conn.close()

@st.cache_resource(on_release=cleanup_connection)
def get_database():
    return create_connection()
```

**Critical warning:** Never mutate `@st.cache_resource` returns—changes affect all users:

```python
# BAD: Mutating shared resource
@st.cache_resource
def get_config():
    return {"setting": "default"}

config = get_config()
config["setting"] = "custom"  # Affects ALL users!

# GOOD: Return immutable or copy before modifying
config = get_config().copy()
config["setting"] = "custom"
```

### Caching Anti-patterns

```python
# BAD: Caching function that reads widgets
@st.cache_data
def filtered_data():
    query = st.text_input("Query")  # Widget inside cached function!
    return df[df["name"].str.contains(query)]

# GOOD: Pass widget values as parameters
@st.cache_data
def filtered_data(query: str):
    return df[df["name"].str.contains(query)]

query = st.text_input("Query")
result = filtered_data(query)
```

## Fragments for Partial Reruns

`@st.fragment` reruns only its contents when widgets inside it change, not the whole app.

```python
@st.fragment
def chart_controls():
    chart_type = st.selectbox("Chart", ["line", "bar"])
    # Only this fragment reruns when chart_type changes
    if chart_type == "line":
        st.line_chart(data)
    else:
        st.bar_chart(data)

# This expensive operation doesn't rerun when chart_controls changes
data = load_large_dataset()
chart_controls()
```

**Use fragments for:**
- Independent UI sections (charts, filters, forms)
- Components that update frequently
- Isolating expensive operations from frequent interactions

**Limitations:**
- Cannot combine `@st.fragment` with `@st.cache_data` on same function
- Return values are ignored on fragment reruns (use session state)
- Widgets can't be rendered in containers created outside the fragment body
- Auto-rerun with `run_every` for periodic updates: `@st.fragment(run_every="5s")`

## Forms for Batched Input

Forms prevent reruns until the submit button is clicked.

```python
with st.form("settings"):
    name = st.text_input("Name")
    email = st.text_input("Email")
    age = st.number_input("Age", 0, 120)

    # REQUIRED: Every form needs a submit button
    if st.form_submit_button("Save"):
        save_user(name, email, age)
```

**Use forms when:**
- Multiple related inputs should be submitted together
- Each keystroke would cause expensive reruns
- User needs to fill multiple fields before processing

## Large Data Handling

### For datasets under ~100M rows

```python
@st.cache_data
def load_data():
    return pd.read_parquet("large_file.parquet")
```

### For very large datasets

`@st.cache_data` uses pickle which slows with huge data. Use `@st.cache_resource` instead:

```python
@st.cache_resource  # No serialization overhead
def load_huge_data():
    return pd.read_parquet("huge_file.parquet")

# WARNING: Don't mutate the returned DataFrame!
```

### Sampling for exploration

```python
@st.cache_data(ttl=3600)
def load_sample(n=10000):
    df = pd.read_parquet("huge.parquet")
    return df.sample(n=n)
```

## Multithreading

Custom threads cannot call Streamlit commands (no session context).

```python
import threading

def fetch_in_background(url, results, index):
    results[index] = requests.get(url).json()  # No st.* calls!

# Collect results, then display in main thread
results = [None] * 3
threads = [
    threading.Thread(target=fetch_in_background, args=(url, results, i))
    for i, url in enumerate(urls)
]
for t in threads:
    t.start()
for t in threads:
    t.join()

# Now display in main thread
for result in results:
    st.write(result)
```

**Prefer alternatives when possible:**
- `@st.cache_data` for expensive computations
- `@st.fragment(run_every="5s")` for periodic updates
- `asyncio` with `st.write_stream()` for async operations

## Performance Checklist

1. **Cache all expensive operations** - data loading, API calls, computations
2. **Set TTL on cached data** - prevent stale data in production
3. **Use fragments** - isolate frequently-updating sections
4. **Use forms** - batch related inputs
5. **Profile before optimizing** - use `st.cache_data(show_spinner="Loading...")` to identify slow operations

## Reference

- [Caching docs](https://docs.streamlit.io/develop/concepts/architecture/caching)
- [Fragments docs](https://docs.streamlit.io/develop/concepts/architecture/fragments)
- [Forms docs](https://docs.streamlit.io/develop/concepts/architecture/forms)
