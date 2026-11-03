# Evidence-backed assessment (read only for detailed audits)

Start with user-critical flows and system boundaries rather than a generic checklist. Inspect relevant interfaces across UI/API/storage/queues, error handling, observability, deployment configuration and tests.

For each finding capture:

- **Finding ID:** `F-001` within this report (not a persistent task ID).
- **Observation:** what is verifiably happening or missing.
- **Evidence:** repository path and line/section, command output, CI link or explicitly attributed specification.
- **Impact and severity:** what could go wrong and how serious it is *if verified*.
- **Confidence:** verified / likely / hypothesis.
- **Priority:** P0 immediate, P1 next, P2 planned, P3 later; urgency depends on context.
- **Recommendation:** smallest reasonable next step, with constraints and dependencies.

Distinguish functionality, reliability, security, observability, accessibility, maintainability, developer experience and architectural mismatch. Not all categories apply to all projects. Inspect TODO/FIXME/HACK as leads, not automatic defects.

Do not claim numeric coverage or dependency risk solely from configuration files. If a test cannot be run, say why. Cite both code and decision records where implementation diverges from documented intent; a divergence may reflect outdated documentation, not wrong code.

For a greenfield project classify work as *requirements, unresolved decisions, foundation, implementation, validation*, not as Critical/High defects. Order dependencies explicitly without making schedule waves part of task identity.
