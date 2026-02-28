---
name: connecting-streamlit-data
description: Connects Streamlit apps to databases and external data sources using st.connection. Use when connecting to SQL databases, Snowflake, APIs, or building custom data connections.
---

# Connecting Streamlit to Data

Use `st.connection` for managed, cached connections to databases and APIs.

**Note:** `st.connection` is cached with `st.cache_resource`. The connection object is shared across sessions, so avoid per-user state or mutation.

## SQL Databases

```python
# Configure in .streamlit/secrets.toml
# [connections.mydb]
# dialect = "postgresql"
# host = "localhost"
# port = 5432
# database = "mydb"
# username = "user"
# password = "password"

conn = st.connection("mydb", type="sql")

# Query with caching (set ttl for live data)
df = conn.query("SELECT * FROM users", ttl=600)  # Cache 10 minutes
st.dataframe(df)
```

### Supported Databases

- PostgreSQL: `dialect = "postgresql"`
- MySQL: `dialect = "mysql"`
- SQLite: `dialect = "sqlite"` (use `database = "path/to/db.sqlite"`)
- SQL Server: `dialect = "mssql+pyodbc"`

### SQLAlchemy URL

Alternatively, use a connection URL:

```toml
# .streamlit/secrets.toml
[connections.mydb]
url = "postgresql://user:password@localhost:5432/mydb"
```

## Snowflake

```python
# .streamlit/secrets.toml
# [connections.snowflake]
# account = "xxx"
# user = "xxx"
# password = "xxx"
# warehouse = "xxx"
# database = "xxx"
# schema = "xxx"

conn = st.connection("snowflake", type="snowflake")
df = conn.query("SELECT * FROM my_table", ttl=600)
```

## Query Parameters

```python
# Use parameters to prevent SQL injection
user_id = st.text_input("User ID")
df = conn.query(
    "SELECT * FROM users WHERE id = :id",
    params={"id": user_id},
    ttl=600,
)
```

## Session for Write Operations

```python
with conn.session as session:
    session.execute(
        text("INSERT INTO users (name) VALUES (:name)"),
        {"name": new_name},
    )
    session.commit()
```

## Custom Connections

Build connections for APIs or unsupported databases:

```python
from streamlit.connections import BaseConnection
import requests

class APIConnection(BaseConnection[requests.Session]):
    def _connect(self, **kwargs) -> requests.Session:
        session = requests.Session()
        session.headers["Authorization"] = f"Bearer {self._secrets['api_key']}"
        return session

    def query(self, endpoint: str, ttl: int = 3600):
        @st.cache_data(ttl=ttl)
        def _query(endpoint):
            return self._instance.get(f"{self._secrets['base_url']}{endpoint}").json()
        return _query(endpoint)

# Usage
conn = st.connection("my_api", type=APIConnection)
data = conn.query("/users", ttl=300)
```

## Secrets Configuration

### Per-Connection Secrets

```toml
# .streamlit/secrets.toml
[connections.mydb]
host = "localhost"
password = "secret"

[connections.my_api]
api_key = "xxx"
base_url = "https://api.example.com"
```

### Global vs Project Secrets

- Global: `~/.streamlit/secrets.toml` (shared across apps)
- Project: `.streamlit/secrets.toml` (project-specific, overrides global)

**Always add to `.gitignore`:**
```
.streamlit/secrets.toml
```

## TTL Best Practices

```python
# BAD: No TTL = stale data forever
df = conn.query("SELECT * FROM live_metrics")

# GOOD: Set appropriate TTL
df = conn.query("SELECT * FROM live_metrics", ttl=60)  # Refresh every minute

# For static reference data, longer TTL is fine
df = conn.query("SELECT * FROM countries", ttl=86400)  # Daily refresh
```

## Reference

- [Connections docs](https://docs.streamlit.io/develop/concepts/connections)
- [st.connection API](https://docs.streamlit.io/develop/api-reference/connections/st.connection)
- [Secrets management](https://docs.streamlit.io/develop/concepts/connections/secrets-management)
