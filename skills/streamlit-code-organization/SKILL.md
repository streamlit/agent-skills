---
name: streamlit-code-organization
description: Streamlit code organization patterns. Use when structuring apps with separate modules and utilities. Covers separation of concerns, keeping UI code clean, and import patterns.
license: Apache-2.0
---

# Streamlit Code Organization

Keep your Streamlit apps maintainable by separating UI from business logic.

## Directory Structure

```
my-app/
├── streamlit_app.py      # Main entry point
├── app_pages/            # Page UI modules
│   ├── dashboard.py
│   └── settings.py
└── utils/                # Business logic & helpers
    ├── data.py
    └── api.py
```

## UI Files Stay Clean

Your Streamlit files should read like a description of the UI, not contain complex logic.

```python
# streamlit_app.py - GOOD: UI-focused
import streamlit as st
from utils.data import load_sales_data, compute_metrics

st.title("Sales Dashboard")

start = st.date_input("Start")
end = st.date_input("End")

data = load_sales_data(start, end)
metrics = compute_metrics(data)

st.metric("Revenue", f"${metrics['revenue']:,.0f}")
st.dataframe(data)
```

```python
# streamlit_app.py - BAD: Too much logic mixed in
import streamlit as st
import pandas as pd

st.title("Sales Dashboard")

start = st.date_input("Start")
end = st.date_input("End")

# Don't embed complex logic in UI files
df = pd.read_csv("sales.csv")
df["date"] = pd.to_datetime(df["date"])
df = df[(df["date"] >= start) & (df["date"] <= end)]
df["revenue"] = df["quantity"] * df["price"]
total_revenue = df["revenue"].sum()
# ... 50 more lines of data processing
```

## Utility Modules

Keep reusable logic in `utils/`. Bonus: isolated functions naturally lead to caching.

```python
# utils/data.py
import pandas as pd
import streamlit as st


@st.cache_data(ttl="10m")
def load_sales_data(start, end):
    df = pd.read_csv("sales.csv")
    df["date"] = pd.to_datetime(df["date"])
    return df[(df["date"] >= start) & (df["date"] <= end)]


def compute_metrics(df):
    return {
        "revenue": df["revenue"].sum(),
        "orders": len(df),
    }
```

## Imports from Pages

When importing from page files in `app_pages/`, always import from the root directory perspective. This works because `streamlit_app.py` is the main module.

```python
# app_pages/dashboard.py - GOOD
from utils.data import load_sales_data

# app_pages/dashboard.py - BAD (don't use relative imports)
from ..utils.data import load_sales_data
```

## Running the App

```bash
uv run streamlit run streamlit_app.py
```

Or simply:

```bash
uv run streamlit run
```

Streamlit defaults to `streamlit_app.py` if no file is specified.

## Avoid if __name__ == "__main__"

Streamlit apps run the entire file on each interaction. Don't use the main guard in Streamlit files.

```python
# BAD - don't do this in streamlit_app.py or pages
if __name__ == "__main__":
    main()

# GOOD - just put the code directly
import streamlit as st

st.title("My App")
```

The main guard is fine in utility modules for quick testing:

```python
# utils/data.py
def load_data(path):
    ...

# Optional: test this module directly with `python utils/data.py`
if __name__ == "__main__":
    print(load_data("test.csv"))
```

## When to Split

**Keep in main file:**
- Simple apps (< 200 lines)
- One-off scripts
- Prototypes

**Split into modules when:**
- Data processing is complex
- Multiple pages share logic
- You want to test business logic separately
