---
name: streamlit-multipage
description: Streamlit multi-page app patterns. Use when building apps with multiple pages, setting up navigation, or managing state across pages.
license: Apache-2.0
---

# Streamlit Multi-Page Apps

Structure and navigation for apps with multiple pages.

## Directory Structure

```
streamlit_app.py          # Main entry point
app_pages/
    home.py
    analytics.py
    settings.py
```

**Important:** Name your pages directory `app_pages/` (not `pages/`). Using `pages/` conflicts with Streamlit's old auto-discovery API and can cause unexpected behavior.

## Main Module

```python
# streamlit_app.py
import streamlit as st

# Initialize global state (shared across pages)
if "api_client" not in st.session_state:
    st.session_state.api_client = init_api_client()

# Define navigation
page = st.navigation([
    st.Page("app_pages/home.py", title="Home", icon=":material/home:"),
    st.Page("app_pages/analytics.py", title="Analytics", icon=":material/bar_chart:"),
    st.Page("app_pages/settings.py", title="Settings", icon=":material/settings:"),
])

# App-level UI runs before page content
# Useful for shared elements like titles
st.title(f"{page.icon} {page.title}")

page.run()
```

**Note:** When you handle titles in `streamlit_app.py`, individual pages should NOT use `st.title` again.

## Navigation Position

**Few pages (3-7) → Top navigation:**

```python
page = st.navigation([...], position="top")
```

Creates a clean horizontal menu. Great for simple apps.

**Many pages or nested sections → Sidebar:**

```python
page = st.navigation({
    "Main": [
        st.Page("app_pages/home.py", title="Home"),
        st.Page("app_pages/analytics.py", title="Analytics"),
    ],
    "Admin": [
        st.Page("app_pages/settings.py", title="Settings"),
        st.Page("app_pages/users.py", title="Users"),
    ],
}, position="sidebar")
```

**Mixed: Some pages ungrouped:**

Use an empty string key `""` for pages that shouldn't be in a section:

```python
page = st.navigation({
    "": [
        st.Page("app_pages/home.py", title="Home"),
    ],
    "Analytics": [
        st.Page("app_pages/dashboard.py", title="Dashboard"),
        st.Page("app_pages/reports.py", title="Reports"),
    ],
}, position="top")
```

## Page Modules

```python
# app_pages/analytics.py
import streamlit as st

# Access global state
api = st.session_state.api_client
user = st.session_state.user

# Page-specific content (title is handled in streamlit_app.py)
data = api.fetch_analytics(user.id)
st.line_chart(data)
```

## Global State

Initialize state in the main module so all pages can access it.

```python
# streamlit_app.py
st.session_state.api = init_client()
st.session_state.user = get_user()
st.session_state.settings = load_settings()
```

**Why main module:**
- Runs before every page
- Ensures state is initialized
- Single source of truth

## Page-Specific State

Use prefixed keys for page-specific state:

```python
# app_pages/analytics.py
if "analytics_date_range" not in st.session_state:
    st.session_state.analytics_date_range = default_range()
```
