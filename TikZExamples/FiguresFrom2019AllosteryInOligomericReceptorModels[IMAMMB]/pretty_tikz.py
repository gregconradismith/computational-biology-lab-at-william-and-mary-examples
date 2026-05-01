#!/usr/bin/env python3
# Clean, format, and compile standalone TikZ/PGFPlots LaTeX figure sources.
# Usage examples:
#   ./pretty_tikz.py Fig03BindingCurveTCM
#   ./pretty_tikz.py Fig*
# For each matching .tex file, this script writes a three-line %% header,
# deletes unused \def lines, prunes \usepackage and \usetikzlibrary entries
# when a temporary compile proves they are unnecessary, normalizes indentation
# and blank lines, then runs pdflatex to regenerate the PDF.

from __future__ import annotations

import argparse
import glob
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
from typing import Iterable


REMOVE_AFTER_COMPILE_SUFFIXES = (
    ".aux",
    ".auxlock",
    ".log",
    ".out",
    ".synctex.gz",
    ".synctext.gz",
)


def natural_key(path: Path) -> list[object]:
    return [
        int(part) if part.isdigit() else part.lower()
        for part in re.split(r"(\d+)", str(path))
    ]


def expand_targets(targets: Iterable[str]) -> list[Path]:
    tex_files: list[Path] = []
    for target in targets:
        matches = [Path(match) for match in glob.glob(target)] or [Path(target)]
        for match in matches:
            if match.is_dir():
                tex_files.extend(sorted(match.glob("*.tex"), key=natural_key))
            elif match.is_file() and match.suffix == ".tex":
                tex_files.append(match)

    unique: dict[Path, None] = {}
    for tex_file in tex_files:
        unique[tex_file.resolve()] = None
    return sorted(unique, key=natural_key)


def strip_latex_comment(line: str) -> str:
    for index, char in enumerate(line):
        if char != "%":
            continue
        backslashes = 0
        cursor = index - 1
        while cursor >= 0 and line[cursor] == "\\":
            backslashes += 1
            cursor -= 1
        if backslashes % 2 == 0:
            return line[:index]
    return line


def remove_leading_header(lines: list[str]) -> tuple[list[str], str]:
    title_parts: list[str] = []
    index = 0
    while index < len(lines) and (not lines[index].strip() or lines[index].lstrip().startswith("%%")):
        stripped = lines[index].strip()
        if stripped.startswith("%%"):
            text = stripped[2:].strip()
            lowered = text.lower()
            if (
                text
                and not lowered.endswith(".tex")
                and "unused packages" not in lowered
                and "temporary outputs" not in lowered
                and "standalone pgfplots source" not in lowered
            ):
                title_parts.append(text)
        index += 1

    title = " ".join(title_parts).strip() or "Pretty formatted LaTeX/TikZ source"
    return lines[index:], title


def apply_header(tex_path: Path, lines: list[str]) -> list[str]:
    remaining, title = remove_leading_header(lines)
    while remaining and not remaining[0].strip():
        remaining.pop(0)
    return [
        f"%% {title}\n",
        f"%% {tex_path.name}\n",
        "%% Unused packages and definitions removed; TikZ/PGFPlots source formatted.\n",
        "\n",
        *remaining,
    ]


def is_commented_package_or_def(line: str) -> bool:
    return bool(re.match(r"^\s*%+\s*\\(?:usepackage|def)\b", line))


def remove_commented_dead_lines(lines: list[str]) -> list[str]:
    return [line for line in lines if not is_commented_package_or_def(line)]


def find_def_name(line: str) -> str | None:
    match = re.match(r"^\s*\\def\\([A-Za-z@]+)(?:#\d+)*\s*\{", line)
    if match:
        return match.group(1)
    return None


def macro_is_used(lines: list[str], name: str, own_index: int) -> bool:
    pattern = re.compile(rf"\\{re.escape(name)}(?![A-Za-z@])")
    for index, line in enumerate(lines):
        if index == own_index:
            continue
        searchable = strip_latex_comment(line)
        if pattern.search(searchable):
            return True
    return False


def remove_unused_defs(lines: list[str]) -> list[str]:
    current = list(lines)
    while True:
        remove_indices: set[int] = set()
        for index, line in enumerate(current):
            name = find_def_name(line)
            if name and not macro_is_used(current, name, index):
                remove_indices.add(index)

        if not remove_indices:
            return current

        current = [
            line
            for index, line in enumerate(current)
            if index not in remove_indices
        ]


