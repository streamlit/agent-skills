# Discovery tests

Tier 1 tests for the `developing-with-streamlit` meta-skill. Each scenario
exercises one environment shape documented in the skill's priority order,
invokes `developing-with-streamlit/scripts/discover.sh`, and asserts the
observed stdout/stderr/exit-code matches the contract.

## Layout

```
tests/discovery/
  assert.sh             # shared assertion helpers + run_discover
  run-local.sh          # runs the matrix locally via docker
  scenarios/
    01-active-venv.sh
    02-local-dotvenv.sh
    03-parent-dotvenv.sh
    04-conda.sh                    # runs in continuumio/miniconda3
    05-uv.sh
    06-system-python.sh
    07-priority-venv-over-local.sh # priority conflict
    08-streamlit-missing.sh        # exit 1 fallback
    09-streamlit-pre-1.57.sh       # exit 2 fallback
```

## Running locally

```bash
bash tests/discovery/run-local.sh           # full matrix
bash tests/discovery/run-local.sh 04-conda  # single scenario
```

Requires Docker. Each scenario runs in a fresh container — no state leaks
between scenarios.

## Running in CI

Triggered by `.github/workflows/test-discovery.yml` on PRs that touch
`developing-with-streamlit/**` or `tests/**`, on pushes to `main`, and weekly
via cron. GitHub Actions runs each scenario as its own matrix job in the
documented image.

## Adding a scenario

1. Create `tests/discovery/scenarios/NN-name.sh`. Follow the same shape as the
   existing scripts: source `assert.sh`, set up the environment, call
   `run_discover`, assert.
2. Add the `(name, image)` pair to both `run-local.sh` and the matrix in
   `.github/workflows/test-discovery.yml`.
3. Use an existing assertion helper when possible; add one to `assert.sh` if a
   new outcome class is needed.

## What this catches

- Regressions in the priority order (e.g. `.venv` silently wins over `$VIRTUAL_ENV`).
- Breakage when Streamlit upstream moves `.agents/skills/`.
- Broken fallback messages for missing Streamlit or pre-1.57 versions.
- `discover.sh` bugs that wouldn't surface on the author's single machine.

## What this does NOT catch

- Agent misinterpretation of the SKILL.md prose (that's Tier 2, LLM-in-loop).
- Bugs in the bundled sub-skills themselves (upstream repo's concern).
- Environment shapes we don't document: pipenv, poetry-without-venv,
  pyenv-virtualenv, Windows.
