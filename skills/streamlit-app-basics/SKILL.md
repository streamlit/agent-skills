---
name: streamlit-app-basics
description: Build Streamlit applications following best practices. Use when creating dashboards, data apps, interactive visualizations, or any Python web application with Streamlit. Covers layout, state management, caching, forms, and deployment patterns.
license: Apache-2.0
---

# Streamlit App Development

Build production-ready Streamlit applications with proper architecture, state management, and performance optimization.

## When to Use This Skill

- Creating new Streamlit applications
- Building data dashboards or visualization tools
- Adding interactivity to Python data analysis
- Refactoring existing Streamlit apps for better performance
- Implementing multi-page Streamlit applications

## Project Structure

For Streamlit applications, use this structure:

```
my-streamlit-app/
├── app.py                 # Main entry point (or streamlit_app.py)
├── pages/                 # Multi-page app pages (auto-discovered)
│   ├── 1_Dashboard.py
│   └── 2_Settings.py
├── components/            # Reusable UI components
├── utils/                 # Helper functions
├── data/                  # Static data files
├── .streamlit/
│   └── config.toml        # Streamlit configuration
└── requirements.txt
```

## Core Patterns

### Basic App Structure

```python
import streamlit as st

# Page config must be first Streamlit command
st.set_page_config(
    page_title="My App",
    page_icon="📊",
    layout="wide",  # or "centered"
    initial_sidebar_state="expanded"
)

# Title and description
st.title("My Application")
st.markdown("Brief description of what this app does.")

# Main content
def main():
    # Your app logic here
    pass

if __name__ == "__main__":
    main()
```

### Session State Management

Use `st.session_state` for persisting data across reruns:

```python
# Initialize state (check first to avoid resetting)
if "counter" not in st.session_state:
    st.session_state.counter = 0

# Update state
if st.button("Increment"):
    st.session_state.counter += 1

# Display state
st.write(f"Count: {st.session_state.counter}")
```

**Session state rules:**
- Always check if key exists before initializing
- Use descriptive key names
- Don't store large objects (use caching instead)
- Clean up unused keys when appropriate

### Caching

Use caching to avoid recomputing expensive operations:

```python
# Cache data loading (for DataFrames, API responses)
@st.cache_data(ttl=3600)  # Cache for 1 hour
def load_data(path: str) -> pd.DataFrame:
    return pd.read_csv(path)

# Cache resources (for ML models, database connections)
@st.cache_resource
def load_model():
    return SomeMLModel.load("model.pkl")
```

**Caching rules:**
- Use `@st.cache_data` for serializable data (DataFrames, dicts, lists)
- Use `@st.cache_resource` for non-serializable objects (models, connections)
- Set `ttl` for data that changes over time
- Use `show_spinner=False` for quick operations

### Layout

#### Columns

```python
col1, col2, col3 = st.columns([2, 1, 1])  # Ratio-based widths

with col1:
    st.header("Main Content")

with col2:
    st.metric("Users", "1,234", "+12%")

with col3:
    st.metric("Revenue", "$5,678", "-3%")
```

#### Tabs

```python
tab1, tab2 = st.tabs(["Data", "Visualization"])

with tab1:
    st.dataframe(df)

with tab2:
    st.line_chart(df)
```

#### Sidebar

```python
with st.sidebar:
    st.header("Filters")
    date_range = st.date_input("Date Range", [])
    category = st.selectbox("Category", ["All", "A", "B", "C"])
```

#### Expander

```python
with st.expander("Advanced Options", expanded=False):
    threshold = st.slider("Threshold", 0, 100, 50)
```

### Forms

Use forms to batch input and reduce reruns:

```python
with st.form("my_form"):
    name = st.text_input("Name")
    email = st.text_input("Email")
    age = st.number_input("Age", min_value=0, max_value=120)

    submitted = st.form_submit_button("Submit")

    if submitted:
        st.success(f"Submitted: {name}, {email}, {age}")
        # Process form data
```

### Error Handling

```python
try:
    result = process_data(user_input)
    st.success("Processing complete!")
except ValueError as e:
    st.error(f"Invalid input: {e}")
except Exception as e:
    st.exception(e)  # Shows full traceback in development
```

### Progress and Status

```python
# Progress bar
progress = st.progress(0)
for i in range(100):
    progress.progress(i + 1)

# Spinner for long operations
with st.spinner("Loading data..."):
    data = load_large_dataset()

# Status messages
st.success("Operation completed!")
st.info("This is informational.")
st.warning("Proceed with caution.")
st.error("Something went wrong.")
```

## Multi-Page Apps

Create a `pages/` directory with numbered Python files:

```
app.py              # Home page
pages/
├── 1_Dashboard.py  # First page in sidebar
├── 2_Analysis.py   # Second page
└── 3_Settings.py   # Third page
```

Page files follow the same structure as the main app:

```python
# pages/1_Dashboard.py
import streamlit as st

st.set_page_config(page_title="Dashboard", page_icon="📊")
st.title("Dashboard")

# Page content...
```

## Performance Guidelines

1. **Minimize reruns**: Use forms, cache aggressively, avoid expensive operations in main flow
2. **Lazy loading**: Load data only when needed
3. **Efficient data display**: Use `st.dataframe` for large datasets (virtual scrolling)
4. **Fragment reruns**: Use `@st.fragment` for partial reruns (Streamlit 1.33+)

```python
@st.fragment
def update_chart():
    """Only this section reruns when interacted with."""
    option = st.selectbox("Chart type", ["Line", "Bar"])
    st.line_chart(data) if option == "Line" else st.bar_chart(data)
```

## Common Widgets Reference

| Widget | Use Case |
|--------|----------|
| `st.button` | Trigger actions |
| `st.selectbox` | Single selection from list |
| `st.multiselect` | Multiple selections |
| `st.slider` | Numeric range selection |
| `st.text_input` | Short text entry |
| `st.text_area` | Long text entry |
| `st.number_input` | Numeric entry with validation |
| `st.date_input` | Date selection |
| `st.file_uploader` | File uploads |
| `st.download_button` | File downloads |
| `st.checkbox` | Boolean toggle |
| `st.radio` | Single selection (visible options) |
| `st.toggle` | On/off switch |

## Deployment Checklist

### requirements.txt

```
streamlit>=1.30.0
pandas>=2.0.0
# other dependencies
```

### .streamlit/config.toml

```toml
[theme]
primaryColor = "#FF6B6B"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
textColor = "#262730"

[server]
maxUploadSize = 200
enableXsrfProtection = true
```

### secrets.toml (local only, don't commit)

```toml
# .streamlit/secrets.toml
API_KEY = "your-api-key"
DATABASE_URL = "postgresql://..."
```

Access secrets:
```python
api_key = st.secrets["API_KEY"]
```

## Common Pitfalls

1. **Forgetting session state initialization**: Always check `if "key" not in st.session_state`
2. **Caching functions with unhashable arguments**: Use `hash_funcs` parameter or restructure
3. **Blocking the main thread**: Use `st.spinner` and consider async for long operations
4. **Overusing columns for complex layouts**: Consider custom CSS or third-party components
5. **Not using forms for multi-input submissions**: Causes unnecessary reruns

## References

- [Streamlit Documentation](https://docs.streamlit.io)
- [API Reference](https://docs.streamlit.io/library/api-reference)
- [Streamlit Community Cloud](https://streamlit.io/cloud)
- [Streamlit Components Gallery](https://streamlit.io/components)
