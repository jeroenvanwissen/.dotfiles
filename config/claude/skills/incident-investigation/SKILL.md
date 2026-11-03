---
name: incident-investigation
description: Investigate a service incident or OpsGenie-style alert using bounded, read-only evidence from logs, traces, metrics and code. Use for production triage, root-cause investigation, or preparing a minimal fix and validation plan without deploying changes.
---

# Incident Investigation

**Outcome:** bounded, reproducible diagnosis and the safest next step. Standalone; does not require other skills. Production access is optional; when unavailable, analyze supplied alert/logs and explain evidence gaps.

## Procedure

1. Capture the **full alert** (excluding credentials/PII), severity, observed start/end times and timezone, affected service, environment, account, region and expected behavior. Never guess production account, AWS region or log group.
2. Assess user impact, current state, urgency and escalation needs. If actively harmful, notify the responsible human/on-call team; don't attempt undocumented live mitigations.
3. Establish least-privilege access. For AWS, use the organization's approved **read-only SSO role** and verify identity with `aws sts get-caller-identity` before querying. **Never elevate to an admin role** to investigate. If identity does not match the intended account, stop querying.
4. Inspect a **bounded** time window around the event and only relevant metrics/log groups. Record exact UTC timestamps, query strings, region, request/trace IDs and source links. Narrow or expand deliberately, with reasons; avoid full-history unbounded scans.
5. Correlate the request across components (for example API Gateway → Lambda → downstream service or datastore). Separate first failure from cascading symptoms, expected errors and retries. Compare with a healthy instance where available.
6. Consult the checked-out production-relevant code/config at a **verified deployed revision**, not an assumed local branch. Form a hypothesis and test against evidence; state alternatives and what would falsify the conclusion.
7. Recommend the **smallest safe fix** or operational mitigation and a reproducing test. It may be appropriate to create a local patch only when explicitly asked. Human review, tests and normal change/deployment process are required; **do not deploy**.
8. Close with a short incident report using [report template](assets/incident-report.md): impact/timeline, root cause or uncertainty, evidence, request ID, actual query, proposed fix, validation, follow-up and escalation/handoff.

## Safety

- Read-only production investigation by default: no changing database records, acknowledgments/closure, configuration, live resource state, permissions or deployments without separate explicit authorization and approved runbooks.
- Do not request or echo secrets, tokens, private keys, or sensitive customer data. Redact in outputs.
- Account, region, time window, trace and deployed commit are **verified facts**, not defaults. No "we fixed it" without post-fix evidence.
- Use available equivalent observability systems when not on AWS. Access limitations do not prevent a useful partial investigation.
