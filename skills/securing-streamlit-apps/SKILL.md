---
name: securing-streamlit-apps
description: Secures Streamlit apps with secrets management, authentication, and security best practices. Use when handling credentials, implementing user authentication, managing secrets, or deploying apps to production.
---

# Securing Streamlit Apps

Security essentials for production Streamlit applications.

## Secrets Management

**Never hardcode credentials.** Use `st.secrets` with `secrets.toml`.

```python
# BAD: Hardcoded secrets
api_key = "sk-abc123..."  # NEVER DO THIS

# GOOD: Use st.secrets
api_key = st.secrets["OPENAI_API_KEY"]
```

### secrets.toml Structure

```toml
# .streamlit/secrets.toml
OPENAI_API_KEY = "sk-..."
DATABASE_URL = "postgresql://..."

# Nested secrets
[database]
host = "localhost"
password = "secret"

# Connection-specific
[connections.mydb]
host = "localhost"
password = "secret"
```

### Accessing Secrets

```python
# Root level
api_key = st.secrets["OPENAI_API_KEY"]

# Nested (both notations work)
db_host = st.secrets["database"]["host"]
db_host = st.secrets.database.host

# With default
value = st.secrets.get("OPTIONAL_KEY", "default")
```

### Critical: Add to .gitignore

```
# .gitignore
.streamlit/secrets.toml
```

## User Authentication (OIDC)

Streamlit supports OpenID Connect authentication with major providers.

### Configuration

```toml
# .streamlit/secrets.toml
[auth]
redirect_uri = "http://localhost:8501/oauth2callback"
cookie_secret = "generate-a-strong-random-string"
client_id = "your-client-id"
client_secret = "your-client-secret"
server_metadata_url = "https://accounts.google.com/.well-known/openid-configuration"
```

### Login Flow

```python
import streamlit as st

if not st.user.is_logged_in:
    st.button("Log in", on_click=st.login)
    st.stop()

st.button("Log out", on_click=st.logout)
st.write(f"Welcome, {st.user.name}!")
st.write(f"Email: {st.user.email}")
```

**Note:** `st.login()` and `st.logout()` start a new session after updating the auth cookie. Don't rely on previous session state.

**Guard:** When auth isn't configured, `st.user` has no attributes. Use a safe check:

```python
if not getattr(st.user, "is_logged_in", False):
    st.stop()
```

### Multiple Providers

```toml
# .streamlit/secrets.toml
[auth]
redirect_uri = "http://localhost:8501/oauth2callback"
cookie_secret = "xxx"

[auth.google]
client_id = "xxx"
client_secret = "xxx"
server_metadata_url = "https://accounts.google.com/.well-known/openid-configuration"

[auth.microsoft]
client_id = "xxx"
client_secret = "xxx"
server_metadata_url = "https://login.microsoftonline.com/{tenant}/v2.0/.well-known/openid-configuration"
```

```python
if not getattr(st.user, "is_logged_in", False):
    st.button("Log in with Google", on_click=st.login, args=["google"])
    st.button("Log in with Microsoft", on_click=st.login, args=["microsoft"])
    st.stop()
```

### Conditional Content

```python
if st.user.is_logged_in:
    if st.user.email.endswith("@company.com"):
        st.write("Internal dashboard content")
    else:
        st.warning("Access restricted to company users")
```

## Security Best Practices

### Pickle Security

`st.cache_data` and `st.session_state` use pickle internally.

```python
# RISK: Deserializing untrusted data
import pickle
data = pickle.loads(user_uploaded_bytes)  # DANGEROUS!

# SAFE: Only deserialize trusted sources
# Streamlit's internal pickle usage is safe for normal operations
```

### File Upload Validation

```python
uploaded_file = st.file_uploader("Upload", type=["csv", "xlsx"])

if uploaded_file:
    # Validate file type
    if uploaded_file.type not in ["text/csv", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]:
        st.error("Invalid file type")
        st.stop()
    
    # Validate file size
    if uploaded_file.size > 10 * 1024 * 1024:  # 10MB
        st.error("File too large")
        st.stop()
```

### SQL Injection Prevention

```python
# BAD: String formatting
query = f"SELECT * FROM users WHERE id = {user_input}"  # VULNERABLE!

# GOOD: Parameterized queries
df = conn.query(
    "SELECT * FROM users WHERE id = :id",
    params={"id": user_input},
    ttl=600
)
```

### Input Validation

```python
user_input = st.text_input("Enter ID")

# Validate before using
if not user_input.isdigit():
    st.error("Please enter a valid numeric ID")
    st.stop()

# Now safe to use
user_id = int(user_input)
```

## Static File Serving

For serving static assets:

```toml
# .streamlit/config.toml
[server]
enableStaticServing = true
```

Place files in `./static/` directory, accessible at `app/static/filename.ext`.

**Limitations:**
- Only certain file types served with correct MIME type (.jpg, .png, .gif, .pdf, .json, etc.)
- Other types served as `text/plain` for security

## Environment Variables

```python
import os

# Read from environment
api_key = os.environ.get("API_KEY")
```

**Tip:** Root-level `secrets.toml` entries are also exposed as environment variables.

## Reference

- [Secrets management](https://docs.streamlit.io/develop/concepts/connections/secrets-management)
- [Authentication docs](https://docs.streamlit.io/develop/concepts/connections/authentication)
- [st.user API](https://docs.streamlit.io/develop/api-reference/user/st.user)
- [Security reminders](https://docs.streamlit.io/develop/concepts/connections/security-reminders)
