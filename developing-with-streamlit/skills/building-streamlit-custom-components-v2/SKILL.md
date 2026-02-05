---
name: building-streamlit-custom-components-v2
description: Builds bidirectional Streamlit Custom Components v2 (CCv2) using `st.components.v2.component`. Use when authoring inline HTML/CSS/JS components or packaged components (manifest `asset_dir`, js/css globs), wiring state/trigger callbacks, theming via `--st-*` CSS variables, or bundling with Vite / `component-template` v2.
license: Apache-2.0
compatibility: Requires Streamlit with Custom Components v2 (`st.components.v2`). Packaged components require Node.js + npm; examples use `uv` + `cookiecutter` for project generation and editable installs.
---

# Building Streamlit custom components v2

Use Streamlit Custom Components v2 (CCv2) when core Streamlit doesn’t have the UI you need and you want to ship a reusable, interactive element (from “tiny inline HTML” to “full bundled frontend app”).

## When to use

Activate when the user mentions any of:

- CCv2, Custom Components v2, “bidi component”, “component v2”
- `st.components.v2.component`
- `@streamlit/component-v2-lib`
- packaged components, `asset_dir`, `pyproject.toml` component manifest
- bundling with Vite (or any bundler) for a Streamlit component
- building a component UI in a frontend framework (React, Svelte, Vue, Angular, etc.)

## Quick decision: inline vs packaged

- **Inline strings**: fastest to start (single-file apps, spikes, demos). You pass raw `html`/`css`/`js` strings directly.
  Good when you can keep everything in one place and don’t need a build step.
- **Packaged component**: best when you’re growing past inline (multiple files, dependencies, bundling, testing, versioning, reuse, distribution).
  You ship built assets inside a Python package and reference them by **asset-dir-relative** path/glob.

Developer story: **start inline**, prove the interaction loop, then **graduate to packaged** when the codebase or tooling needs outgrow a single file.

## CCv2 model (what’s actually happening)

1. **Python registers** a component with `st.components.v2.component(...)` and gets back a **mount callable**.
2. The mount callable **mounts** the component in the app with `data=...`, layout (`width`, `height`), and optional `on_<key>_change` callbacks.
3. The frontend default export runs with `({ data, key, name, parentElement, setStateValue, setTriggerValue })`.
4. The component returns a **result object** whose attributes correspond to **state keys** and **trigger keys**.

## Best practice: wrap the mount callable in your own Python API

Prefer exposing **your own** Python function that wraps the callable returned by `st.components.v2.component(...)`.

This gives you a clean, stable API surface for end users (typed parameters, validation, friendly defaults) and keeps `data=...`, `default=...`, and callback wiring as an internal detail.

Important:

- Declare the component **once** (usually at module import time). Avoid defining and registering the component inside a function you call multiple times; you can accidentally re-register the component name and get confusing behavior.

References:

- `https://docs.streamlit.io/develop/api-reference/custom-components/st.components.v2.component`
- `https://docs.streamlit.io/develop/api-reference/custom-components/st.components.v2.types.bidicomponentcallable`

Example pattern:

```python
import streamlit as st
from collections.abc import Callable

_MY_COMPONENT = st.components.v2.component(
    "my_package.my_component",
    html="<div class='root'></div>",
    js="index-*.js",
    # css="index-*.css",
)


def my_component(
    label: str,
    *,
    key: str | None = None,
    on_value_change: Callable[[], None] | None = None,
    on_submitted_change: Callable[[], None] | None = None,
):
    # If you want result attributes to always exist, provide (even empty) callbacks.
    if on_value_change is None:
        on_value_change = lambda: None
    if on_submitted_change is None:
        on_submitted_change = lambda: None

    return _MY_COMPONENT(
        data={"label": label},
        key=key,
        on_value_change=on_value_change,
        on_submitted_change=on_submitted_change,
    )
```

## Inline quickstart (state + trigger)

This demonstrates the two core interaction models:

- `setStateValue(...)` for **persistent state**
- `setTriggerValue(...)` for **one-shot events**

```python
import streamlit as st

HTML = """
<label for="txt">Enter text</label>
<input id="txt" type="text" />
<button id="btn" type="button">Submit</button>
"""

CSS = """
label { margin-right: 0.5rem; }
input {
  border-radius: 0.5rem;
  padding: 0.4rem 0.6rem;
  border: 1px solid var(--st-border-color);
  background: var(--st-secondary-background-color);
  color: var(--st-text-color);
}
button {
  margin-left: 0.5rem;
  border-radius: 0.5rem;
  padding: 0.4rem 0.75rem;
  border: 1px solid var(--st-border-color);
  background: var(--st-secondary-background-color);
  color: var(--st-text-color);
}
button:hover { border-color: var(--st-primary-color); }
"""

JS = """
export default function (component) {
  const { data, parentElement, setStateValue, setTriggerValue } = component

  const input = parentElement.querySelector("#txt")
  const btn = parentElement.querySelector("#btn")
  if (!input || !btn) return

  const nextValue = (data && data.value) ?? ""
  if (input.value !== nextValue) input.value = nextValue

  input.oninput = (e) => {
    setStateValue("value", e.target.value)
  }

  btn.onclick = () => {
    setTriggerValue("submitted", input.value)
  }
}
"""

my_text_input = st.components.v2.component(
    "my_inline_text_input",
    html=HTML,
    css=CSS,
    js=JS,
)

KEY = "txt-1"
component_state = st.session_state.get(KEY, {})
value = component_state.get("value", "")

result = my_text_input(
    key=KEY,
    data={"value": value},
    default={"value": value},
    on_value_change=lambda: None,
    on_submitted_change=lambda: None,
)

st.write("value (state):", result.value)
st.write("submitted (trigger):", result.submitted)
```

