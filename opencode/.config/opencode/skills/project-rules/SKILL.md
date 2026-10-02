---
name: project-rules
description: Bootstrap or update a project's rules at the start of a project. It detects the stack (language, package manager, formatter, linter, type checker, test command), asks only for what it cannot detect, writes CODE_STYLE.md, and registers it in AGENTS.md so every later session follows it. Use when the user says "define project rules", "set up code style", "set up the stack", "bootstrap project conventions", "define the technologies for this project", or "configure the linter and tests for this repo". Use at the start of a project, or when a repo has no code-style file yet. Do not use for one-off style questions or for editing application code.
---

# Project Rules

Turn a project's conventions into one committed file that agents and humans read on every session. The file records the stack and the enforceable rules. It does not describe the application.

## Scope

This skill writes and updates `CODE_STYLE.md` at the repository root, plus one pointer block in `AGENTS.md`. It does not edit application code, tests, or CI. It does not install tools.

## Workflow

### Step 1: Detect the stack

Read the repository. Do not guess a value you can read.

| Field | Look for |
|---|---|
| Language and version | `pyproject.toml`, `setup.cfg`, `.python-version`, `runtime.txt` |
| Package manager | `poetry.lock`, `uv.lock`, `Pipfile`, `requirements.txt`, `setup.py` |
| Formatter | `[tool.black]`, `[tool.ruff.format]`, `.pre-commit-config.yaml` |
| Linter | `[tool.ruff]`, `.flake8`, `.pylintrc` |
| Type checker | `[tool.mypy]`, `[tool.pyright]`, `mypy.ini` |
| Test command | `[tool.pytest.ini_options]`, `tox.ini`, `noxfile.py`, `Makefile`, CI config |
| CI | `.github/workflows/`, `.gitlab-ci.yml` |

Use [references/presets.md](references/presets.md) for the per-language detection rules. Python is the only preset shipped today. Add a new preset block there when the project uses another language; do not change this file.

### Step 2: Ask only for what is missing

For every field the detection did not resolve, ask the user one short question. Accept "none" as an answer (for example, no type checker). Never invent a command.

### Step 3: Write CODE_STYLE.md

Render [references/template.md](references/template.md) with the detected and confirmed values. Write the file at the repository root.

Wrap the generated body between these markers:

```
<!-- project-rules:start -->
...
<!-- project-rules:end -->
```

On a later run, replace only the block between the markers. Keep any manual content above the start marker or below the end marker. If the file exists without markers, show the user the diff and confirm before you overwrite.

### Step 4: Register in AGENTS.md

If `AGENTS.md` does not exist, create it. Add this block, once:

```
## Project rules

Follow [CODE_STYLE.md](CODE_STYLE.md) for the stack, conventions, and commands. Apply it to every change.
```

If the block is already present, leave it. Do not rewrite the rest of `AGENTS.md`.

### Step 5: Verify and report

1. Run each command with `--version` or `--help` to confirm it exists (for example `pytest --version`). Report a missing command instead of writing it as if it worked.
2. Show the final `CODE_STYLE.md` and the `AGENTS.md` pointer.
3. Report the test command, the linter, and the formatter in one line each.

## Guards

- Never invent a command, a version, or a tool. Ask when detection fails.
- Preserve manual edits outside the markers.
- Keep `CODE_STYLE.md` short. It is read on every session.
- Change the smallest span that fixes a rule. Do not restyle the project file beyond the generated block.
- If the project already complies, report that and change nothing.

## Design principles to embed

The generated `Code style` section distills these rules. Keep them:

- Functions 4 to 20 lines. Files under 500 lines.
- One thing per function, one responsibility per module.
- Names specific and unique. Avoid `data`, `handler`, `Manager`.
- Types explicit. No untyped public functions.
- No duplication. Extract shared logic.
- Early returns over nested conditionals. Two levels of indentation at most.
- Exception messages carry the offending value and the expected shape.
