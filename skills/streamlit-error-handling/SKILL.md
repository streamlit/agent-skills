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

**Install:** `pip install streamlit-extras`

## Logging to Database

```python
def log_exception_to_table(exception_data: dict) -> None:
    session = get_session()
    
    session.sql("""
        INSERT INTO app_exceptions (
            exception_name, traceback, user_name, 
            timestamp, app_name
        ) VALUES (?, ?, ?, ?, ?)
    """, [
        exception_data["exception_name"],
        exception_data["traceback"],
        exception_data["user_name"],
        exception_data["timestamp"],
        exception_data["app_name"]
    ]).collect()
```

## Logging to Snowflake Telemetry

```python
from snowflake import telemetry

def log_exception_to_telemetry(exception_data: dict) -> None:
    telemetry.add_event(
        name="Uncaught exception in streamlit app",
        attributes=exception_data
    )
```

Requires enabling telemetry collection first.

## Notifications

Set up alerts so you know immediately when something breaks.

**Options:**
- Slack via webhook
- Email via Snowflake notifications
- Any webhook endpoint

**Example Slack notification:**

```python
import requests

def send_slack_notification(exception_data: dict) -> None:
    webhook_url = st.secrets["SLACK_WEBHOOK_URL"]
    
    requests.post(webhook_url, json={
        "text": f"🚨 App error: {exception_data['exception_name']}",
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*App:* {exception_data['app_name']}\n*User:* {exception_data['user_name']}\n*Error:* `{exception_data['exception_name']}`"
                }
            }
        ]
    })
```

## Snowflake Alerts

For database-logged exceptions:

```sql
CREATE ALERT app_exception_alert
  WAREHOUSE = my_warehouse
  SCHEDULE = '1 MINUTE'
  IF (EXISTS (
    SELECT 1 FROM app_exceptions
    WHERE timestamp > DATEADD(MINUTE, -1, CURRENT_TIMESTAMP())
  ))
  THEN
    CALL SYSTEM$SEND_NOTIFICATION(...)
```

## What to Do with Exception Data

- Track how frequently your app goes down
- Set up SLAs with stakeholders
- Ask Cortex Agent for help directly from Slack
- Feed exceptions to AI for suggested fixes
