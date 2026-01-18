---
name: displaying-streamlit-data
description: Displays data, tables, charts, and metrics in Streamlit apps. Use when showing DataFrames, creating visualizations, building dashboards, configuring data tables, or working with st.dataframe, st.data_editor, or chart elements.
---

# Displaying Streamlit Data

Choose the right element based on your use case and configure for optimal user experience.

## Choosing Display Elements

| Element | Use Case |
|---------|----------|
| `st.dataframe` | Interactive exploration, sorting, filtering |
| `st.data_editor` | User-editable tables |
| `st.table` | Static display, no interaction needed |
| `st.metric` | KPIs with delta indicators |
| `st.json` | Structured data inspection |

## DataFrames

```python
# Basic display
st.dataframe(df)

# With configuration
st.dataframe(
    df,
    height=400,
    width="stretch",
    hide_index=True,
)
```

### Column Configuration

Format and customize columns with `st.column_config`:

```python
st.dataframe(
    df,
    column_config={
        "price": st.column_config.NumberColumn(
            "Price",
            format="$%.2f",
        ),
        "rating": st.column_config.ProgressColumn(
            "Rating",
            min_value=0,
            max_value=5,
        ),
        "website": st.column_config.LinkColumn("Website"),
        "thumbnail": st.column_config.ImageColumn("Preview"),
        "date": st.column_config.DateColumn(
            "Date",
            format="DD/MM/YYYY",
        ),
    },
)
```

**Available column types:**
- `Column` - Generic column with label, width, help text
- `TextColumn` - Text with max chars, validation
- `NumberColumn` - Numbers with formatting, min/max
- `CheckboxColumn` - Boolean as checkbox
- `SelectboxColumn` - Single dropdown selection
- `MultiSelectColumn` - Multiple dropdown selections
- `DateColumn`, `TimeColumn`, `DatetimeColumn` - Temporal data
- `LinkColumn` - Clickable URLs
- `ImageColumn` - Display images from URLs
- `ListColumn` - Display Python lists
- `JsonColumn` - Display JSON/dict data
- `ProgressColumn` - Progress bars (0-1 or custom range)
- `BarChartColumn`, `LineChartColumn`, `AreaChartColumn` - Inline charts

### DataFrame Selection

Enable row/column selection and react to user picks:

```python
event = st.dataframe(
    df,
    key="orders",
    on_select="rerun",
    selection_mode="multi-row",  # Or "single-row"
)

if event and event.selection.rows:
    selected = df.iloc[event.selection.rows]
    st.write(selected)
```

## Data Editor

For editable tables:

```python
edited_df = st.data_editor(
    df,
    num_rows="dynamic",  # Allow adding/deleting rows
    key="editor",
)

# Access edit details via session state
if "editor" in st.session_state:
    changes = st.session_state.editor
    # changes contains: edited_rows, added_rows, deleted_rows
```

**Restrict editing:**

```python
st.data_editor(
    df,
    disabled=["id", "created_at"],  # Read-only columns
    column_config={
        "status": st.column_config.SelectboxColumn(
            "Status",
            options=["pending", "approved", "rejected"],
        ),
    },
)
```

## Metrics

Display KPIs with change indicators:

```python
col1, col2, col3 = st.columns(3)

col1.metric("Revenue", "$1.2M", "+12%")
col2.metric("Users", "5,432", "-3%", delta_color="inverse")
col3.metric("Conversion", "2.4%", "0.1%")
```

**delta_color options:**
- `"normal"` (default): Green for positive, red for negative
- `"inverse"`: Red for positive, green for negative
- `"off"`: No color

## Charts

### Built-in Charts (Quick & Simple)

```python
# Line chart
st.line_chart(df, x="date", y=["revenue", "costs"])

# Bar chart
st.bar_chart(df, x="category", y="count")

# Area chart
st.area_chart(df, x="date", y="value")

# Scatter plot
st.scatter_chart(df, x="x", y="y", color="category", size="value")
```

### Altair (Declarative, Flexible)

```python
import altair as alt

chart = alt.Chart(df).mark_line().encode(
    x="date:T",
    y="value:Q",
    color="category:N",
)
st.altair_chart(chart, width="stretch")
```

### Plotly (Interactive)

```python
import plotly.express as px

fig = px.scatter(df, x="x", y="y", color="category", hover_data=["name"])
st.plotly_chart(fig, width="stretch")
```

## Large Datasets

### Pagination Pattern

```python
PAGE_SIZE = 100

if "page" not in st.session_state:
    st.session_state.page = 0

total_pages = (len(df) + PAGE_SIZE - 1) // PAGE_SIZE

col1, col2, col3 = st.columns([1, 2, 1])
with col1:
    if st.button("Previous") and st.session_state.page > 0:
        st.session_state.page -= 1
with col3:
    if st.button("Next") and st.session_state.page < total_pages - 1:
        st.session_state.page += 1

start = st.session_state.page * PAGE_SIZE
st.dataframe(df.iloc[start:start + PAGE_SIZE])
```

### Server-side Filtering

```python
@st.cache_data
def load_filtered(category: str, limit: int = 1000):
    return db.query(f"SELECT * FROM data WHERE category = '{category}' LIMIT {limit}")

category = st.selectbox("Category", categories)
df = load_filtered(category)
st.dataframe(df)
```

## Timezone Handling

Streamlit displays datetime values exactly as provided (no auto-conversion to user's timezone):

```python
# Naive datetime - displays without timezone info
df["date"] = pd.to_datetime(df["date"])

# Timezone-aware - displays with timezone suffix
df["date"] = pd.to_datetime(df["date"]).dt.tz_localize("UTC")
```

## JSON Display

```python
# Expandable JSON
st.json(data, expanded=False)

# Expanded by default
st.json(data, expanded=True)

# Expand to specific depth
st.json(data, expanded=2)
```

## Reference

- [Data elements docs](https://docs.streamlit.io/develop/api-reference/data)
- [Chart elements docs](https://docs.streamlit.io/develop/api-reference/charts)
- [Column configuration docs](https://docs.streamlit.io/develop/api-reference/data/st.column_config)
