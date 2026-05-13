"""End-to-end tests for developing-with-streamlit/scripts/discover.py.

Each test exercises one environment shape from the meta-skill's documented
priority order, or one of the fallback codepaths. Cross-platform: tests use
stdlib `venv`, `pathlib`, and `subprocess` so the same test code runs on
Linux, macOS, and Windows.

Conventions:
- Each test creates a fresh project / venv via the `tmp_path` fixture (pytest
  guarantees isolation between tests).
- `run_discover` scrubs VIRTUAL_ENV / CONDA_PREFIX from the inherited env by
  default, so tests don't see runner leakage.
- Tests that depend on third-party tools (uv, pipenv) use pytest's skip
  marker if the tool isn't installed.
"""
from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

import pytest

from conftest import (
    DISCOVER_PY,
    assert_resolves_bundled,
    make_venv,
    run_discover,
    tool_works,
    venv_python,
)


# --- Detection priority (1-6) -----------------------------------------------


def test_active_venv(tmp_path: Path) -> None:
    """Priority 1: $VIRTUAL_ENV points at a venv with Streamlit installed."""
    venv_root = tmp_path / "active"
    make_venv(venv_root, packages=["streamlit"])
    work = tmp_path / "work"
    work.mkdir()

    result = run_discover(cwd=work, extra_env={"VIRTUAL_ENV": str(venv_root)})
    assert_resolves_bundled(result, "active_venv", inside=venv_root)


def test_local_dotvenv(tmp_path: Path) -> None:
    """Priority 2: ./.venv exists, $VIRTUAL_ENV unset."""
    project = tmp_path / "project"
    project.mkdir()
    venv_root = project / ".venv"
    make_venv(venv_root, packages=["streamlit"])

    result = run_discover(cwd=project)
    assert_resolves_bundled(result, "local_dotvenv", inside=venv_root)


def test_parent_dotvenv(tmp_path: Path) -> None:
    """Priority 3: ../.venv exists; cwd is a child directory."""
    parent = tmp_path / "parent"
    parent.mkdir()
    venv_root = parent / ".venv"
    make_venv(venv_root, packages=["streamlit"])
    project = parent / "project"
    project.mkdir()

    result = run_discover(cwd=project)
    assert_resolves_bundled(result, "parent_dotvenv", inside=venv_root)


def test_conda_prefix_detection(tmp_path: Path) -> None:
    """Priority 4: $CONDA_PREFIX is honored.

    Uses a stdlib venv as a stand-in for a conda env. Conda envs are
    structurally identical to venvs (bin/python on POSIX, Scripts/python.exe
    on Windows), so testing the env-var lookup with a venv exercises the same
    discover.py code path. Skipping the conda-binary roundtrip lets this
    test run on every CI runner without needing miniconda installed.
    """
    env_root = tmp_path / "conda-env-stand-in"
    make_venv(env_root, packages=["streamlit"])
    project = tmp_path / "project"
    project.mkdir()

    result = run_discover(cwd=project, extra_env={"CONDA_PREFIX": str(env_root)})
    assert_resolves_bundled(result, "conda_prefix", inside=env_root)


@pytest.mark.skipif(
    not tool_works("uv"),
    reason="uv not available on this runner",
)
def test_uv_with_lockfile(tmp_path: Path) -> None:
    """Priority 6: uv.lock present and uv installed → uv branch fires."""
    project = tmp_path / "project"
    project.mkdir()
    subprocess.run(
        ["uv", "init", "--quiet", "--no-workspace", str(project)],
        check=True,
    )
    subprocess.run(
        ["uv", "add", "--quiet", "--directory", str(project), "streamlit"],
        check=True,
    )
    # Remove the .venv uv created so we exercise the "uv branch wins" path
    # rather than the ./.venv (priority 2) path.
    venv_dir = project / ".venv"
    if venv_dir.exists():
        shutil.rmtree(venv_dir)

    assert (project / "uv.lock").is_file(), "test setup error: uv.lock should exist"
    result = run_discover(cwd=project)
    # uv recreates a venv on demand at .venv when invoked; assert the
    # resolved path lives there (not in some unrelated install).
    assert_resolves_bundled(result, "uv_with_lockfile", inside=project / ".venv")


def test_system_python(tmp_path: Path) -> None:
    """Priority 7: no venv, no conda, no uv markers → system Python.

    We can't test the "real" system Python directly (the runner may or may
    not have streamlit installed system-wide). Instead we install Streamlit
    into a fresh venv, point the script at it via VIRTUAL_ENV, and verify
    the import succeeds. The branch this exercises is the same one taken
    when the priority chain falls through — `import streamlit` resolves to
    a real install.
    """
    venv_root = tmp_path / "system-py-stand-in"
    make_venv(venv_root, packages=["streamlit"])
    project = tmp_path / "project"
    project.mkdir()

    # Use VIRTUAL_ENV so the test is deterministic regardless of what the
    # runner's actual `python3` has installed.
    result = run_discover(cwd=project, extra_env={"VIRTUAL_ENV": str(venv_root)})
    assert_resolves_bundled(result, "system_python", inside=venv_root)


