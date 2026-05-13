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
  test_discovery.py       # all tests, 19 functions covering the documented matrix
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

Tests that need third-party tools (`uv`, `pipenv`, `poetry`, `pdm`, `conda`) skip
cleanly when those tools aren't installed — `pytest` reports them as `SKIPPED`
rather than errors. CI installs `uv`, `pipenv`, `poetry`, and `pdm` so those
tests run; `conda` is intentionally not installed on CI runners, so `test_conda`
is reported as `SKIPPED` there and only exercised locally.

Each test takes ~5–15 seconds (most of which is `pip install streamlit` into
a fresh venv). A full local run is under 2 minutes.

## Running in CI

Triggered by `.github/workflows/test-discovery.yml` on PRs that touch
`developing-with-streamlit/**` or `tests/**`, on push to `main`, and weekly
via cron. Two OS jobs:

- **Linux** (`ubuntu-latest`): runs the full suite; `test_conda` skips.
- **Windows** (`windows-latest`): runs the full suite; `test_conda` skips.

Both jobs install the same toolchain (Python 3.12, `pytest`, `uv`, `pipenv`,
`poetry`, `pdm`) before running the suite, so coverage is identical across
OSes. `conda` is deliberately not installed — its tests run locally on
machines that already have it.

## What this catches

- Regressions in the priority order (e.g. `./.venv` silently winning over `$VIRTUAL_ENV`).
- Breakage when Streamlit upstream moves `.agents/skills/`.
- Broken fallback messages for missing Streamlit or pre-1.57 versions.
- Cross-platform regressions (Windows-specific path handling, `Scripts/python.exe` vs `bin/python`).
- `discover.py` bugs that wouldn't surface on the author's single machine.

## What this does NOT catch

- LLM misinterpretation of `SKILL.md` prose (Tier 2 / cold-start eval — out of scope).
- Bugs in the bundled skills themselves (upstream repo's concern).
- Environment shapes we don't document: hatch-managed envs without activation, `pyenv-virtualenv` without activation.

## Adding a test

1. Add a function to `test_discovery.py`. Use the `tmp_path` fixture for an
   isolated working directory, and `make_venv()` / `run_discover()` from
   `conftest.py` for setup.
2. If the test depends on a tool that may not be installed, add
   `@pytest.mark.skipif(shutil.which("toolname") is None, reason="...")`.
3. CI matrix is OS-only (`ubuntu-latest`, `windows-latest`); pytest discovers
   new tests automatically — no workflow changes needed.
