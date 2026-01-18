---
name: streamlit-code-organization
description: Streamlit code organization patterns. Use when structuring apps with separate modules, utilities, and classes. Covers separation of concerns, keeping UI code clean, and avoiding common pitfalls.
license: Apache-2.0
---

# Streamlit Code Organization

Keep your Streamlit apps maintainable by separating UI from business logic.

## Separation of Concerns

Streamlit files should focus on UI. Move business logic to separate modules.

```
my-app/
├── streamlit_app.py      # UI only
├── app_pages/            # Page UI modules
│   ├── dashboard.py
│   └── settings.py
├── lib/                  # Business logic
│   ├── data.py           # Data loading/processing
│   ├── models.py         # Data classes
│   └── api.py            # External API clients
└── utils/
    └── helpers.py        # Shared utilities
```

## UI Files Stay Clean

Your Streamlit files should read like a description of the UI, not contain complex logic.

```python
# streamlit_app.py - GOOD: UI-focused
import streamlit as st
from lib.data import load_sales_data, compute_metrics
from lib.models import DateRange

st.title("Sales Dashboard")

date_range = DateRange(
    start=st.date_input("Start"),
    end=st.date_input("End"),
)

data = load_sales_data(date_range)
metrics = compute_metrics(data)

st.metric("Revenue", metrics.revenue)
st.metric("Orders", metrics.orders)
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

## Data Classes for State

Use dataclasses to structure your app's data instead of loose dictionaries.

```python
# lib/models.py
from dataclasses import dataclass
from datetime import date

@dataclass
class DateRange:
    start: date
    end: date

@dataclass
class SalesMetrics:
    revenue: float
    orders: int
    avg_order_value: float
```

```python
# streamlit_app.py
from lib.models import DateRange, SalesMetrics

# Clear, typed data structures
range = DateRange(start=start_date, end=end_date)
metrics = compute_metrics(range)  # Returns SalesMetrics
```

## Utility Functions

Keep reusable logic in utility modules.

```python
# utils/formatting.py
def format_currency(value: float) -> str:
    return f"${value:,.2f}"

def format_percent(value: float) -> str:
    return f"{value:.1%}"
```

```python
# streamlit_app.py
from utils.formatting import format_currency

st.metric("Revenue", format_currency(metrics.revenue))
```

## API Clients as Classes

Wrap external services in classes for cleaner usage.

```python
# lib/api.py
import streamlit as st

class SalesAPI:
    def __init__(self, api_key: str):
        self.api_key = api_key

    def get_orders(self, start: date, end: date) -> list[dict]:
        # API call logic here
        ...

@st.cache_resource
def get_api_client() -> SalesAPI:
    return SalesAPI(st.secrets["API_KEY"])
```

```python
# streamlit_app.py
from lib.api import get_api_client

api = get_api_client()
orders = api.get_orders(start, end)
```

## Avoid if __name__ == "__main__"

Streamlit apps run the entire file on each interaction. Don't use the main guard.

```python
# BAD - don't do this
if __name__ == "__main__":
    main()

# GOOD - just put the code directly
import streamlit as st

st.title("My App")
# ... rest of your app
```

The main guard is useful for utility modules that you might want to test independently:

```python
# lib/data.py
import pandas as pd

def load_data(path: str) -> pd.DataFrame:
    return pd.read_csv(path)

def process_data(df: pd.DataFrame) -> pd.DataFrame:
    # Processing logic
    ...

# Optional: allows running this file directly for quick testing
if __name__ == "__main__":
    df = load_data("test_data.csv")
    print(process_data(df))
```

## Imports at the Top

Keep imports organized: standard library, third-party, then local modules.

```python
# streamlit_app.py
import streamlit as st
from datetime import date

import pandas as pd

from lib.data import load_data
from lib.models import DateRange
from utils.formatting import format_currency
```

## When to Split

**Keep in main file:**
- Simple apps (< 200 lines)
- One-off scripts
- Prototypes

**Split into modules when:**
- Data processing is complex (> 20 lines)
- You have reusable utilities
- Multiple pages share logic
- You want to unit test business logic separately
