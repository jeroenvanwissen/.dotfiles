---
name: project-analysis
description: Analyze an existing repository or documentation-first project, identify evidence-backed risks and gaps, and optionally create or refresh a prioritized implementation backlog. Use for project onboarding, technical debt assessment, gap analysis, or planning from a specification.
---

# Project Analysis

**Outcome:** a useful assessment and, only if requested, an actionable plan. This skill works by itself; no other skill, tool-specific agent setup, or architecture framework is required.

## Choose the operation

- **Assess (default):** investigate and report findings; don't write files.
- **Plan:** convert verified findings or source requirements to prioritized tasks; write files only if requested.
- **Refresh:** revisit previous assessments/backlogs; preserve existing task IDs and progress.

## Procedure

1. **Define scope.** Identify the user question, repository boundary, available documentation, and whether this is an existing implementation or greenfield specification. Do not silently switch from analysis to implementation.
2. **Inventory selectively.** Check README, package/lock files, code organization, CI, test config, dependency manifests, public APIs, deployment definitions, documentation, `AGENTS.md`, architecture records and existing backlog. Don't blindly read every file. Use the smallest useful search set and broaden where evidence points.
3. **Discover actual conventions.** Record commands and patterns that are *observed* versus rules that are *documented*. Identify contradictions, outdated docs and unverified assumptions. If arc42/ADRs exist, understand them before judging implementation.
4. **Assess.** Review correctness, security, reliability, tests, accessibility where relevant, maintainability, operational readiness and known TODOs. Check usage and reachability before calling TODOs defects. Read [assessment guidance](references/assessment.md) only for an in-depth audit.
5. **Verify baselines.** Prefer existing CI evidence or safe repo commands. Run lint/tests only when feasible and allowed. Never invent coverage percentages or command results. Report not run/unknown explicitly.
6. **Rank findings.** Keep *severity* (impact of defect), *priority* (when to address), and *dependencies* separate. Record a file path, line/section and observed evidence for each important finding. Estimate effort only when supported and label estimates as estimates.
7. **Produce requested output.** Summarize strengths, key risks, evidence and next steps. For saved assessments use [assessment template](assets/assessment-template.md). For persistent work use existing Issues/task system where possible; otherwise a `tasks/BACKLOG.md` and optional files using [task template](assets/task-template.md). Do not create extra IDE configuration, rules or PR workflows.
8. **Reconcile on reruns.** Preserve completed/in-progress work, stable task IDs (`TASK-0001`, ...), previous decisions, and user-authored notes. Never renumber because a task moved to a different milestone; flag stale findings rather than silently deleting history.

## Boundaries

- A new project's missing implementation is **planned work**, not a defect.
- The presence of a framework or directory does not prove how a system runs. Distinguish evidence from inference.
- Do not invent arbitrary coverage targets, complexity caps, PR-line limits or conventions. Report opportunities as recommendations, not established project policy.
- Do not modify arc42, accepted ADRs, `AGENTS.md`, generated configs, production or application code as a side effect of analysis.
- If information is insufficient, provide a bounded partial result and identify what remains unverified.

## Response

Default: executive summary, top actionable findings (impact, evidence, recommended next step), key unknowns and optional short priority ordering. Only create planning artifacts when asked. No mandatory task count, wave count or review checkpoint for a read-only request.