# --- Priority conflict ------------------------------------------------------


def test_priority_venv_over_local(tmp_path: Path) -> None:
    """$VIRTUAL_ENV (with Streamlit) must win over ./.venv (without).

    If priority order regressed and ./.venv won, the import would fail.
    """
    project = tmp_path / "project"
    project.mkdir()
    venv_a = project / "venv-a"
    make_venv(venv_a, packages=["streamlit"])
    make_venv(project / ".venv")  # no streamlit

    result = run_discover(cwd=project, extra_env={"VIRTUAL_ENV": str(venv_a)})
    assert_resolves_bundled(result, "priority_venv_over_local", inside=venv_a)


# --- Argument handling ------------------------------------------------------


def test_project_dir_argument(tmp_path: Path) -> None:
    """--project-dir overrides cwd: invoked from elsewhere, resolves project's .venv."""
    user_project = tmp_path / "user-project"
    user_project.mkdir()
    project_venv = user_project / ".venv"
    make_venv(project_venv, packages=["streamlit"])

    elsewhere = tmp_path / "agent-cwd"
    elsewhere.mkdir()

    result = run_discover(cwd=elsewhere, project_dir=user_project)
    assert_resolves_bundled(result, "project_dir_argument", inside=project_venv)


# --- Fallback codepaths -----------------------------------------------------


def test_streamlit_missing(tmp_path: Path) -> None:
    """Detected interpreter has no Streamlit. Expect exit 1 + install hints.

    Critically: assert that the error reports the venv's python as the
    detected interpreter — closes the gap where this could pass via fallthrough
    to a (also streamlit-less) system Python instead of actually exercising
    VIRTUAL_ENV detection.
    """
    venv_root = tmp_path / "empty-venv"
    py = make_venv(venv_root)  # no packages
    project = tmp_path / "project"
    project.mkdir()

    result = run_discover(cwd=project, extra_env={"VIRTUAL_ENV": str(venv_root)})
    assert result.returncode == 1, (
        f"expected exit 1, got {result.returncode}\nstderr: {result.stderr}"
    )
    assert "Streamlit is not installed" in result.stderr
    assert "pip install streamlit" in result.stderr
    assert str(py) in result.stderr, (
        "expected VIRTUAL_ENV's python in error; got fallthrough to a different interpreter"
    )


def test_streamlit_pre_1_57(tmp_path: Path) -> None:
    """Streamlit installed but predates bundled skills. Expect exit 2 + upgrade hint + llms-full.txt."""
    venv_root = tmp_path / "old-streamlit"
    make_venv(venv_root, packages=["streamlit==1.56.0"])
    project = tmp_path / "project"
    project.mkdir()

    result = run_discover(cwd=project, extra_env={"VIRTUAL_ENV": str(venv_root)})
    assert result.returncode == 2, (
        f"expected exit 2, got {result.returncode}\nstderr: {result.stderr}"
    )
    assert "predates bundled skills" in result.stderr
    assert "pip install --upgrade streamlit" in result.stderr
    assert "docs.streamlit.io/llms-full.txt" in result.stderr


def test_upstream_restructured(tmp_path: Path) -> None:
    """Bundled skills dir exists but expected sub-path missing: exit 4 + listing."""
    venv_root = tmp_path / "venv"
    py = make_venv(venv_root, packages=["streamlit"])

    # Find the bundled skill dir and rename it to simulate upstream moving it.
    streamlit_path = subprocess.check_output(
        [str(py), "-c", "import streamlit, os; print(os.path.dirname(streamlit.__file__))"],
        text=True,
    ).strip()
    src = Path(streamlit_path) / ".agents" / "skills" / "developing-with-streamlit"
    dst = Path(streamlit_path) / ".agents" / "skills" / "streamlit-development-renamed"
    src.rename(dst)

    project = tmp_path / "project"
    project.mkdir()

    result = run_discover(cwd=project, extra_env={"VIRTUAL_ENV": str(venv_root)})
    assert result.returncode == 4, (
        f"expected exit 4, got {result.returncode}\nstderr: {result.stderr}"
    )
    assert "upstream Streamlit reorganized" in result.stderr
    assert "Available entries:" in result.stderr
    assert "streamlit-development-renamed" in result.stderr


# --- Pipenv / Poetry / PDM detection ---------------------------------------


