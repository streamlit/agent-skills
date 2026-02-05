---
name: building-streamlit-custom-components-v2
description: Builds Streamlit Custom Components v2 (CCv2). Use when authoring a bidirectional Streamlit component using `st.components.v2.component`, including inline HTML/CSS/JS prototypes and packaged components with `asset_dir` manifests (bundled JS/CSS assets, JS/CSS globs, TypeScript typings via `@streamlit/component-v2-lib`, state/trigger callbacks).
license: Apache-2.0
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

## Inline quickstart (HTML + JS trigger)

This is the quickest possible “frontend event → Python” component.

```python
import streamlit as st

HTML = """
<button id="btn" type="button">Click me</button>
"""

CSS = """
button {
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
  const { parentElement, setTriggerValue } = component

  const btn = parentElement.querySelector("#btn")
  if (!btn) return

  btn.onclick = () => {
    setTriggerValue("clicked", true)
  }
}
"""

my_button = st.components.v2.component(
    "my_inline_button",
    html=HTML,
    css=CSS,
    js=JS,
)

result = my_button(key="btn-1", on_clicked_change=lambda: None)
st.write("clicked:", bool(result.clicked))
```

Notes:

- **Inline JS/CSS should be multi-line**. CCv2 treats “path-like” strings as file references; a multi-line string is unambiguously inline content.
- Prefer querying under `parentElement` (not `document`) to avoid cross-instance leakage.

## State and triggers (how to think about keys)

- **State** (`setStateValue("value", ...)`): persists across app reruns.
- **Trigger** (`setTriggerValue("submit", ...)`): one-rerun event (resets after the rerun).
- In Python, keys show up as attributes on the result: `result.value`, `result.submit`, etc.

### Default values and callbacks

- To set **default** state, pass `default={...}` **and** include a matching `on_<key>_change` callback parameter (it can be a no-op `lambda: None`).
- If you want the result to **always** include a given attribute, pass an `on_<key>_change` callback for that key (even if you don’t need to run code).

## Packaged components (template-first)

Use this when you want a distributable component package (multi-file frontend code, dependencies, bundling, tests, versioning, distribution).

Notes:

- The official Streamlit template is set up for **React + Vite**, but CCv2 works with **any frontend framework** (Svelte/Vue/Angular/etc.) as long as you compile to JavaScript and register the resulting JS/CSS assets.
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

If you need the “why” or hit edge cases (globs, manifest discovery, editable installs), see:

- [references/packaged-components.md](references/packaged-components.md)

## React frontend entrypoint (CCv2 pattern)

React is a common choice (and the official template default). The same lifecycle principles apply to other frameworks: mount under `parentElement`, keep per-instance state keyed by `parentElement`, and return a cleanup function.

For React specifically, the reliable pattern is:

- Include a placeholder element in `html` (e.g. `<div class="react-root"></div>`).
- In your default export, mount React into that element.
- Use a `WeakMap` keyed by `parentElement` so multiple instances don’t collide.
- Return a cleanup function that unmounts.

See:

- [references/react-vite-entrypoint.md](references/react-vite-entrypoint.md)

## Styling and theming

- Prefer **`isolate_styles=True`** (default). Your component runs in a shadow root and won’t leak styles into the app.
- Set `isolate_styles=False` only when you need global styling behavior (e.g. Tailwind, global font injection).
- Streamlit injects a broad set of `--st-*` theme CSS variables (colors, typography, chart palettes, radii, borders, etc.). Start with the common ones (`--st-text-color`, `--st-primary-color`, `--st-secondary-background-color`) and refer to the full list when you need it:
  - [references/theme-css-variables.md](references/theme-css-variables.md)

## Troubleshooting and gotchas

Start here when something “should work” but doesn’t:

- [references/troubleshooting.md](references/troubleshooting.md)
