#!/usr/bin/env python3
"""Discover the Streamlit package's bundled agent-skills SKILL.md.

Usage:
    python scripts/discover.py [--project-dir PATH]

When --project-dir is given, the script resolves `.venv`, `../.venv`,
`pyproject.toml`, `uv.lock`, and `Pipfile` relative to that path (so its checks
land on the user's project rather than on the script's installed location).

Exit codes:
    0 - success; prints the absolute path to the bundled SKILL.md on stdout.
    1 - Streamlit is not installed in the detected interpreter.
    2 - Streamlit is installed but predates bundled skills (no .agents/skills/).
    3 - no usable Python interpreter was found.
    4 - .agents/skills/ exists but the expected developing-with-streamlit/SKILL.md
        is missing from the documented sub-path (likely upstream restructured).
        The agent should read the listed available skills directly.
    5 - invalid script argument.

On non-zero exit, a human-readable "ERROR:" block is printed on stderr.
"""
from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import List, Optional


def find_venv_python(venv_root: Path) -> Optional[Path]:
    """Return the venv's Python executable, cross-platform.

    POSIX venvs put it at bin/python; Windows venvs put it at Scripts/python.exe.
    """
    for candidate in (
        venv_root / "bin" / "python",
        venv_root / "Scripts" / "python.exe",
    ):
        if candidate.is_file():
            return candidate
    return None


def detect_interpreter(project_dir: Path) -> Optional[List[str]]:
    """Pick the right Python interpreter, in documented priority order.

    Returns the command as a list (for subprocess.run with shell=False).
    """
    venv = os.environ.get("VIRTUAL_ENV")
    if venv:
        py = find_venv_python(Path(venv))
        if py:
            return [str(py)]

    py = find_venv_python(project_dir / ".venv")
    if py:
        return [str(py)]

    py = find_venv_python(project_dir.parent / ".venv")
    if py:
        return [str(py)]

    conda = os.environ.get("CONDA_PREFIX")
    if conda:
        py = find_venv_python(Path(conda))
        if py:
            return [str(py)]

    if shutil.which("pipenv") and (project_dir / "Pipfile").is_file():
        return ["pipenv", "run", "python"]

    if shutil.which("uv") and (project_dir / "uv.lock").is_file():
        return ["uv", "run", "--quiet", "python"]

    for name in ("python3", "python"):
        if shutil.which(name):
            return [name]

    return None


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Discover the bundled developing-with-streamlit SKILL.md.",
    )
    parser.add_argument(
        "--project-dir",
        default=None,
        help="Absolute path to the user's project directory. Defaults to cwd.",
    )
    try:
        args = parser.parse_args()
    except SystemExit as e:
        return 5 if e.code else 0

    if args.project_dir is not None:
        project_dir = Path(args.project_dir)
        if not project_dir.is_dir():
            print(
                f"ERROR: --project-dir is not a directory: {project_dir}",
                file=sys.stderr,
            )
            return 5
    else:
        project_dir = Path.cwd()
    project_dir = project_dir.resolve()

    cmd = detect_interpreter(project_dir)
    if cmd is None:
        print(
            "ERROR: No Python interpreter found.\n"
            "Install Python 3.9+ and Streamlit (pip install streamlit), then re-run.",
            file=sys.stderr,
        )
        return 3

    py_display = " ".join(cmd)

    probe = "import streamlit; print(streamlit.__path__[0])"
    try:
        result = subprocess.run(
            [*cmd, "-c", probe],
            capture_output=True,
            text=True,
            cwd=project_dir,
            timeout=30,
        )
    except subprocess.TimeoutExpired:
        print(
            f"ERROR: import streamlit timed out (interpreter: {py_display})",
            file=sys.stderr,
        )
        return 1
    except FileNotFoundError:
        print(
            f"ERROR: detected interpreter not found on PATH: {py_display}",
            file=sys.stderr,
        )
        return 3

    if result.returncode != 0:
        combined = (result.stderr or "") + (result.stdout or "")
        if "ModuleNotFoundError" in combined:
            print(
                "ERROR: Streamlit is not installed in the detected Python environment.\n"
                f"Interpreter: {py_display}\n"
                "Install with the matching tool for your project:\n"
                "  pip install streamlit              # standard pip\n"
                "  uv add streamlit                   # uv\n"
                "  poetry add streamlit               # poetry\n"
                "  pipenv install streamlit           # pipenv\n"
                "  conda install -c conda-forge streamlit   # conda\n"
                "If your project uses conda, pyenv-virtualenv, pipenv, poetry, hatch, or pdm,\n"
                "ACTIVATE its environment first (conda activate <env>, pipenv shell,\n"
                "poetry shell, hatch shell, etc.) so the right Python is detected, then re-run.",
                file=sys.stderr,
            )
            return 1
        print(
            "ERROR: Failed to import streamlit.\n"
            f"Interpreter: {py_display}\n"
            "Output:\n"
            f"{combined}",
            file=sys.stderr,
        )
        return 1

    streamlit_path = Path(result.stdout.strip())
    agents_skills_dir = streamlit_path / ".agents" / "skills"
    primary_skill = agents_skills_dir / "developing-with-streamlit" / "SKILL.md"

    if primary_skill.is_file():
        print(primary_skill)
        return 0

    if agents_skills_dir.is_dir():
        print(
            "ERROR: Streamlit's bundled skills directory exists, but the expected\n"
            "developing-with-streamlit/SKILL.md is missing from the documented sub-path.\n"
            "This usually means upstream Streamlit reorganized the skill layout.\n"
            "\n"
            f"Streamlit path: {streamlit_path}\n"
            f"Bundled skills directory: {agents_skills_dir}\n"
            "Available entries:",
            file=sys.stderr,
        )
        for entry in sorted(agents_skills_dir.iterdir()):
            print(f"  {entry.name}", file=sys.stderr)
        print(
            "\n"
            "Read whichever sub-skill best matches the user's task. If none match,\n"
            "fall back to: https://docs.streamlit.io/llms-full.txt",
            file=sys.stderr,
        )
        return 4

    print(
        f"ERROR: Streamlit is installed but predates bundled skills (< 1.57).\n"
        f"Interpreter: {py_display}\n"
        f"Streamlit path: {streamlit_path}\n"
        "\n"
        "For best results, upgrade to get version-matched bundled skills:\n"
        "  pip install --upgrade streamlit\n"
        "\n"
        "If upgrading isn't an option, fall back to the online docs:\n"
        "  https://docs.streamlit.io/llms-full.txt",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