@pytest.mark.skipif(
    not tool_works("pipenv"),
    reason="pipenv not available on this runner",
)
def test_pipenv(tmp_path: Path) -> None:
    """Pipfile present, pipenv installed, streamlit installed via pipenv (default out-of-project venv)."""
    project = tmp_path / "project"
    project.mkdir()

    # Default pipenv behavior: venv lives in ~/.local/share/virtualenvs/, not in project.
    env = os.environ.copy()
    env.pop("PIPENV_VENV_IN_PROJECT", None)
    subprocess.run(
        ["pipenv", "install", "--quiet", "streamlit"],
        cwd=str(project),
        env=env,
        check=True,
    )

    assert not (project / ".venv").exists(), (
        "test setup error: pipenv unexpectedly created .venv in project"
    )
    assert (project / "Pipfile").is_file()

    # Resolve where pipenv put its venv so we can assert the discovered path
    # actually came from there (rather than some unrelated streamlit install).
    pipenv_venv = subprocess.check_output(
        ["pipenv", "--venv"],
        cwd=str(project),
        env=env,
        text=True,
    ).strip()

    result = run_discover(cwd=project)
    assert_resolves_bundled(result, "pipenv", inside=Path(pipenv_venv))


@pytest.mark.skipif(
    not tool_works("poetry"),
    reason="poetry not available on this runner",
)
def test_poetry(tmp_path: Path) -> None:
    """poetry.lock + poetry installed: poetry branch fires."""
    project = tmp_path / "project"
    project.mkdir()

    # Disable poetry's interactive-init prompts.
    env = os.environ.copy()
    env["POETRY_NO_INTERACTION"] = "1"

    # Create a minimal poetry project: poetry init + poetry add streamlit.
    subprocess.run(
        ["poetry", "init", "--no-interaction",
         "--name", "test-poetry-project",
         "--python", ">=3.10"],
        cwd=str(project),
        env=env,
        check=True,
    )
    subprocess.run(
        ["poetry", "add", "--quiet", "streamlit"],
        cwd=str(project),
        env=env,
        check=True,
    )

    assert (project / "poetry.lock").is_file(), "test setup error: poetry.lock missing"

    poetry_venv = subprocess.check_output(
        ["poetry", "env", "info", "--path"],
        cwd=str(project),
        env=env,
        text=True,
    ).strip()

    result = run_discover(cwd=project)
    assert_resolves_bundled(result, "poetry", inside=Path(poetry_venv))


@pytest.mark.skipif(
    not tool_works("pdm"),
    reason="pdm not available on this runner",
)
def test_pdm(tmp_path: Path) -> None:
    """pdm.lock + pdm installed: pdm branch fires."""
    project = tmp_path / "project"
    project.mkdir()

    subprocess.run(
        ["pdm", "init", "--non-interactive", "--python", "python", "minimal"],
        cwd=str(project),
        check=True,
    )
    subprocess.run(
        ["pdm", "add", "--quiet", "streamlit"],
        cwd=str(project),
        check=True,
    )

    assert (project / "pdm.lock").is_file(), "test setup error: pdm.lock missing"

    pdm_venv = subprocess.check_output(
        ["pdm", "venv", "--path", "in-project"],
        cwd=str(project),
        text=True,
    ).strip()

    result = run_discover(cwd=project)
    assert_resolves_bundled(result, "pdm", inside=Path(pdm_venv))


# --- git-root .venv detection ----------------------------------------------


def test_git_root_dotvenv(tmp_path: Path) -> None:
    """`.venv` at the git repo root is found from a deep subdirectory.

    Helpful for monorepos: agent's --project-dir points deep, but the venv
    lives at repo root. The walk-up to .git + check-for-.venv covers this.
    """
    repo_root = tmp_path / "repo"
    repo_root.mkdir()
    (repo_root / ".git").mkdir()  # bare marker — we don't need a real git repo
    venv_root = repo_root / ".venv"
    make_venv(venv_root, packages=["streamlit"])

    # cwd is two levels deep — beyond what ./.venv and ../.venv can reach.
    deep = repo_root / "packages" / "feature"
    deep.mkdir(parents=True)

    result = run_discover(cwd=deep)
    assert_resolves_bundled(result, "git_root_dotvenv", inside=venv_root)


# --- uv branch disambiguation ----------------------------------------------


@pytest.mark.skipif(
    not tool_works("uv"),
    reason="uv not available on this runner",
)
def test_uv_no_lockfile(tmp_path: Path) -> None:
    """uv installed, pyproject.toml present, NO uv.lock: uv branch should NOT fire.

    Regression marker: if someone reverts the uv.lock guard, the error
    message lists `uv run` as the interpreter. With the fix, it lists
    a system Python (`python` or `python3`).
    """
    project = tmp_path / "project"
    project.mkdir()
    (project / "pyproject.toml").write_text(
        '[project]\nname = "not-a-uv-project"\nversion = "0.1.0"\n'
    )
    assert not (project / "uv.lock").exists()

    result = run_discover(cwd=project)
    assert result.returncode == 1, (
        f"expected exit 1 (no streamlit), got {result.returncode}\nstderr: {result.stderr}"
    )
    assert "Interpreter: uv run" not in result.stderr, (
        "uv branch misrouted on pyproject.toml without uv.lock"
    )
    # Interpreter should be a system Python — name varies (python / python3 /
    # python.exe / a path on Windows). Just confirm uv didn't win.
