---
name: streamlit-charts-and-data
description: Streamlit charts and data display patterns. Use when displaying charts, dataframes, or metrics. Covers native charts, Altair, column configuration, and sparklines in metrics.
license: Apache-2.0
---

# Streamlit Charts & Data

Present data clearly.

## Native Charts First

Prefer Streamlit's native charts for simple cases.

```python
st.line_chart(df, x="date", y="revenue", x_label="Date", y_label="Revenue")
st.bar_chart(df, x="category", y="count", x_label="Category", y_label="Count")
st.scatter_chart(df, x="age", y="salary", x_label="Age", y_label="Salary")
st.area_chart(df, x="date", y="value", x_label="Date", y_label="Value")
```

## Human-Readable Labels

Always use clear labels—not column names or abbreviations.

```python
# BAD
st.line_chart(df, x="dt", y="rev")

# GOOD
st.line_chart(df, x="date", y="revenue", x_label="Date", y_label="Revenue")
```

## Altair for Complex Charts

Use Altair when you need more control.

```python
import altair as alt

chart = alt.Chart(df).mark_line().encode(
    x=alt.X("date:T", title="Date"),
    y=alt.Y("revenue:Q", title="Revenue ($)"),
    color="region:N"
)
st.altair_chart(chart, width="stretch")
```

**When to use Altair:**
- Custom axis formatting
- Multiple series with legends
- Interactive tooltips
- Layered visualizations

## Dataframe Column Configuration

**Always use `column_config`** to make dataframes readable. Raw dataframes with cryptic column names and unformatted numbers look unprofessional.

```python
st.dataframe(
    df,
    column_config={
        "revenue": st.column_config.NumberColumn(
            "Revenue",
            format="$%.2f"
        ),
        "completion": st.column_config.ProgressColumn(
            "Progress",
            min_value=0,
            max_value=100
        ),
        "url": st.column_config.LinkColumn("Website"),
        "logo": st.column_config.ImageColumn("Logo"),
        "created_at": st.column_config.DatetimeColumn(
            "Created",
            format="MMM DD, YYYY"
        ),
        "internal_id": None,  # Hide non-essential columns
    },
    hide_index=True,
    use_container_width=True,
)
```

**Note on hiding columns:** Setting a column to `None` hides it from the UI, but the data is still sent to the frontend. For truly sensitive data, pre-filter the DataFrame before displaying.

**Dataframe best practices:**
- **Always hide useless index:** `hide_index=True`
- **Or make index meaningful:** `df = df.set_index("customer_name")` before displaying
- **Use human-readable column labels:** `"rev"` → `"Revenue"`
- **Hide internal/technical columns:** Set column to `None` in config (but pre-filter for sensitive data)
- **Use dedicated column types:** Numbers, dates, links, images, progress bars, sparklines

**Column types:**
- `NumberColumn` → Numbers with formatting
- `ProgressColumn` → Progress bars
- `LinkColumn` → Clickable links
- `ImageColumn` → Images
- `DatetimeColumn` → Dates with formatting
- `DateColumn` → Date only (no time)
- `TimeColumn` → Time only (no date)
- `CheckboxColumn` → Boolean as checkbox
- `SelectboxColumn` → Editable dropdown
- `LineChartColumn` → Sparkline charts
- `BarChartColumn` → Bar sparklines
- `AreaChartColumn` → Area sparklines
- `ListColumn` → Display lists/arrays
- `JSONColumn` → Display JSON objects
- `MultiselectColumn` → Multi-value selection
- `TextColumn(pinned=True)` → Sticky column that stays visible when scrolling

## Pinned Columns

Keep important columns visible while scrolling horizontally:

```python
st.dataframe(
    df,
    column_config={
        "Title": st.column_config.TextColumn(pinned=True),  # Always visible
        "Rating": st.column_config.ProgressColumn(min_value=0, max_value=10),
    },
    hide_index=True,
)
```

## Sparklines in Metrics

Add `chart_data` and `chart_type` to metrics for visual context.

```python
values = [700, 720, 715, 740, 762, 755, 780]

st.metric(
    label="Developers",
    value="762k",
    delta="-7.42% (MoM)",
    delta_color="inverse",
    chart_data=values,
    chart_type="line"  # or "bar"
)
```

**Note:** Sparklines only show y-values and ignore x-axis spacing. Use them for evenly-spaced data (like daily or weekly snapshots). For irregularly-spaced time series, use a proper chart instead.

## Dashboard Layout

Use horizontal containers for responsive dashboard cards:

```python
with st.container(horizontal=True):
    st.metric(
        "Revenue",
        "$1.2M",
        "-7%",
        border=True,
        chart_data=data,
        chart_type="line",
    )
    st.metric(
        "Users",
        "762k",
        "+12%",
        border=True,
        chart_data=data,
        chart_type="line",
    )
    st.metric(
        "Orders",
        "1.4k",
        "+5%",
        border=True,
        chart_data=data,
        chart_type="bar",
    )
```

This is preferred over `st.columns` because horizontal containers are more responsive on different screen sizes.

Alternative with columns (less responsive):
```python
cols = st.columns(4)
for col, (label, value, delta, data) in zip(cols, metrics):
    with col:
        st.metric(label, value, delta, border=True, chart_data=data, chart_type="line")
```

## References

- [st.dataframe](https://docs.streamlit.io/develop/api-reference/data/st.dataframe)
- [st.column_config](https://docs.streamlit.io/develop/api-reference/data/st.column_config)
- [st.metric](https://docs.streamlit.io/develop/api-reference/data/st.metric)
- [st.line_chart](https://docs.streamlit.io/develop/api-reference/charts/st.line_chart)
- [st.bar_chart](https://docs.streamlit.io/develop/api-reference/charts/st.bar_chart)
- [st.altair_chart](https://docs.streamlit.io/develop/api-reference/charts/st.altair_chart)