Notes:

- **Inline JS/CSS should be multi-line**. CCv2 treats “path-like” strings as file references; a multi-line string is unambiguously inline content.
- Prefer querying under `parentElement` (not `document`) to avoid cross-instance leakage.

## State and triggers (how to think about keys)

- **State** (`setStateValue("value", ...)`): persists across app reruns.
- **Trigger** (`setTriggerValue("submitted", ...)`): one-rerun event (resets after the rerun).
- In Python, keys show up as attributes on the result: `result.value`, `result.submitted`, etc.
- If you mount with a `key=...`, Streamlit also makes the component’s **state** available in Session State under `st.session_state[key]` (a dict-like object). This enables programmatic reads/writes of persistent component state.
  - Triggers are transient and should be handled from the **return value** (`result`) instead.

Example (result vs Session State):

```python
import streamlit as st

result = my_component(
    "Label",
    key="my_comp",
    on_value_change=lambda: None,
    on_submitted_change=lambda: None,
)

st.write("result.value:", result.value)
st.write("result.submitted:", result.submitted)
st.write("session_state value:", st.session_state.get("my_comp", {}).get("value"))

if st.button("Set value programmatically"):
    st.session_state.setdefault("my_comp", {})["value"] = "Hello from Python"
    st.rerun()
```

### Default values and callbacks

- To set **default** state, pass `default={...}` **and** include a matching `on_<key>_change` callback parameter (it can be a no-op `lambda: None`).
- If you want the result to **always** include a given attribute, pass an `on_<key>_change` callback for that key (even if you don’t need to run code).

## Packaged components (template-first)

Use this when you want a distributable component package (multi-file frontend code, dependencies, bundling, tests, versioning, distribution).

Notes:

- The official Streamlit `component-template` v2 supports both **React + TypeScript (Vite)** and **Pure TypeScript (Vite)** (no React). CCv2 also works with **any frontend framework** (Svelte/Vue/Angular/etc.) as long as you compile to JavaScript and register the resulting JS/CSS assets.
- For type-safe frontend authoring, use TypeScript with `@streamlit/component-v2-lib` (npm: `https://www.npmjs.com/package/@streamlit/component-v2-lib`). Your TypeScript compiles to JS, but the package gives you **typed renderer args** and **typed state/data contracts** while developing.

### Best practice: always start from `component-template` v2

For packaged CCv2 components, **do not build the packaging/bundling setup from scratch**. Funnel the work through Streamlit’s official template so you inherit the correct defaults and avoid subtle manifest/asset shipping mistakes.

Generate a new CCv2 component project:

```bash
uvx --from cookiecutter cookiecutter gh:streamlit/component-template --directory cookiecutter/v2
```

If you have a local checkout (offline/airgapped), use a filesystem path instead of `gh:...`:

```bash
uvx --from cookiecutter cookiecutter /path/to/component-template --directory cookiecutter/v2
```

Then follow the generated project’s README for the dev loop and build steps. Treat the template as the source of truth for:

- where the CCv2 manifest lives (it must ship _inside_ the Python package)
- the `asset_dir` layout and where Vite writes outputs
- the `js="index-*.js"` registration pattern and hashed build hygiene

### Packaged component workflow (copy/paste checklist)

Use this when you’re debugging or deviating; it’s designed to prevent the common “built assets exist but Streamlit can’t load them” failure modes.

```
Packaged CCv2 checklist
- [ ] Generate project from `component-template` v2
- [ ] Editable install the Python package (`uv pip install -e .` or equivalent)
- [ ] Build frontend assets into the manifest’s `asset_dir` (template: `frontend/build/`)
- [ ] Verify `js=`/`css=` globs match exactly one file each under `asset_dir`
- [ ] Run the example app and confirm the component renders
- [ ] If something breaks: read `references/troubleshooting.md`, fix, rebuild, re-verify glob uniqueness
```

### Study official components (recommended)

If you want reference implementations maintained by Streamlit, start with:

- `https://github.com/streamlit/streamlit-pdf`
- `https://github.com/streamlit/streamlit-bokeh`

If you need the “why” or hit edge cases (globs, manifest discovery, editable installs), see:

- [references/packaged-components.md](references/packaged-components.md)

## Frontend renderer lifecycle (framework-agnostic)

Your frontend entrypoint is the **default export** function. A few rules keep components reliable across reruns and across multiple instances in the same app:

- Render under `parentElement` (not `document`) so instances don’t collide.
- If you create per-instance resources (React roots, observers, subscriptions), key them by `parentElement` (e.g. `WeakMap`) so multiple instances don’t overwrite each other.
- Return a cleanup function to tear down event listeners / UI roots / observers when Streamlit unmounts the component.

## Styling and theming

- Prefer **`isolate_styles=True`** (default). Your component runs in a shadow root and won’t leak styles into the app.
- Set `isolate_styles=False` only when you need global styling behavior (e.g. Tailwind, global font injection).
- Streamlit injects a broad set of `--st-*` theme CSS variables (colors, typography, chart palettes, radii, borders, etc.). **Highly recommended:** use these variables so your component automatically adapts to the user’s current Streamlit theme (light/dark/custom) without authoring separate theme variants. Start with the common ones (`--st-text-color`, `--st-primary-color`, `--st-secondary-background-color`) and refer to the full list when you need it:
  - [references/theme-css-variables.md](references/theme-css-variables.md)

## Troubleshooting and gotchas

Start here when something “should work” but doesn’t:

- [references/troubleshooting.md](references/troubleshooting.md)
