---
name: deploying-streamlit-to-snowflake
description: 'Deploy Streamlit applications to Snowflake using the `snow` CLI tool. Covers snowflake.yml manifest configuration, compute pools, container runtime, and deployment workflow.'
---

# Deploying Streamlit to Snowflake

Deploy local Streamlit apps to Snowflake using the `snow` CLI.

## Prerequisites

- **Snowflake CLI v3.14.0+**: Required for `definition_version: 2` (SPCS container runtime)
- **A Streamlit app**: Your main entry point file (e.g., `streamlit_app.py`)
- **A configured Snowflake connection**: Run `snow connection list` to verify

### Check and Ensure Correct CLI Version

**CRITICAL**: Always check the CLI version before deployment. Older versions don't support SPCS container runtime.

```bash
snow --version
```

If version is below 3.14.0, use `uvx` to run the latest CLI without installing:

```bash
# Use uvx to run latest snow CLI (recommended)
uvx --from snowflake-cli snow streamlit deploy --replace
```

This bypasses any outdated local installation and ensures you always use the latest CLI.

## Deployment Workflow

### Step 1: Get Connection Details

**CRITICAL**: Before creating `snowflake.yml`, get the actual values from the user's Snowflake connection. Do NOT use placeholder values like `MY_DATABASE`.

```bash
# Get connection details (database, schema, warehouse, role)
snow connection list
```

This returns JSON with the configured connection values. Use these values in `snowflake.yml`.

**If connection details are missing or incomplete**, ask the user:
- What database should the app be deployed to?
- What schema within that database?
- What warehouse should the app use for queries?

For **external_access_integrations**, these are account-specific. Check available resources:
```bash
snow sql -q "SHOW EXTERNAL ACCESS INTEGRATIONS"
```

A common name is `PYPI_ACCESS_INTEGRATION`, but verify it exists in the user's account.

### Step 2: Create Project Structure

**If starting from a template** (recommended): The `templates/apps/` directory contains ready-to-use dashboard templates with `snowflake.yml`, `pyproject.toml`, and `secrets.toml.example` already configured:
- **dashboard-metrics-snowflake** — Multi-metric dashboard with line/area/bar/point charts and time range filtering
- **dashboard-compute-snowflake** — Resource consumption dashboard with credit usage by account type, instance, and region
- **dashboard-stock-peers-snowflake** — Stock peer analysis with normalized price comparison and individual vs peer average charts

Snowflake-specific templates (ending in `-snowflake`) include parameterized queries and connection setup. Copy a template directory and adapt it:

```bash
cp -r templates/apps/dashboard-metrics-snowflake my_app
cd my_app
# Copy secrets.toml.example to secrets.toml and fill in your credentials
cp .streamlit/secrets.toml.example .streamlit/secrets.toml
```

**If starting from scratch**, create this structure:

```text
my_streamlit_app/
  snowflake.yml        # Deployment manifest (required)
  streamlit_app.py     # Main entry point
  pyproject.toml       # Python dependencies
  src/                 # Additional modules
    helpers.py
  data/                # Data files
    sample.csv
```

