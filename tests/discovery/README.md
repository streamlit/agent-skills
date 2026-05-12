# Discovery tests

End-to-end tests for `developing-with-streamlit/scripts/discover.py`.

Each test exercises one environment shape from the meta-skill's documented
priority order, or one of the fallback codepaths. Tests are pytest-based,
stdlib-only (no third-party deps beyond `pytest` itself), and cross-platform
— the same source runs on Linux, macOS, and Windows.

## Layout

```
tests/discovery/
  conftest.py             # shared helpers: make_venv, run_discover, assert_resolves_bundled
  test_discovery.py       # all tests, ~12 functions covering 13 scenarios
  run-local.sh            # convenience wrapper around `pytest tests/discovery/`
  README.md
```

## Running locally

```bash
pip install pytest                              # one-time
bash tests/discovery/run-local.sh               # full suite
bash tests/discovery/run-local.sh -k pipenv     # pytest filter
bash tests/discovery/run-local.sh -x            # stop at first failure
```

Tests that need third-party tools (`uv`, `pipenv`, `conda`) skip cleanly when
those tools aren't installed — `pytest` reports them as `SKIPPED` rather than
errors. CI installs the tools explicitly so all tests run.

Each test takes ~5–15 seconds (most of which is `pip install streamlit` into
a fresh venv). A full local run is under 2 minutes.

## Running in CI

Triggered by `.github/workflows/test-discovery.yml` on PRs that touch
`developing-with-streamlit/**` or `tests/**`, on push to `main`, and weekly
via cron. Two OS jobs:

- **Linux** (`ubuntu-latest`): runs every test, including conda + pipenv + uv.
- **Windows** (`windows-latest`): runs every test, including conda + pipenv + uv.

Both jobs install the same toolchain (Python 3.12, pytest, uv, pipenv,
miniconda) before running the suite, so coverage is identical across OSes.

## What this catches

- Regressions in the priority order (e.g. `./.venv` silently winning over `$VIRTUAL_ENV`).
- Breakage when Streamlit upstream moves `.agents/skills/`.
- Broken fallback messages for missing Streamlit or pre-1.57 versions.
- Cross-platform regressions (Windows-specific path handling, `Scripts/python.exe` vs `bin/python`).
- `discover.py` bugs that wouldn't surface on the author's single machine.

## What this does NOT catch

- LLM misinterpretation of `SKILL.md` prose (Tier 2 / cold-start eval — out of scope).
- Bugs in the bundled sub-skills themselves (upstream repo's concern).
- Environment shapes we don't document: poetry-without-`.venv`, hatch-managed envs without activation, `pyenv-virtualenv` without activation.

## Adding a test

1. Add a function to `test_discovery.py`. Use the `tmp_path` fixture for an
   isolated working directory, and `make_venv()` / `run_discover()` from
   `conftest.py` for setup.
2. If the test depends on a tool that may not be installed, add
   `@pytest.mark.skipif(shutil.which("toolname") is None, reason="...")`.
3. CI matrix is OS-only (`ubuntu-latest`, `windows-latest`); pytest discovers
   new tests automatically — no workflow changes needed.
