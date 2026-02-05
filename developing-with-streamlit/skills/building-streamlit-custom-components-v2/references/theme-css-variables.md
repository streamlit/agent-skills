## Streamlit theme CSS variables injected into CCv2 components

Streamlit injects a set of `--st-*` CSS custom properties into CCv2 components so you can match the app’s theme from within your component CSS (including when `isolate_styles=True` and you’re rendering inside a shadow root).

Use them like any CSS variable:

```css
.card {
  background: var(--st-secondary-background-color);
  color: var(--st-text-color);
  border: 1px solid var(--st-border-color);
  border-radius: var(--st-base-radius);
}
```

### Serialization rules (important)

These variables originate from Streamlit’s theme object and are serialized into strings:

- **Strings**: passed through (e.g. `--st-primary-color: #ff4b4b`).
- **Numbers**: stringified (e.g. `--st-base-font-weight: 400`).
- **Booleans**: become `"1"` or `"0"` (e.g. `--st-link-underline`).
- **Arrays**: become a comma-joined string (e.g. `--st-heading-font-sizes: 2.75rem,2.25rem,...`).
  - If you need individual items in JS, split on `","`.
- **Missing values (`null` / `undefined`)**: become `unset` so consumers fall back to initial/inherited CSS behavior.

### Exhaustive variable list (`--st-*`)

Below is the full set of theme variables exposed to components. The variable name is derived from the theme key by converting to kebab-case and prefixing with `--st-`.

#### Core colors and typography (theme config inputs)

- `--st-primary-color`
- `--st-background-color`
- `--st-secondary-background-color`
- `--st-text-color`
- `--st-link-color`
- `--st-link-underline` (boolean serialized to `"1"` / `"0"`)
- `--st-heading-font`
- `--st-code-font`
- `--st-font` (body font)

#### Radii and sizing

- `--st-base-radius`
- `--st-button-radius`
- `--st-base-font-size`
- `--st-base-font-weight` (number)
- `--st-code-font-weight` (number)
- `--st-code-font-size`

#### Heading sizes and weights

Arrays (comma-joined):

- `--st-heading-font-sizes` (array; typically 6 values for h1–h6)
- `--st-heading-font-weights` (array; typically 6 values for h1–h6)

Individual convenience variables:

- `--st-heading-font-size-1`
- `--st-heading-font-size-2`
- `--st-heading-font-size-3`
- `--st-heading-font-size-4`
- `--st-heading-font-size-5`
- `--st-heading-font-size-6`
- `--st-heading-font-weight-1` (number)
- `--st-heading-font-weight-2` (number)
- `--st-heading-font-weight-3` (number)
- `--st-heading-font-weight-4` (number)
- `--st-heading-font-weight-5` (number)
- `--st-heading-font-weight-6` (number)

#### Borders and dataframe colors

- `--st-border-color`
- `--st-dataframe-border-color`
- `--st-dataframe-header-background-color`
- `--st-widget-border-color`

#### Code styling

- `--st-code-background-color`
- `--st-code-text-color`

#### Chart palettes

Arrays (comma-joined):

- `--st-chart-categorical-colors`
- `--st-chart-sequential-colors`
- `--st-chart-diverging-colors`

#### Computed / derived values

- `--st-heading-color`
- `--st-border-color-light`

#### Color palette (semantic colors)

- `--st-red-color`
- `--st-orange-color`
- `--st-yellow-color`
- `--st-blue-color`
- `--st-green-color`
- `--st-violet-color`
- `--st-gray-color`

Background variants:

- `--st-red-background-color`
- `--st-orange-background-color`
- `--st-yellow-background-color`
- `--st-blue-background-color`
- `--st-green-background-color`
- `--st-violet-background-color`
- `--st-gray-background-color`

Text variants:

- `--st-red-text-color`
- `--st-orange-text-color`
- `--st-yellow-text-color`
- `--st-blue-text-color`
- `--st-green-text-color`
- `--st-violet-text-color`
- `--st-gray-text-color`
