# GitHub inline review API notes

Prerequisite for live actions: `gh auth status` with appropriate repository access.

Read current PR and files (replace owner/repo and NUMBER):

```bash
gh api repos/OWNER/REPO/pulls/NUMBER
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/files
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/comments
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/reviews
```

For line-anchored review, use `POST /repos/OWNER/REPO/pulls/NUMBER/reviews` with `event: COMMENT`, `body` and an array of `comments` containing `path`, `line`, `side`, `body` (optionally `start_line`/`start_side` for ranges). The line must exist in the PR diff. Use the latest head SHA in `commit_id` to prevent stale anchors.

Payload example (inspect and confirm with user before submission):

```json
{
  "commit_id": "<verified-head-sha>",
  "event": "COMMENT",
  "body": "[AGENT] Reviewed the changes: ...",
  "comments": [
    {
      "path": "src/example.ts",
      "line": 42,
      "side": "RIGHT",
      "body": "[AGENT] P1: ... Observable issue; suggested correction: ..."
    }
  ]
}
```

After user confirmation, save the payload as `review.json` and use:

```bash
gh api -X POST repos/OWNER/REPO/pulls/NUMBER/reviews --input review.json
```

GitHub also permits pending reviews (omit `event`) but they require explicit submission. Prefer modern `line`/`side` coordinates because the legacy `position` parameter is being deprecated. On 422, inspect changed lines and the current head before trying again; don't convert all inline comments to a giant timeline note by default. Redact secrets, tokens, personal information and confidential log data from feedback.

Docs: https://docs.github.com/en/rest/pulls/reviews and https://docs.github.com/en/rest/pulls/comments
