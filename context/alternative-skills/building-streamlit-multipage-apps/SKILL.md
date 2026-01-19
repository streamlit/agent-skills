---
name: building-streamlit-multipage-apps
description: Builds multipage Streamlit applications with navigation, cross-page state, and URL routing. Use when creating apps with multiple pages, implementing navigation, sharing state between pages, or using st.Page and st.navigation.
---

# Building Streamlit Multipage Apps

Streamlit supports multipage apps via directory structure or explicit page definitions.

## Recommended: st.navigation

Explicit control over pages and navigation:

```python
# app.py (entrypoint)
import streamlit as st

pages = [
    st.Page("app_pages/dashboard.py", title="Dashboard", icon=":material/dashboard:"),
    st.Page("app_pages/analytics.py", title="Analytics", icon=":material/analytics:"),
    st.Page("app_pages/settings.py", title="Settings", icon=":material/settings:"),
]

nav = st.navigation(pages)
nav.run()
```

**Benefits:**
- Full control over page order and visibility
- Custom icons (Material Icons supported)
- Conditional page visibility based on auth/permissions
- Pages can be in any directory

**Notes:** `st.Page(url_path=...)` cannot include `/` (no subdirectories).

### Page Groups

```python
pages = {
    "": [
        st.Page("app_pages/home.py", title="Home"),
        st.Page("app_pages/about.py", title="About"),
    ],
    "Data": [
        st.Page("app_pages/explorer.py", title="Explorer")
    ],
    "Admin": [
        st.Page("app_pages/users.py", title="Users"),
        st.Page("app_pages/settings.py", title="Settings"),
    ],
}

nav = st.navigation(pages)
nav.run()
```

### Conditional Pages

```python
pages = [st.Page("app_pages/home.py", title="Home")]

if st.user.is_logged_in:
    pages.append(st.Page("app_pages/dashboard.py", title="Dashboard"))

if st.session_state.get("is_admin"):
    pages.append(st.Page("app_pages/admin.py", title="Admin"))

nav = st.navigation(pages)
nav.run()
```

## Alternative: pages/ Directory

Simpler but less flexible:

```
my_app/
├── app.py              # Main entrypoint
└── pages/
    ├── 1_Dashboard.py   # Numbered for ordering
    ├── 2_Analytics.py
    └── 3_Settings.py
```

Pages appear in sidebar automatically. Prefix with numbers to control order.

**Notes:** Once any session runs `st.navigation`, the `pages/` directory is ignored for all sessions until the app restarts.

## Sharing State Across Pages

Widgets are NOT stateful across pages. Use session state:

```python
# Page 1: Set state
st.session_state.selected_user = st.selectbox("User", users, key="user")

# Page 2: Read state
if "selected_user" in st.session_state:
    st.write(f"Selected: {st.session_state.selected_user}")
else:
    st.warning("No user selected. Go to page 1 first.")
```

### Shared Widgets Pattern

Put common widgets in the entrypoint (before `nav.run()`):

```python
# app.py
import streamlit as st

# Sidebar widgets available on all pages
with st.sidebar:
    st.session_state.theme = st.selectbox("Theme", ["Light", "Dark"])

pages = [...]
nav = st.navigation(pages)
nav.run()
```

## Programmatic Navigation

```python
# Navigate to another page
if st.button("Go to Settings"):
    st.switch_page("app_pages/settings.py")

# In-page navigation links
st.page_link("app_pages/home.py", label="Home", icon=":material/home:")
st.page_link("https://example.com", label="External", icon=":material/open_in_new:")
```

## URL Query Parameters

Use `st.query_params` for shareable URLs:

```python
# Read params
user_id = st.query_params.get("user_id")

# Set params
st.query_params["user_id"] = "123"
st.query_params.from_dict({"user_id": "123", "tab": "overview"})

# Clear params
st.query_params.clear()
```

**Notes:**
- Query params are strings. Use `get_all()` for repeated keys.
- Query params are cleared when navigating between pages.

## Project Structure

```
my_app/
├── streamlit_app.py              # Entrypoint: st.navigation setup
├── app_pages/              # Page files
│   ├── dashboard.py
│   ├── analytics.py
│   └── settings.py
├── utils/              # Shared utilities
│   ├── __init__.py
│   ├── data.py
│   └── auth.py
└── .streamlit/
    ├── config.toml
    └── secrets.toml
```

## Page Configuration

Its recommended to set page config at the top of the page:

```python
st.set_page_config(
    page_title="Dashboard",
    page_icon="📊",
    layout="wide",  # or "centered"
    initial_sidebar_state="expanded",  # or "collapsed", "auto"
)
```

## Reference

- [Multipage apps docs](https://docs.streamlit.io/develop/concepts/multipage-apps)
- [st.navigation API](https://docs.streamlit.io/develop/api-reference/navigation/st.navigation)
- [st.Page API](https://docs.streamlit.io/develop/api-reference/navigation/st.page)
- [st.query_params API](https://docs.streamlit.io/develop/api-reference/caching-and-state/st.query_params)