def parse_csv_argument(line: str, command: str) -> tuple[re.Match[str], list[str]] | None:
    pattern = rf"^(\s*\\{command}(?:\[[^\]]*\])?\{{)([^}}]+)(\}}\s*)$"
    match = re.match(pattern, line.strip())
    if not match:
        return None
    items = [item.strip() for item in match.group(2).split(",") if item.strip()]
    return match, items


def replace_csv_argument(line: str, command: str, items: list[str]) -> str | None:
    parsed = parse_csv_argument(line, command)
    if not parsed:
        return None
    match, _old_items = parsed
    if not items:
        return ""
    return f"{match.group(1)}{','.join(items)}{match.group(3)}\n"


def cleanup_compile_outputs(directory: Path, stem: str) -> None:
    for suffix in REMOVE_AFTER_COMPILE_SUFFIXES:
        path = directory / f"{stem}{suffix}"
        if path.exists():
            path.unlink()


def compile_content(tex_path: Path, content: str, pdflatex: str, timeout: int = 60) -> bool:
    with tempfile.NamedTemporaryFile(
        "w",
        encoding="utf-8",
        suffix=".tex",
        prefix=".pretty_tikz_test_",
        dir=tex_path.parent,
        delete=False,
    ) as handle:
        handle.write(content)
        temp_path = Path(handle.name)

    command = [
        pdflatex,
        "-interaction=nonstopmode",
        "-halt-on-error",
        temp_path.name,
    ]

    try:
        result = subprocess.run(
            command,
            cwd=tex_path.parent,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=timeout,
            check=False,
        )
        return result.returncode == 0
    except (OSError, subprocess.TimeoutExpired):
        return False
    finally:
        stem = temp_path.stem
        if temp_path.exists():
            temp_path.unlink()
        cleanup_compile_outputs(tex_path.parent, stem)
        pdf_path = tex_path.parent / f"{stem}.pdf"
        if pdf_path.exists():
            pdf_path.unlink()


def prune_csv_command_entries(
    tex_path: Path,
    lines: list[str],
    command: str,
    pdflatex: str,
) -> list[str]:
    current = list(lines)
    index = 0
    while index < len(current):
        parsed = parse_csv_argument(current[index], command)
        if not parsed:
            index += 1
            continue

        _match, items = parsed
        kept = list(items)
        changed = False
        for item in list(items):
            trial_items = [candidate for candidate in kept if candidate != item]
            replacement = replace_csv_argument(current[index], command, trial_items)
            if replacement is None:
                continue

            trial = list(current)
            if replacement:
                trial[index] = replacement
            else:
                del trial[index]

            if compile_content(tex_path, "".join(trial), pdflatex):
                kept = trial_items
                current = trial
                changed = True
                if not kept:
                    index -= 1
                    break

        index += 1
        if changed:
            continue

    return current


def prune_packages_and_libraries(
    tex_path: Path,
    lines: list[str],
    pdflatex: str,
    enabled: bool,
) -> list[str]:
    if not enabled or not shutil.which(pdflatex):
        return lines

    current = prune_csv_command_entries(tex_path, lines, "usepackage", pdflatex)
    current = prune_csv_command_entries(tex_path, current, "usetikzlibrary", pdflatex)
    return current


def normalize_line_spacing(lines: list[str]) -> list[str]:
    output: list[str] = []
    previous_blank = False
    for line in lines:
        stripped = line.rstrip()
        if not stripped:
            if output and not previous_blank:
                output.append("\n")
            previous_blank = True
            continue
        output.append(f"{stripped}\n")
        previous_blank = False

    while output and not output[-1].strip():
        output.pop()
    output.append("\n")
    return output


def normalize_common_tikz_spacing(line: str) -> str:
    stripped = line.strip()
    if not stripped or stripped.startswith("%"):
        return stripped

    stripped = re.sub(r"\\(draw|node|path|addplot)\s+\[", r"\\\1[", stripped)
    stripped = re.sub(r"\bof\s*=\s*", "of=", stripped)
    stripped = re.sub(r"legend pos\s*=\s*", "legend pos=", stripped)
    stripped = re.sub(r"legend cell align\s*=\s*", "legend cell align=", stripped)
    stripped = re.sub(r"\s+,", ",", stripped)
    stripped = re.sub(r"\s+;", ";", stripped)
    return stripped


def environment_delta(line: str) -> tuple[int, int]:
    begins = re.findall(r"\\begin\{([^}]+)\}", line)
    ends = re.findall(r"\\end\{([^}]+)\}", line)
    begin_count = sum(1 for name in begins if name != "document")
    end_count = sum(1 for name in ends if name != "document")
    return begin_count, end_count


