#!/usr/bin/env python3
"""Merge a one-line bullet into today's Obsidian daily note under a project section.

Vault root and today's daily-note path are resolved through the `obsidian` CLI
(so this respects whatever folder/filename format the vault's Daily Notes
plugin is configured with). The actual read/merge/write is plain file I/O,
not `obsidian create ... overwrite` -- round-tripping full note content
through the CLI's own \\n-escaping convention is more error-prone than just
writing the file directly. Obsidian picks up on-disk changes the same way it
would for an edit made in any other editor.

Sections that are not exactly "## [[ProjectName]]" are left byte-for-byte
untouched, in their original relative order. Project sections are collected,
merged by name, and re-emitted as a single alphabetically-sorted block at the
end of the file.
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

PROJECT_HEADING_RE = re.compile(r"^## \[\[([^\]]+)\]\]\s*$")


def run_obsidian(vault, *args):
    result = subprocess.run(
        ["obsidian", f"vault={vault}", *args],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.exit(
            f"obsidian {' '.join(args)} failed: "
            f"{result.stderr.strip() or result.stdout.strip()}"
        )
    return result.stdout.strip()


def resolve_vault_root(vault):
    for line in run_obsidian(vault, "vaults", "verbose").splitlines():
        parts = line.split("\t")
        if len(parts) == 2 and parts[0] == vault:
            return Path(parts[1])
    sys.exit(f"vault '{vault}' not found in `obsidian vaults verbose`")


def split_blocks(lines):
    """Split lines into (heading_or_None, body_lines) blocks on H2 boundaries."""
    blocks = []
    heading = None
    body = []
    for line in lines:
        if line.startswith("## "):
            blocks.append((heading, body))
            heading, body = line, []
        else:
            body.append(line)
    blocks.append((heading, body))
    return blocks


def merge_bullet(text, project, bullet):
    blocks = split_blocks(text.splitlines())

    other_blocks = []
    projects = {}
    project_order = []

    for heading, body in blocks:
        match = PROJECT_HEADING_RE.match(heading) if heading else None
        if match:
            name = match.group(1)
            if name not in projects:
                projects[name] = []
                project_order.append(name)
            projects[name].extend(body)
        elif heading is None and not any(line.strip() for line in body):
            continue  # drop an entirely-empty preamble block
        else:
            other_blocks.append((heading, body))

    if project not in projects:
        projects[project] = []
        project_order.append(project)
    projects[project].append(f"- {bullet}")

    out_lines = []
    for heading, body in other_blocks:
        if heading is not None:
            out_lines.append(heading)
        out_lines.extend(body)
    while out_lines and out_lines[-1].strip() == "":
        out_lines.pop()

    for name in sorted(projects):
        body = [line for line in projects[name] if line.strip() != ""]
        if out_lines:
            out_lines.append("")
        out_lines.append(f"## [[{name}]]")
        out_lines.extend(body)

    return "\n".join(out_lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vault", required=True)
    parser.add_argument("--project", required=True)
    parser.add_argument("--bullet", required=True)
    args = parser.parse_args()

    root = resolve_vault_root(args.vault)
    rel_path = run_obsidian(args.vault, "daily:path")
    run_obsidian(args.vault, "daily:read")  # ensures today's note exists on disk
    note_path = root / rel_path
    note_path.parent.mkdir(parents=True, exist_ok=True)

    text = note_path.read_text() if note_path.exists() else ""
    note_path.write_text(merge_bullet(text, args.project, args.bullet))
    print(f"Logged to {note_path}")


if __name__ == "__main__":
    main()
