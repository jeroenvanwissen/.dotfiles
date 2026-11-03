# GitHub feedback API notes

Retrieve context:

```bash
gh api repos/OWNER/REPO/pulls/NUMBER
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/comments
gh api --paginate repos/OWNER/REPO/pulls/NUMBER/reviews
gh api --paginate repos/OWNER/REPO/issues/NUMBER/comments
```

`pulls/NUMBER/comments` are inline diff review comments and include IDs, path, original/current lines, and `in_reply_to_id` for replies. Review summaries live under `pulls/NUMBER/reviews`; PR timeline comments use `issues/NUMBER/comments`. Group replies by thread root ID.

Reply to a specific review comment after explicit confirmation:

```bash
gh api -X POST repos/OWNER/REPO/pulls/NUMBER/comments/COMMENT_ID/replies \
  -f body='[AGENT] Verified ...; updated ...; tests ...'
```

For a **timeline** comment, use the issue-comment endpoint only if the desired reply is truly top-level; it does not create an inline discussion reply. Don't expose secrets or quote sensitive logs. Confirm the reply exists by re-fetching comments.

GitHub REST reference: https://docs.github.com/en/rest/pulls/comments
