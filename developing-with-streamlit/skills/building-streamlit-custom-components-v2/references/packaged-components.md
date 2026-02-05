## Packaged CCv2 components (template-first)

For packaged CCv2 components, the best practice is to **avoid bespoke packaging/bundling setup** and instead funnel everything through Streamlit’s official template:

- [Streamlit component-template](https://github.com/streamlit/component-template)

Follow your generated project’s README. **Only keep reading if you need to debug template wiring or intentionally deviate from it.**

### Generate a new CCv2 component project

```bash
uvx --from cookiecutter cookiecutter gh:streamlit/component-template --directory cookiecutter/v2
```

Offline/airgapped:

```bash
uvx --from cookiecutter cookiecutter /path/to/component-template --directory cookiecutter/v2
```

### Dev loop (template default)

From the generated project:

1. Editable install (project root containing `pyproject.toml`):

   ```bash
   uv pip install -e . --force-reinstall
   ```

2. Watch-build the frontend (from `<import_name>/frontend`):

   ```bash
   npm i
   npm run dev
   ```

3. Run the example app:

   ```bash
   streamlit run <import_name>/example.py
   ```

### Template invariants (don’t break these)

You typically shouldn’t need to touch these, but they explain most “why won’t this load?” failures:

- **Component key**: the Python registration key must match the manifest: `"<project.name>.<component.name>"`.
- **Manifest must ship inside the Python package**: the template places a minimal CCv2 manifest at `<import_name>/pyproject.toml` with `asset_dir = "frontend/build"`.
- **Asset paths are asset-dir-relative strings**: `js="index-*.js"` (template default output) or `js="assets/index-*.js"` (if you configured an `assets/` subdir).
- **Globs must match exactly one file**: if `index-*.js` matches multiple hashed builds, clean the build output (`npm run clean`) and rebuild.

### If you intentionally deviate from the template

Keep the blast radius small:

- If you change output layout, update only the `js=`/`css=` asset-dir-relative globs in the Python wrapper.
- For Vite, keep `base: "./"` so relative URLs work when served from Streamlit’s component URLs.

