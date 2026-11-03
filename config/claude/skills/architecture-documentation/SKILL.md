---
name: architecture-documentation
description: Create, examine, or maintain software architecture documentation using arc42's 12 chapters and Markdown Architecture Decision Records (ADRs). Use when documenting architecture, identifying architecture drift, recording a significant decision, or superseding an accepted decision.
---

# Architecture Documentation

**Outcome:** understandable current architecture plus durable records of *why* important decisions were made. Fully standalone: it can draft one ADR, update arc42, or audit consistency without any other skill.

## Source of truth and scope

- Inspect existing docs, source, deployment/configuration, and repository conventions before writing. Prefer current project locations and naming over creating new duplicates.
- **arc42** describes the *current system* and evolves with the implementation. Follow the 12-chapter [outline](references/arc42-outline.md). A single document or a chapter-per-file layout is fine.
- **ADRs** capture significant individual decisions and their context, alternatives, consequences and validation. Accepted ADRs are durable historical records, even when later superseded.
- Distinguish proposed architecture from implemented architecture. Verify significant claims in code or trustworthy existing documents; mark unverified statements.

## Workflow

1. Identify what is requested: new architecture docs, focused update, architecture audit, new ADR, or superseding a decision.
2. Find the current architecture documents and ADR indexes. Build a concise map of existing constraints, quality attributes, components, runtime flows, deployment and related decisions.
3. If maintaining arc42, update only affected chapters and meaningful cross-links. Keep context/system boundaries, runtime/deployment diagrams, quality scenarios and risks in agreement with observable reality.
4. If recording a decision, write a **proposed** ADR using [ADR template](assets/adr-template.md): context, decision drivers, considered options, outcome and rationale, positive/negative consequences, implementation/validation and related links.
5. Assign the next unused stable `ADR-NNNN` ID. Never renumber. For supersession, create a new linked ADR; keep the previous accepted ADR intact and update its status/index metadata only if the repository standard permits.
6. Only mark an ADR **accepted** after explicit decision-maker approval. Updating arc42 to reflect the accepted decision is appropriate when the implemented/current architecture actually changed; otherwise mark it as planned, not current state.
7. Use repository-relative Markdown links; verify they resolve. Preserve decisions from roles, not fabricated individual names. Avoid confidential names in generic examples.
8. Summarize changed documentation, reasons, unresolved questions and implementation/validation implications.

## Rules

- Never rewrite accepted ADR reasoning to make history match the present.
- Never pretend options were evaluated if they were not. Record missing evidence openly.
- A local code refactor or formatting tweak does not automatically merit an ADR. Record decisions with meaningful consequences, tradeoffs, cost or operational impact.
- Do not introduce implementation changes or deployments as a side effect of writing documentation.
- All work is possible with this skill alone; no other skill is a required delegate.

## Output

If creating a new docs set, prefer `docs/architecture/README.md` (arc42) and `docs/architecture/decisions/ADR-0001-<slug>.md`. Adapt to existing layout if one exists. Use the [arc42 template](assets/arc42-template.md) when starting from scratch; fill only evidenced claims and clearly show unanswered sections.
