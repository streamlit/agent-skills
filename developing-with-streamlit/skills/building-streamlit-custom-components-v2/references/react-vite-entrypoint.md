## React + Vite CCv2 entrypoint pattern

This reference shows a proven CCv2 frontend entrypoint shape for React and a Vite config that plays nicely with Streamlit asset serving.

Even if you’re not using React, the same CCv2 lifecycle principles apply to other frameworks (Svelte/Vue/Angular/etc.): render under `parentElement`, keep per-instance resources keyed by `parentElement`, and return a cleanup function that tears down event listeners / UI roots on unmount.

### If you started from `component-template`

Streamlit’s official [component-template](https://github.com/streamlit/component-template) v2 already follows this pattern:

- placeholder HTML element in Python (e.g. `<div class="react-root"></div>`)
- `WeakMap` keyed by `parentElement` to support multiple instances
- cleanup function that unmounts

The template’s default build output style writes the main bundle directly under `frontend/build/` as `index-<hash>.js`, so the corresponding registration is typically:

```python
st.components.v2.component(
    "my-package.my_component",
    html="<div class='react-root'></div>",
    js="index-*.js",
    # css="index-*.css",
)
```

### Frontend entrypoint (React example)

Key points:

- Your CCv2 “entrypoint” is the **default export** function.
- Streamlit passes you `parentElement` (an `HTMLElement` or `ShadowRoot`).
- Use a `WeakMap` keyed by `parentElement` to support multiple instances.
- Return a cleanup function that unmounts.

```ts
import type { FrontendRenderer } from "@streamlit/component-v2-lib"
import React from "react"
import { createRoot, Root } from "react-dom/client"

type Data = { value: string }
type State = { submitted?: boolean }

const roots = new WeakMap<HTMLElement | ShadowRoot, Root>()

const ComponentEntry: FrontendRenderer<State, Data> = component => {
  const { data, parentElement, setTriggerValue } = component

  const rootEl = parentElement.querySelector(".react-root")
  if (!rootEl) throw new Error("React root element not found")

  let root = roots.get(parentElement)
  if (!root) {
    root = createRoot(rootEl)
    roots.set(parentElement, root)
  }

  root.render(
    <React.StrictMode>
      <button onClick={() => setTriggerValue("submitted", true)}>
        {data.value}
      </button>
    </React.StrictMode>
  )

  return () => {
    const root = roots.get(parentElement)
    if (root) {
      root.unmount()
      roots.delete(parentElement)
    }
  }
}

export default ComponentEntry
```

In Python, register with placeholder HTML:

```python
st.components.v2.component(
    "my-package.my_component",
    html="<div class='react-root'></div>",
    js="index-*.js",
    # If your build emits into a subdir, use e.g.:
    # js="assets/index-*.js"
    # css="assets/index-*.css"
)
```

### Vite build config (library-style output)

If you started from `component-template`, prefer keeping and iterating on the template’s `vite.config.ts` rather than copying a bespoke config. The example below is for cases where you’re _not_ using the template or you’re intentionally changing the output layout.

The key goals:

- Output into your `asset_dir` (e.g. `frontend/build`)
- Put the main bundle in a predictable glob target (e.g. `index-[hash].js` or `assets/index-[hash].js`)
- Use `base: "./"` so relative asset URLs work under Streamlit
- Keep CSS in a single file if you plan to load it via a single glob (`cssCodeSplit: false`)

```ts
import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';

export default defineConfig(() => ({
  base: './',
  plugins: [react()],
  build: {
    outDir: 'build',
    assetsDir: 'assets',
    cssCodeSplit: false,
    lib: {
      entry: 'src/index.tsx',
      formats: ['es'],
      fileName: () => 'assets/index-[hash].js',
    },
    rollupOptions: {
      output: {
        entryFileNames: 'assets/index-[hash].js',
        chunkFileNames: 'assets/chunk-[hash].js',
        assetFileNames: (assetInfo) => {
          const name = assetInfo.name || 'asset';
          if (name.endsWith('.css')) return 'assets/index-[hash][extname]';
          return 'assets/[name]-[hash][extname]';
        },
      },
    },
  },
}));
```

### Common mistakes

- **Multiple hashed outputs** left in `build/` ⇒ your `assets/index-*.js` glob matches multiple files.
- **Forgetting `base: "./"`** ⇒ assets may 404 when served from Streamlit’s component URL path.
- **CSS splitting on** while loading a single CSS glob ⇒ extra CSS files won’t load unless you explicitly include them.
