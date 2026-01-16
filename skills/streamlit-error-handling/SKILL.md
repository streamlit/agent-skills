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
import traceback
from datetime import datetime
from streamlit_extras.exception_handler import set_global_exception_handler

def custom_exception_handler(exception: Exception) -> None:
    """Handle uncaught exceptions."""
    
    # Still show error to user (default behavior)
    st.exception(exception)
    
    # Collect context
    exception_data = {
        "exception_name": str(exception),
        "traceback": traceback.format_exc().strip(),
        "user_name": getattr(st.user, "user_name", "unknown"),
        "timestamp": datetime.now().isoformat(),
        "app_name": "your_app_name",
    }
    
    # Log and notify
    log_exception(exception_data)
    send_notification(exception_data)

set_global_exception_handler(custom_exception_handler)
```

**Install:** `uv add streamlit-extras`

