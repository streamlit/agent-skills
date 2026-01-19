---
name: setting-up-streamlit-environment
description: Setting up Python environments for Streamlit apps. Use when creating a new project or managing dependencies. Covers uv for dependency management and running apps.
license: Apache-2.0
---

# Streamlit Environment

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

## Create a New Project

```bash
uv init my-streamlit-app
cd my-streamlit-app
uv add streamlit
```

This creates:
- `pyproject.toml` with dependencies
- `uv.lock` for reproducible builds
- `.venv/` virtual environment

## Run the App

```bash
uv run streamlit run
```

**What happens:**
- uv reads `pyproject.toml`
- Installs missing packages automatically
- Runs in isolated environment
- Reproducible across machines

## With Options

```bash
uv run streamlit run --server.port 8502
uv run streamlit run --server.headless true
```

## Add Dependencies

```bash
uv add plotly
uv add snowflake-connector-python
uv add streamlit-extras
```

## Project Structure

```
my-streamlit-app/
├── pyproject.toml        # Dependencies
├── uv.lock               # Lock file
├── .venv/                # Virtual environment
├── streamlit_app.py      # Main entry point
├── app_pages/            # Multi-page modules
│   ├── home.py
│   └── analytics.py
└── .streamlit/
    └── config.toml       # Streamlit config
```

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
