---
name: setting-up-streamlit-environment
description: Setting up Python environments for Streamlit apps. Use when creating a new project or managing dependencies. Covers uv for dependency management and running apps.
license: Apache-2.0
---

# Streamlit environment

Use uv for dependency management. It's fast, reliable, and creates isolated environments automatically.

## Install uv

See [official installation guide](https://docs.astral.sh/uv/getting-started/installation/) for all options.

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or with Homebrew
brew install uv

# Or with pip
pip install uv
```

## Quick start (venv only)

For simple apps, just create a virtual environment:

```bash
uv venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
uv pip install streamlit
```

Run with:

```bash
streamlit run streamlit_app.py
```

## Full project setup

For larger projects or when you need reproducible builds:

```bash
uv init my-streamlit-app
cd my-streamlit-app
uv add streamlit
```

This creates:
- `pyproject.toml` with dependencies
- `uv.lock` for reproducible builds
- `.venv/` virtual environment

Run with:

```bash
uv run streamlit run
```

## With options

```bash
streamlit run streamlit_app.py --server.port 8502
streamlit run streamlit_app.py --server.headless true
```

## Add dependencies

```bash
# With venv approach
uv pip install plotly snowflake-connector-python

# With full project (uv init)
uv add plotly snowflake-connector-python
```

## Project structure

```
my-streamlit-app/
├── pyproject.toml        # Dependencies
├── uv.lock               # Lock file
├── .venv/                # Virtual environment
├── streamlit_app.py      # Main entry point
├── app_pages/            # Multi-page modules
│   ├── home.py
│   └── analytics.py
├── .gitignore            # Include secrets.toml here
└── .streamlit/
    ├── config.toml       # Streamlit config (theming, etc.)
    └── secrets.toml      # App secrets (optional, never commit)
```

**Important:** Add `.streamlit/secrets.toml` to your `.gitignore` to avoid committing credentials.

## Convention

Name your main file `streamlit_app.py` for consistency. This is what Streamlit expects by default.

**What goes in the main module:**
- When using navigation: it's a router that defines pages and runs them
- When there's no navigation: it's the home page with your main content

## pyproject.toml Example

```toml
[project]
name = "my-streamlit-app"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "streamlit>=1.40.0",
    "plotly>=5.0.0",
    "snowflake-connector-python>=3.0.0",
]

[tool.uv]
dev-dependencies = [
    "pytest>=8.0.0",
]
```

## References

- [uv documentation](https://docs.astral.sh/uv/)
- [Streamlit installation](https://docs.streamlit.io/get-started/installation)
