---
name: streamlit-charts
description: Streamlit charts and data display patterns. Use when displaying charts, dataframes, or metrics. Covers native charts, Altair, column configuration, and sparklines in metrics.
license: Apache-2.0
---

# Streamlit Charts & Data

Present data clearly.

## Native Charts First

Prefer Streamlit's native charts for simple cases.

```python
st.line_chart(df, x="date", y="revenue")
st.bar_chart(df, x="category", y="count")
st.scatter_chart(df, x="age", y="salary")
st.area_chart(df, x="date", y="value")
```

## Human-Readable Labels

Always use clear labels—not column names or abbreviations.

```python
# BAD
st.line_chart(df, x="dt", y="rev")

# GOOD
st.line_chart(df, x="date", y="revenue")
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
st.altair_chart(chart, use_container_width=True)
```

**When to use Altair:**
- Custom axis formatting
- Multiple series with legends
- Interactive tooltips
- Layered visualizations

## Dataframe Column Configuration

Use `column_config` to format columns properly.

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
        )
    },
    hide_index=True,
    use_container_width=True
)
```

**Column types:**
- `NumberColumn` → Numbers with formatting
- `ProgressColumn` → Progress bars
- `LinkColumn` → Clickable links
- `ImageColumn` → Images
- `DatetimeColumn` → Dates with formatting
- `CheckboxColumn` → Boolean as checkbox
- `SelectboxColumn` → Editable dropdown

## Sparklines in Metrics

Add `chart_data` and `chart_type` to metrics for visual context.

```python
import numpy as np

values = np.random.randint(700, 800, size=28)

st.metric(
    label="Developers",
    value="762k",
    delta="-7.42% (MoM)",
    delta_color="inverse",
    chart_data=values,
    chart_type="line"  # or "bar"
)
```

## Dashboard Layout

Combine bordered containers with metrics:

```python
cols = st.columns(4)
for col, (label, value, delta, data) in zip(cols, metrics):
    with col:
        with st.container(border=True):
            st.metric(label, value, delta,
                      chart_data=data, chart_type="line")
```
