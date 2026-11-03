---
name: agents-md-authoring
description: Create or improve concise, reliable AGENTS.md instructions for a software repository or directory. Use when onboarding coding agents, documenting verified build and test commands, or consolidating duplicated assistant instructions into maintainable project guidance.
---

# AGENTS.md Authoring

**Outcome:** accurate, minimal repository instructions. Standalone; does not analyze project backlogs, create vendor adapters, or require other skills.

## Procedure

1. Identify the target root or subdirectory and read existing `AGENTS.md`, README, contribution guide, package/build scripts, CI and relevant architecture docs.
2. Verify how to install, build, test, lint, format and run the project from repository evidence. Prefer exact working-directory context (root vs package). Do not invent scripts or claim they pass without running them.
3. Write [minimal template](assets/AGENTS-template.md) adapted to the repo. Keep only actionable instructions: project map, setup, commands, conventions, architecture guardrails, validation and important safety boundaries.
4. Prefer links to authoritative documentation instead of copying lengthy standards or ADR content. Clarify what applies to the entire repo versus a specific subtree. For monorepos, use small scoped files only if the agent/client honors them.
5. Reconcile existing instruction files and avoid contradictory duplicate guidance; **do not overwrite or generate** `.claude/`, `.cursor/`, `.github/`, `.junie/` or other vendor-specific config by default.
6. Validate every path and command, scan for secrets/confidential data, and produce a diff/summary explaining any changed guidance.

## Content guidelines

- Use short imperative instructions and bullets; prioritize decision-affecting information over generic "write clean code" advice.
- Document *observed* practices separately from *recommended* improvements; obtain approval before turning recommendations into policy.
- Don't demand a particular framework, folder structure, coverage target or commit pattern unless already adopted.
- Don't assert that every coding client consumes AGENTS.md. Verify the actual tool's instruction discovery behavior if platform-specific setup is requested.
- When editing existing guidance, preserve locally meaningful constraints and ask when documents conflict materially.

## Output

A ready-to-use `AGENTS.md` (or focused amendment) plus a compact list of verified commands, notable unknowns and affected files. If the user only asks for advice, show a draft without writing it.
