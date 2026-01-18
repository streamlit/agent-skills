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

## Snowflake in Streamlit (SiS)

When running in Snowflake's native Streamlit environment, connections are automatic:

```python
conn = st.connection("snowflake")
# No secrets needed - uses session context
```

The connection inherits the user's Snowflake session and permissions.
