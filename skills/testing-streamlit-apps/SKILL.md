---
name: testing-streamlit-apps
description: Tests Streamlit applications using the AppTest framework. Use when writing automated tests for Streamlit apps, testing widget interactions, verifying session state, or setting up CI/CD pipelines.
---

# Testing Streamlit Apps

Use Streamlit's `AppTest` framework to test apps programmatically without a browser.

## Basic Test Structure

```python
from streamlit.testing.v1 import AppTest

def test_basic():
    # Initialize and run the app
    at = AppTest.from_file("app.py")
    at.run()
    
    # Make assertions
    assert at.title[0].value == "My App"
    assert not at.exception
```

## Running Tests with pytest

```bash
# Install pytest
pip install pytest

# Run tests
pytest tests/
```

**File naming convention:** `test_*.py` or `*_test.py`

## Retrieving Elements

Elements are accessed by type and index (display order):

```python
at.run()

# Text elements
at.title[0].value
at.header[0].value
at.markdown[0].value
at.text[0].value

# Widgets
at.button[0]
at.text_input[0]
at.selectbox[0]
at.slider[0]
at.checkbox[0]

# Data elements
at.dataframe[0]
at.table[0]
at.json[0]
```

### By Key

Retrieve widgets by their key:

```python
# If widget has key="username"
at.text_input("username").value
at.button("submit").click()  # key as positional arg
```

### Containers

```python
# Sidebar elements
at.sidebar.button[0]
at.sidebar.selectbox[0]

# Columns
at.columns[0].button[0]  # First button in first column

# Tabs
at.tabs[0].write[0]  # Content in first tab
```

## Interacting with Widgets

### Buttons

```python
at.run()
at.button[0].click()
at.run()  # Must run again after interaction

assert at.session_state.clicked is True
```

### Text Input

```python
at.text_input[0].input("hello")
at.run()

assert at.text_input[0].value == "hello"
```

### Selectbox

```python
at.selectbox[0].select("Option B")
at.run()

# Or by index
at.selectbox[0].select_index(1)
at.run()
```

### Slider

```python
# Single-value slider
at.slider[0].set_value(50)
at.run()

# Range slider
at.slider[1].set_range(10, 50)
at.run()

# Increment/decrement
at.number_input[0].increment()
at.run()
```

### Checkbox

```python
at.checkbox[0].check()
at.run()

# Or use check/uncheck
at.checkbox[0].uncheck()
at.run()
```

## Testing Session State

```python
def test_session_state():
    at = AppTest.from_file("app.py")
    at.run()
    
    # Check initial state
    assert "count" in at.session_state
    assert at.session_state.count == 0
    
    # Interact and verify state change
    at.button[0].click()
    at.run()
    
    assert at.session_state.count == 1
```

### Initialize Session State

```python
def test_with_initial_state():
    at = AppTest.from_file("app.py")
    at.session_state["user"] = "test_user"
    at.run()
    
    assert "Welcome, test_user" in at.markdown[0].value
```

## Testing with Secrets

```python
def test_with_secrets():
    at = AppTest.from_file("app.py")
    at.secrets["API_KEY"] = "test-key"
    at.run()
    
    # App can now use st.secrets["API_KEY"]
```

## Testing Multipage Apps

**Important:** `AppTest` supports one page per instance and does not work with `st.navigation`/`st.Page`. Test each page file directly.

```python
def test_page():
    at = AppTest.from_file("pages/dashboard.py")
    at.run()
    
    assert at.title[0].value == "Dashboard"
```

## Error Handling

```python
def test_no_exceptions():
    at = AppTest.from_file("app.py")
    at.run()
    
    # Check no exceptions occurred
    assert not at.exception
    
    # Or check specific exception
    if at.exception:
        assert "expected error" in str(at.exception[0].value)
```

## Complete Example

```python
# test_counter.py
from streamlit.testing.v1 import AppTest

def test_counter_app():
    """Test a counter app with increment button."""
    at = AppTest.from_file("counter.py")
    at.run()
    
    # Initial state
    assert at.session_state.count == 0
    assert "Count: 0" in at.markdown[0].value
    
    # Click increment
    at.button[0].click()
    at.run()
    
    assert at.session_state.count == 1
    assert "Count: 1" in at.markdown[0].value


def test_counter_reset():
    """Test the reset button."""
    at = AppTest.from_file("counter.py")
    at.session_state["count"] = 10
    at.run()
    
    # Click reset
    at.button("reset").click()
    at.run()
    
    assert at.session_state.count == 0
```

## Best Practices

1. **Keep tests focused** - One behavior per test
2. **Use descriptive names** - `test_login_with_valid_credentials`
3. **Test edge cases** - Empty inputs, boundary values
4. **Mock external services** - Don't hit real APIs in tests
5. **Run after each interaction** - Always call `at.run()` after widget interactions

## Reference

- [App testing docs](https://docs.streamlit.io/develop/concepts/app-testing)
- [AppTest API](https://docs.streamlit.io/develop/api-reference/app-testing/st.testing.v1.apptest)
