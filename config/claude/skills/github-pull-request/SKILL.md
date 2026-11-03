---
name: github-pull-request
description: Prepare and, when authorized, create or update a GitHub.com pull request from a local Git branch. Use for writing clear PR descriptions, checking branch readiness, or opening/updating a PR with GitHub CLI.
---

# GitHub Pull Request

**Outcome:** one accurate, reviewable pull request. Standalone; does not require commit, review or feedback skills. Requires `git` and, for live GitHub actions, authenticated `gh` CLI.

## Procedure

1. Verify current repository/remote, working branch, base branch and status (`git status`, `git remote -v`, `gh repo view`). Don't assume `main` versus `master`.
2. Inspect **all** commits and the diff against the intended base; verify no unrelated or sensitive files, secrets, generated artifacts or accidental changes. Confirm branch has committed changes.
3. Inspect existing PRs for the same head branch before creating another. Detect draft/closed/merged state and choose whether to update rather than duplicate.
4. Run relevant checks when feasible; report pass/fail/not run and why. Do not pretend CI passed before results exist.
5. Draft a succinct title and body: **Summary**, **Motivation**, **Main changes**, **Validation**, **Risks/limitations**, and references to issues/docs. Match repository PR templates if present. Avoid generic celebratory filler.
6. Show the intended repo/base/head and PR text. Push or create/update remote PR **only when explicitly requested/approved**; no auto-merge.
7. When authorized, `git push -u origin BRANCH` if necessary, then `gh pr create --base BASE --head BRANCH --title ... --body-file ...` or `gh pr edit NUMBER ...`. If the branch is already pushed, no force-push just to refresh metadata.
8. Verify resulting PR URL and state via `gh pr view` before reporting success.

## Boundaries

- Do not fabricate test status, approval, review or issue linkage.
- Do not squash/rebase/force-push or bypass protections without explicit direction; prefer changes as separate Git actions.
- If the worktree is dirty or the branch mixes unrelated changes, explain the problem and suggest a limited remedy rather than silently rewriting history.
