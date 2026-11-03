#!/usr/bin/env python3
"""Minimal stdlib validation for this portable skill collection.

Not a replacement for official skills-ref checks or agent-runtime smoke tests.
"""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SKILLS = ROOT / "skills"
EXPECTED = {
    "project-analysis", "architecture-documentation", "agents-md-authoring",
    "github-pr-review", "github-pr-feedback", "github-pull-request",
    "git-commit", "incident-investigation", "skill-authoring", "unslop",
}


def validate(folder: Path) -> list[str]:
    errors = []
    source = folder / "SKILL.md"
    if not source.exists():
        return [f"{folder.name}: missing SKILL.md"]
    text = source.read_text(encoding="utf-8")
    front = re.match(r"\A---\n(.*?)\n---\n", text, flags=re.S)
    if not front:
        return [f"{folder.name}: invalid YAML-style frontmatter delimiters"]
    metadata = front.group(1)
    name = re.search(r"^name:\s*(.*?)\s*$", metadata, re.M)
    desc = re.search(r"^description:\s*(.*?)\s*$", metadata, re.M)
    if not name or name.group(1) != folder.name:
        errors.append(f"{folder.name}: name must match directory")
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", folder.name) or len(folder.name) > 64:
        errors.append(f"{folder.name}: invalid skill name")
    if not desc or not (1 <= len(desc.group(1)) <= 1024):
        errors.append(f"{folder.name}: description missing or too long")
    if len(text.splitlines()) > 500:
        errors.append(f"{folder.name}: SKILL.md longer than 500 lines")
    for relative in re.findall(r"\]\(([^)#]+)(?:#[^)]*)?\)", text):
        if '://' in relative or relative.startswith(('mailto:', '#')):
            continue
        target = (folder / relative).resolve()
        if not target.is_relative_to(folder.resolve()):
            errors.append(f"{folder.name}: reference escapes skill: {relative}")
        elif not target.exists():
            errors.append(f"{folder.name}: broken reference: {relative}")
    return errors


def main() -> int:
    if not SKILLS.exists():
        print("Missing skills folder", file=sys.stderr)
        return 1
    actual = {p.name for p in SKILLS.iterdir() if p.is_dir()}
    errors = []
    if actual != EXPECTED:
        errors.append(f"Skill directory mismatch: missing={sorted(EXPECTED-actual)}, extra={sorted(actual-EXPECTED)}")
    for folder in sorted(SKILLS.iterdir()):
        if folder.is_dir():
            errors.extend(validate(folder))
    if errors:
        print("Validation failed:")
        for err in errors:
            print(f"  - {err}")
        return 1
    print(f"Validated {len(actual)} standalone skill folders. No broken local SKILL.md links.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
