# Language presets

Detection rules per language, and the values to put in `CODE_STYLE.md` when detection fails.

Python is the only preset shipped today. Add a new section for each new language. Keep one section per language, and keep the same column order.

## Adding a language

1. Copy the Python section below.
2. Replace the file markers, tools, and notes.
3. Add the language to the table in `SKILL.md` Step 1.
4. Do not touch the template. The template is language-neutral.

## Python

### Detection

| Field | Marker files | Config keys |
|---|---|---|
| Version | `.python-version`, `requires-python` in `pyproject.toml` | `project.requires-python` |
| Package manager | `poetry.lock`, `uv.lock`, `Pipfile`, `requirements.txt`, `setup.py` | first match wins, in that order |
| Formatter | `pyproject.toml` | `[tool.black]` or `[tool.ruff.format]` |
| Linter | `pyproject.toml`, `.flake8`, `.pylintrc` | `[tool.ruff]`, `[tool.flake8]` |
| Type checker | `pyproject.toml`, `mypy.ini` | `[tool.mypy]`, `[tool.pyright]` |
| Tests | `pyproject.toml`, `tox.ini`, `noxfile.py`, `Makefile` | `[tool.pytest.ini_options]` |

### Fallbacks

| Field | Fallback value |
|---|---|
| Package manager | ask the user |
| Formatter | `ruff format` |
| Linter | `ruff check` |
| Type checker | `mypy` |
| Tests | `pytest` |

### Notes to carry into the file

- Forbid `Any` and `Dict`. Use the built-in generics (`list[str]`, `dict[str, int]`).
- Require type annotations on public functions.
- Put the test command as a single line the user can copy.

### Example rendered values

- Stack: Python 3.12, uv, ruff format, ruff check, mypy, `pytest -q`.
