---
name: streamlit-error-handling
description: Streamlit error handling patterns for production apps. Use when setting up exception handling, logging, or alerts. Covers global exception handlers, database logging, telemetry, and notifications.
license: Apache-2.0
---

# Streamlit Error Handling

When your app crashes, users just see a red error screen. Without error handling, you might not know for hours—or until someone complains.

## Global Exception Handler

Catch unhandled exceptions and respond to them.

```python
# streamlit_app.py
import streamlit as st
from streamlit_extras.exception_handler import set_global_exception_handler


def custom_exception_handler(exception: Exception) -> None:
    """Handle uncaught exceptions."""
    # Show error to user (default behavior)
    st.exception(exception)

    # Notify that the error was logged
    st.toast("Error logged. Our team has been notified.", icon=":material/error:")


set_global_exception_handler(custom_exception_handler)
```

**Install:** `uv add streamlit-extras`

This is a minimal example. In production, you can extend the handler to:
- Log exceptions to a database or file
- Send alerts via Slack, email, or PagerDuty
- Capture user context (username, session info)
- Track error frequency with telemetry