def pretty_indent(lines: list[str]) -> list[str]:
    output: list[str] = []
    indent = 0
    for line in lines:
        stripped = normalize_common_tikz_spacing(line)
        if not stripped:
            output.append("\n")
            continue

        begins, ends = environment_delta(stripped)
        if stripped.startswith(r"\end{"):
            indent = max(0, indent - ends)
            output.append(f"{'    ' * indent}{stripped}\n")
            indent += begins
            continue

        output.append(f"{'    ' * indent}{stripped}\n")
        indent += begins - ends
        indent = max(0, indent)
    return output


def transform_content(
    tex_path: Path,
    original: str,
    pdflatex: str,
    prune_active_packages: bool,
) -> str:
    lines = original.splitlines(keepends=True)
    lines = apply_header(tex_path, lines)
    lines = remove_commented_dead_lines(lines)
    lines = remove_unused_defs(lines)
    lines = normalize_line_spacing(lines)
    lines = prune_packages_and_libraries(tex_path, lines, pdflatex, prune_active_packages)
    lines = normalize_line_spacing(lines)
    lines = pretty_indent(lines)
    lines = normalize_line_spacing(lines)
    return "".join(lines)


def compile_tex(tex_path: Path, pdflatex: str) -> bool:
    command = [
        pdflatex,
        "-interaction=nonstopmode",
        "-halt-on-error",
        tex_path.name,
    ]
    try:
        result = subprocess.run(
            command,
            cwd=tex_path.parent,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            check=False,
        )
    except OSError as error:
        print(f"{tex_path}: could not run {pdflatex}: {error}", file=sys.stderr)
        return False

    if result.returncode != 0:
        print(f"{tex_path}: pdflatex failed", file=sys.stderr)
        print("\n".join(result.stdout.splitlines()[-25:]), file=sys.stderr)
        return False

    cleanup_compile_outputs(tex_path.parent, tex_path.stem)
    return True


def open_pdf(pdf_path: Path) -> None:
    opener = "open" if sys.platform == "darwin" else "xdg-open"
    try:
        subprocess.run([opener, str(pdf_path)], check=False)
    except OSError as error:
        print(f"{pdf_path}: could not open PDF: {error}", file=sys.stderr)


def process_file(
    tex_path: Path,
    pdflatex: str,
    should_compile: bool,
    should_open: bool,
    dry_run: bool,
) -> bool:
    original = tex_path.read_text(encoding="utf-8")
    transformed = transform_content(
        tex_path,
        original,
        pdflatex=pdflatex,
        prune_active_packages=should_compile,
    )

    if transformed != original:
        if dry_run:
            print(f"{tex_path}: would update source")
        else:
            tex_path.write_text(transformed, encoding="utf-8")
            print(f"{tex_path}: updated source")
    else:
        print(f"{tex_path}: source already clean")

    if not should_compile:
        return True

    if dry_run:
        print(f"{tex_path}: would run pdflatex")
        return True

    if not compile_tex(tex_path, pdflatex):
        return False

    pdf_path = tex_path.with_suffix(".pdf")
    print(f"{tex_path}: compiled {pdf_path.name}")
    if should_open:
        open_pdf(pdf_path)
    return True


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Clean, pretty-format, and compile Fig*/TikZ LaTeX sources."
    )
    parser.add_argument("targets", nargs="+", help="Directories, .tex files, or glob patterns.")
    parser.add_argument("--pdflatex", default="pdflatex", help="pdflatex executable to use.")
    parser.add_argument("--no-compile", action="store_true", help="Format only; do not compile.")
    parser.add_argument("--open", action="store_true", help="Open every compiled PDF.")
    parser.add_argument("--no-open", action="store_true", help="Do not open PDFs.")
    parser.add_argument("--dry-run", action="store_true", help="Report actions without writing files.")
    args = parser.parse_args()

    tex_files = expand_targets(args.targets)
    if not tex_files:
        print("No matching .tex files found.", file=sys.stderr)
        return 1

    should_compile = not args.no_compile
    should_open = should_compile and not args.no_open and (args.open or len(tex_files) == 1)

    ok = True
    for tex_path in tex_files:
        ok = process_file(
            tex_path,
            pdflatex=args.pdflatex,
            should_compile=should_compile,
            should_open=should_open,
            dry_run=args.dry_run,
        ) and ok

    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