**pyproject.toml** — always include `snowflake-connector-python` explicitly (see [Python 3.12+ caveat](#troubleshooting)):

```toml
[project]
name = "my-app"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "snowflake-connector-python>=3.3.0",
    "streamlit[snowflake]>=1.54.0",
]
```

**Quick start with templates:**
```bash
# Single-page app
snow init my_app --template streamlit_vnext_single_page

# Multi-page app
snow init my_app --template streamlit_vnext_multi_page
```

### Step 3: Create `snowflake.yml`

Use the actual values from Step 1 (not placeholders):

```yaml
definition_version: 2
entities:
  my_streamlit:
    type: streamlit
    identifier:
      name: MY_APP_NAME           # Choose a name for the app
      database: <FROM_CONNECTION> # Use actual database from connection
      schema: <FROM_CONNECTION>   # Use actual schema from connection
    query_warehouse: <FROM_CONNECTION>  # Use actual warehouse from connection
    runtime_name: SYSTEM$ST_CONTAINER_RUNTIME_PY3_11
    external_access_integrations:
      - <YOUR_PYPI_INTEGRATION>   # For pip installs (if needed)
    main_file: streamlit_app.py
    artifacts:
      - streamlit_app.py
      - pyproject.toml
      - src/helpers.py            # Include ALL files your app needs
      - data/sample.csv
```

### Step 4: Verify App Runs Locally

**IMPORTANT**: Before deploying, verify the app runs locally to catch dependency or import errors early.

**Set up local credentials** (if using `st.connection("snowflake")`):

```bash
mkdir -p .streamlit
```

Create `.streamlit/secrets.toml` (NEVER commit this file — it contains sensitive credentials that would be exposed in version control):

**CRITICAL**: The `account` and `host` values must match the user's Snowflake connection exactly. Derive them from the Snowflake CLI connection config:

```bash
snow connection list
```

Use the `account` and `host` values from the output:

```toml
[connections.snowflake]
account = "<YOUR_ACCOUNT>"          # e.g., "ORGNAME-ACCTNAME" — from `snow connection list`
host = "<YOUR_HOST>"                # e.g., "myaccount.snowflakecomputing.com" — from `snow connection list`
user = "<YOUR_USER>"
authenticator = "externalbrowser"  # SSO login, or use password
warehouse = "<YOUR_WAREHOUSE>"
database = "<YOUR_DATABASE>"
schema = "<YOUR_SCHEMA>"
```

A wrong `account` value (e.g., just the org name without the account locator) will redirect to the wrong login page. If the connection config has a `host` field, always include it in secrets.toml.

Add to `.gitignore`:
```
.streamlit/secrets.toml
```

**Run locally:**
```bash
# Install dependencies
uv sync

# Quick check: verify imports work (catches missing dependencies)
uv run python -c "import streamlit_app"

# Full check: run the app locally
uv run streamlit run streamlit_app.py
```

Check that:
- The import check passes without errors
- The app starts without import errors
- All pages/components load correctly

If there are errors, fix `pyproject.toml`, run `uv sync` again, and re-test before deploying.

### Step 5: Deploy

```bash
cd my_streamlit_app
snow streamlit deploy --replace
```

The `--replace` flag updates an existing app with the same name.

### Step 6: Access Your App

After deployment, `snow` outputs the app URL. You can also find it in Snowsight under **Projects > Streamlit**.

## Configuration Reference

| Parameter | Description | Example |
|-----------|-------------|---------|
| `name` | Unique app identifier | `MY_DASHBOARD` |
| `database` | Target database | `ANALYTICS_DB` |
| `schema` | Target schema | `DASHBOARDS` |
| `query_warehouse` | Warehouse for SQL queries | `COMPUTE_WH` |
| `runtime_name` | Container runtime version | `SYSTEM$ST_CONTAINER_RUNTIME_PY3_11` |
| `main_file` | Entry point script | `streamlit_app.py` |
| `artifacts` | All files to upload (must include main_file) | See example above |
| `external_access_integrations` | Network access for pip, APIs (account-specific) | `PYPI_ACCESS_INTEGRATION` |

## Key Points

1. **Always use container runtime** (`runtime_name`) for best performance
2. **List ALL files** in `artifacts` - anything not listed won't be deployed
3. **Dependencies go in `pyproject.toml`** - installed automatically on deploy
4. **Iterate with `--replace`** - redeploy without creating duplicates

## Troubleshooting

**App not updating?**
- Ensure you're using `--replace`
- Check that changed files are in `artifacts`

**Import errors?**
- Verify all modules are in `artifacts`
- Check `pyproject.toml` has all pip dependencies

**`No module named 'snowflake'` on Python 3.12+?**
- `streamlit[snowflake]` gates `snowflake-connector-python` on `python_version < "3.12"`, so on Python 3.12+ the connector is silently skipped
- Fix: add `snowflake-connector-python>=3.3.0` as an explicit top-level dependency in `pyproject.toml`, then `uv sync`

**Wrong login page / redirect to unexpected account?**
- The `account` value in `secrets.toml` must be the full account locator (e.g., `ORGNAME-ACCTNAME`), not just the org name
- Run `snow connection list` and copy the exact `account` and `host` values
- If your connection config has a `host` field, include it in `secrets.toml`

**Network/pip errors?**
- Add `PYPI_ACCESS_INTEGRATION` to `external_access_integrations`
