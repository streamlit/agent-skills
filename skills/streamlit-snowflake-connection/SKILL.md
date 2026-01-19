---
name: streamlit-snowflake-connection
description: Connecting Streamlit apps to Snowflake. Use when setting up database connections, managing secrets, or querying Snowflake from a Streamlit app.
license: Apache-2.0
---

# Streamlit Snowflake Connection

Connect your Streamlit app to Snowflake the right way.

## Use st.connection

Always use `st.connection("snowflake")` instead of raw connectors.

```python
import streamlit as st

conn = st.connection("snowflake")

# Query data
df = conn.query("SELECT * FROM my_table LIMIT 100")
st.dataframe(df)
```

**Why st.connection:**
- Automatic connection pooling
- Built-in caching
- Handles reconnection
- Works with st.secrets

## Caller's Rights Connection (Streamlit 1.53+)

For apps running in Snowflake, use caller's rights to run queries with the viewer's permissions instead of the app owner's:

```python
conn = st.connection("snowflake", type="snowflake-callers-rights")
```

This is useful when:
- Different users should see different data based on their Snowflake roles
- You want row-level security to apply based on the viewer
- You don't want the app to have elevated permissions

## Cached Query Helper

Wrap queries in a cached function for better control:

```python
import streamlit as st


@st.cache_data(ttl="10m")
def query(sql: str, **params):
    conn = st.connection("snowflake")
    return conn.query(sql, params=params)


# Usage
df = query("SELECT * FROM users WHERE region = :region", region="US")
st.dataframe(df)
```

This gives you a reusable pattern with consistent caching across your app.

## Configure with st.secrets

Store credentials in `.streamlit/secrets.toml` (never commit this file).

```toml
# .streamlit/secrets.toml
[connections.snowflake]
account = "your_account"
user = "your_user"
password = "your_password"
warehouse = "your_warehouse"
database = "your_database"
schema = "your_schema"
```

Add to `.gitignore`:
```
.streamlit/secrets.toml
```

## Parameterized Queries

Use parameters to prevent SQL injection:

```python
conn = st.connection("snowflake")

# Safe: parameterized
df = conn.query(
    "SELECT * FROM users WHERE region = :region",
    params={"region": selected_region}
)

# UNSAFE: string formatting - don't do this
# df = conn.query(f"SELECT * FROM users WHERE region = '{selected_region}'")
```

## Cache Queries

For repeated queries, use TTL caching:

```python
conn = st.connection("snowflake")

# Cache for 10 minutes
df = conn.query("SELECT * FROM metrics", ttl=600)

# Cache for 1 hour
df = conn.query("SELECT * FROM reference_data", ttl="1h")
```

## Write Data

Use the session for write operations:

```python
conn = st.connection("snowflake")
session = conn.session()

# Write a dataframe
session.write_pandas(df, "MY_TABLE", auto_create_table=True)

# Execute statements
session.sql("INSERT INTO logs VALUES (:ts, :msg)", params={...}).collect()
```

## Multiple Connections

Define multiple connections in secrets:

```toml
# .streamlit/secrets.toml
[connections.snowflake]
account = "prod_account"
# ... prod credentials

[connections.snowflake_staging]
account = "staging_account"
# ... staging credentials
```

```python
prod_conn = st.connection("snowflake")
staging_conn = st.connection("snowflake_staging")
```

## Chat with Cortex

Build a chat interface using Snowflake Cortex LLMs:

```python
import streamlit as st
from snowflake.cortex import complete

st.set_page_config(page_title="AI Assistant", page_icon=":sparkles:")

if "messages" not in st.session_state:
    st.session_state.messages = []

for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.write(msg["content"])

if prompt := st.chat_input("Ask anything"):
    st.session_state.messages.append({"role": "user", "content": prompt})

    with st.chat_message("user"):
        st.write(prompt)

    with st.chat_message("assistant"):
        response = st.write_stream(
            complete(
                "claude-3-5-sonnet",
                prompt,
                session=st.connection("snowflake").session(),
                stream=True,
            )
        )

    st.session_state.messages.append({"role": "assistant", "content": response})
```

See `streamlit-chat` for more chat patterns (avatars, suggestions, history management).
