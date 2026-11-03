---
name: skill-authoring
description: Create, refactor, or review a portable standalone Agent Skill in the SKILL.md format. Use to turn a repeated workflow or guide into an installable skill with clear triggers, minimal instructions, optional local references and practical validation.
---

# Skill Authoring

**Outcome:** one focused, independently installable skill. Does not require this pack, a registry, a custom agent, or any other skill.

## Procedure

1. Identify a repeated, consequential user task and its clear output. Write down 3 trigger prompts, 2 non-trigger prompts and at least 1 failure case.
2. Set a narrow responsibility: one meaningful outcome, not a broad assistant persona. A skill can read context and invoke common tools, but cannot require a second skill to execute its core behavior.
3. Create `<skill-name>/SKILL.md` with YAML frontmatter: lowercase hyphenated `name` matching its folder, and `description` explaining both the outcome and when to use it. See [starter template](assets/skill-template.md).
4. Write numbered procedures with inputs, verification, decisions, side-effect boundaries, failures and desired output. Lead with concrete instructions; don't restate generic advice.
5. Keep `SKILL.md` reasonably short. Move specialized details into **local** `references/`, static templates into **local** `assets/`, and code into **local** `scripts/` only when their value is clear. Load them on demand with relative links. Avoid loading all references up front.
6. Check that it can run *alone*: no imported shared policy, mandatory external skill, undocumented helper, secret or organization-only registry. Explicit external prerequisites (for example `gh` for GitHub API calls) are acceptable when genuinely required by the task.
7. Validate frontmatter, path references, assumptions and edge cases. If available, use the official `skills-ref validate <skill-path>` validator; do not assume it is installed. Run trigger and non-trigger prompts with an actual supported agent runtime.
8. Revise for simplicity. Remove duplicated instructions, mandatory boilerplate files, unrealistic guarantees and unsafe automatic actions. Return an installable folder and brief usage examples.

## Quality bar

- An unfamiliar developer can understand purpose, inputs and output in under a minute.
- Every tool/file called out actually exists or is clearly an optional external prerequisite.
- Side effects (publishing, pushing, production changes) are explicitly gated.
- One folder can be copied and installed without anything else from the original collection.

## Notes

The interoperable Agent Skills layout requires a `SKILL.md` file; `manifest.yaml`, organizational registries, proprietary sync tools and special agents are **optional organization-specific layers**, not portability requirements. Do not generate them by default.
