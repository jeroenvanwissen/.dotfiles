---
name: git-commit
description: Prepare and create a focused local Git commit from verified working-tree changes. Use when asked to commit changes, propose commit messages, inspect staged files, or split unrelated work into coherent commits.
---

# Git Commit

**Outcome:** an intentional, inspectable local commit; no PR or remote push. Fully standalone.

## Procedure

1. Check the repository, branch and state with `git status --short`, `git diff`, `git diff --cached`, and recent commit style. Respect repository guidance.
2. Identify the logical scope and **exact files/hunks** involved. Avoid indiscriminate `git add .` when unrelated changes may exist. Never stage generated credentials, `.env` secrets or unexpected binaries.
3. Look for risk: credentials, personal data, large files, unstaged changes and merge conflicts. Ask about ambiguous staged work rather than discarding it.
4. Run focused lint/tests if feasible and relevant; accurately report skipped commands or failures. Do not edit code just to manufacture a green commit unless asked.
5. Choose the repo's established message convention; use Conventional Commits only if adopted or requested. The subject should explain intent, not repeat a filename; body should explain non-obvious why/tradeoffs.
6. If asked to commit, stage only the specified/approved changes and display `git diff --cached --stat` plus a final staged review. Create commit with the intended message and configured signing; do not disable signing to work around configuration problems.
7. Verify `git show --stat --oneline HEAD` and report commit SHA plus remaining worktree changes. If commit fails, report the error without claiming success.

## Boundaries

- Never silently amend, rebase, reset, clean, delete branches, force-push or push commits. These rewrite or propagate history beyond the requested local commit.
- Preserve the user's work and staging choices. Do not absorb unrelated files or alter existing uncommitted changes.
- An explicit request to **draft a message** is not authorization to commit.
