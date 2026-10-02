---
name: branch-conventions
description: Create a feature branch from an up-to-date base, with a name that follows the project convention. It reads the Branches section of CODE_STYLE.md, or infers the pattern from recent remote branches when the file has none. Use when the user says "create a branch", "start a feature branch", "new branch for this feature", "branch off main", or asks to begin work on a feature or fix. Do not use to commit, to push, or to open a pull request.
---

# Branch Conventions

Start every change on a dedicated branch, cut from an up-to-date base, with a predictable name.

This skill uses git only. It works with any host (GitHub, Gitea, GitLab).

## Step 1: Read the project convention

Read `CODE_STYLE.md` at the repository root. Use its `Branches` section for the format, the types, and the issue mode.

If the file or the section is absent, infer the pattern in Step 5.

## Step 2: Detect the base branch

The base is the repository default branch.

```bash
git symbolic-ref --short refs/remotes/origin/HEAD
git remote show origin | sed -n 's/.*HEAD branch: //p'
```

Fallback order: `main`, then `master`. If `gh` is available and the host is GitHub, `gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'` is also valid.

## Step 3: Sync the base

```bash
git fetch --prune
git switch <base>
git pull --ff-only
```

Do not branch from a stale base.

## Step 4: Check the working tree

```bash
git status --porcelain
```

If the output is not empty, warn the user and ask how to proceed before you continue.

## Step 5: Determine the name

Format:

```
<type>/[<issue>-]<slug>
```

- With an issue: `feat/123-magic-link-login`
- Without an issue: `feat/magic-link-login`

Ask for the type, the issue number (optional), and the slug.

Default types, aligned with the commit types:

`feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`, `ci`, `build`, `hotfix`

Issue mode from the `issue:` key in `CODE_STYLE.md`:

- `optional` (default): ask and accept an empty answer.
- `required`: refuse to create the branch without a number.
- `never`: do not use an issue number.

Name rules: lowercase, kebab-case, no spaces, at most 50 characters.

When the convention is absent, infer it from the latest remote branches:

```bash
git branch -r --sort=-committerdate | head -30
```

1. Ignore `main`, `master`, `develop`, `release`, and `HEAD` entries.
2. Detect the dominant pattern: the separator, the type prefixes in use, and any issue-key shape (`[A-Z]+-\d+` or `\d+`).
3. Propose the name that matches the pattern.
4. When no pattern is clear, fall back to `<type>/<slug>`.

## Step 6: Confirm and create

Show the proposed name and the base. After approval:

```bash
git switch -c <name>
```

Report the branch name and the base it came from.

## Guards

- Never create a branch that already exists locally or remotely.
- Never branch from a base that is behind the remote.
- Never force an issue number on the user.
- Never commit, push, or open a pull request from this skill.
- Do not invent a type outside the project list.
