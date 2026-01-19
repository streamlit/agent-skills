---
name: organizing-streamlit-code
description: Organizing Streamlit code for maintainability. Use when structuring apps with separate modules and utilities. Covers separation of concerns, keeping UI code clean, and import patterns.
license: Apache-2.0
---

# Streamlit code organization

For most simple apps, keep everything in one file—it's cleaner and more straightforward. Only split into modules when your app grows complex.

## When to split

**Keep in one file (most apps):**
- Apps under ~1000 lines
- One-off scripts and prototypes
- Apps where logic is straightforward

**Consider splitting when:**
- Data processing is complex (50+ lines of non-UI code)
- Multiple pages share logic
- You want to test business logic separately

If splitting makes sense, here's how to organize it.

## Directory structure

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

## UI files stay clean

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

## Utility modules

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

## References

- [Multipage apps](https://docs.streamlit.io/develop/concepts/multipage-apps)
- [st.cache_data](https://docs.streamlit.io/develop/api-reference/caching-and-state/st.cache_data)
