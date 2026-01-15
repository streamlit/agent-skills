---
name: streamlit-environment
description: Python environment setup for Streamlit apps. Use when setting up a new project or managing dependencies. Covers uv for dependency management and running apps.
license: Apache-2.0
---

# Streamlit Environment

Use uv for dependency management. It's fast, reliable, and creates isolated environments automatically.

## Install uv

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
uv add streamlit pandas
```

This creates:
- `pyproject.toml` with dependencies
- `uv.lock` for reproducible builds
- `.venv/` virtual environment

## Run the App

```bash
uv run streamlit run streamlit_app.py
```

**What happens:**
- uv reads `pyproject.toml`
- Installs missing packages automatically
- Runs in isolated environment
- Reproducible across machines

## With Options

```bash
uv run streamlit run streamlit_app.py --server.port 8502
uv run streamlit run streamlit_app.py --server.headless true
```

## Add Dependencies

```bash
uv add altair plotly
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

## pyproject.toml Example

```toml
[project]
name = "my-streamlit-app"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "streamlit>=1.40.0",
    "pandas>=2.0.0",
    "altair>=5.0.0",
    "snowflake-connector-python>=3.0.0",
]

[tool.uv]
dev-dependencies = [
    "pytest>=8.0.0",
]
```
