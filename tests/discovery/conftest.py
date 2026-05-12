"""Shared test infrastructure for discover.py end-to-end tests.

Provides fixtures and helpers that abstract over POSIX/Windows differences
(venv layout, executable extensions, path separators) so the same test code
runs identically on Linux, macOS, and Windows.
"""
from __future__ import annotations

import os
import subprocess
import sys
import venv
from pathlib import Path
from typing import Mapping, Optional, Sequence

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
DISCOVER_PY = REPO_ROOT / "developing-with-streamlit" / "scripts" / "discover.py"


def venv_python(venv_root: Path) -> Path:
    """Return the venv's Python executable, cross-platform.

    Mirrors discover.py's find_venv_python so tests check the same paths
    the script does.
    """
    for candidate in (
        venv_root / "bin" / "python",
        venv_root / "Scripts" / "python.exe",
    ):
        if candidate.is_file():
            return candidate
    raise FileNotFoundError(f"No python executable found in venv at {venv_root}")


def make_venv(
    root: Path,
    packages: Optional[Sequence[str]] = None,
) -> Path:
    """Create a venv at `root`, optionally pip-install packages.

    Returns the path to the venv's Python executable.
    """
    venv.create(str(root), with_pip=True)
    py = venv_python(root)
    if packages:
        subprocess.run(
            [str(py), "-m", "pip", "install", "--quiet", *packages],
            check=True,
        )
    return py


def run_discover(
    *,
    cwd: Path,
    project_dir: Optional[Path] = None,
    extra_env: Optional[Mapping[str, str]] = None,
    clear_env: Sequence[str] = ("VIRTUAL_ENV", "CONDA_PREFIX"),
) -> subprocess.CompletedProcess:
    """Invoke discover.py with the test runner's Python and capture output.

    By default scrubs VIRTUAL_ENV and CONDA_PREFIX from inherited env so
    tests don't see leaked state from the runner. extra_env is applied on
    top so individual tests can set what they need.
    """
    cmd = [sys.executable, str(DISCOVER_PY)]
    if project_dir is not None:
        cmd.extend(["--project-dir", str(project_dir)])

    env = {k: v for k, v in os.environ.items() if k not in clear_env}
    if extra_env:
        env.update(extra_env)

    return subprocess.run(
        cmd,
        cwd=str(cwd),
        capture_output=True,
        text=True,
        env=env,
        timeout=120,
    )


def assert_resolves_bundled(
    result: subprocess.CompletedProcess,
    scenario: str,
    *,
    inside: Optional[Path] = None,
) -> Path:
    """Assert discover succeeded and returned a real bundled SKILL.md path.

    If `inside` is given, also assert the resolved path lives under that
    directory — closes the gap where a test could pass via a wrong-but-valid
    Streamlit install (e.g., a system-wide one) instead of the venv the test
    set up.
    """
    assert result.returncode == 0, (
        f"{scenario}: expected exit 0, got {result.returncode}\n"
        f"stdout: {result.stdout!r}\nstderr: {result.stderr!r}"
    )
    raw = result.stdout.strip()
    assert raw, f"{scenario}: expected stdout path, got empty"
    path = Path(raw)
    assert path.is_file(), f"{scenario}: stdout path does not exist: {path}"
    assert path.name == "SKILL.md", f"{scenario}: unexpected filename: {path.name}"
    assert path.parent.name == "developing-with-streamlit"
    assert path.parent.parent.name == "skills"
    assert path.parent.parent.parent.name == ".agents"
    if inside is not None:
        try:
            path.relative_to(inside.resolve())
        except ValueError:
            raise AssertionError(
                f"{scenario}: resolved path {path} is not inside expected venv {inside}"
            )
    return path


def tool_works(tool: str) -> bool:
    """Return True iff `tool` is on PATH AND a `--version` invocation succeeds.

    Just checking `shutil.which` isn't enough on machines where shims (e.g.
    pyenv) resolve to a Python that doesn't actually have the tool installed
    — those return a path but fail at runtime.
    """
    import shutil
    if shutil.which(tool) is None:
        return False
    try:
        result = subprocess.run(
            [tool, "--version"],
            capture_output=True,
            timeout=15,
        )
        return result.returncode == 0
    except (subprocess.TimeoutExpired, FileNotFoundError, OSError):
        return False
