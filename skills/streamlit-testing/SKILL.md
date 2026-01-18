---
name: streamlit-testing
description: Streamlit testing patterns. Use when writing automated tests for Streamlit apps. Covers AppTest framework, pytest integration, and manual browser testing.
license: Apache-2.0
---

# Streamlit Testing

Optional automated testing with the AppTest framework. Most Streamlit apps don't need extensive testing, but it can be useful for complex apps or CI pipelines.

## AppTest Basics

```python
from streamlit.testing.v1 import AppTest

def test_app_loads():
    at = AppTest.from_file("streamlit_app.py")
    at.run()
    assert not at.exception
```

## Initialization Methods

```python
# From file
at = AppTest.from_file("streamlit_app.py")

# From string
at = AppTest.from_string("""
import streamlit as st
st.title("Hello")
""")

# From function
def my_app():
    import streamlit as st
    st.title("Hello")

at = AppTest.from_function(my_app)
```

## Setting Secrets

```python
at = AppTest.from_file("streamlit_app.py")
at.secrets["API_KEY"] = "test-key"
at.secrets["DATABASE"] = "test-db"
at.run()
```

## Interacting with Widgets

```python
at = AppTest.from_file("streamlit_app.py")
at.run()

# Text input
at.text_input[0].input("test value").run()

# Button click
at.button[0].click().run()

# Selectbox
at.selectbox[0].select("Option A").run()

# Slider
at.slider[0].set_value(50).run()

# Checkbox
at.checkbox[0].check().run()

# Toggle
at.toggle[0].set_value(True).run()
```

## Asserting Output

```python
at = AppTest.from_file("streamlit_app.py")
at.run()

# Check title
assert at.title[0].value == "My App"

# Check for success message
assert at.success[0].value == "Data saved!"

# Check for errors
assert not at.exception

# Check dataframe exists
assert len(at.dataframe) > 0
```

## Run with pytest

```bash
pytest tests/ -v
```

**Example test file (tests/test_app.py):**

```python
from streamlit.testing.v1 import AppTest

def test_home_loads():
    at = AppTest.from_file("streamlit_app.py")
    at.run()
    assert not at.exception
    assert len(at.title) > 0

def test_filtering():
    at = AppTest.from_file("streamlit_app.py")
    at.run()
    at.selectbox[0].select("Option A").run()
    assert "Option A" in str(at.dataframe[0].value)
```

## CI Integration

For GitHub Actions, use the official [Streamlit App Action](https://github.com/streamlit/streamlit-app-action):

```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: streamlit/streamlit-app-action@v0.0.3
        with:
          app-path: streamlit_app.py
```

Or manually with pytest:

```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install -r requirements.txt
      - run: pytest tests/ -v
```

## Manual Browser Testing

For quick visual verification:

```bash
uv run streamlit run streamlit_app.py
```

Default: `http://localhost:8501`

If port busy: Try 8502, 8503, etc.
