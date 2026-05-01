#!/usr/bin/env python3
# Clean LaTeX build outputs inside top-level directories named "FigNN*",
# where NN is a two-digit sequence number such as Fig01, Fig02, and so on.
# The script removes common temporary LaTeX files:
# .md5, .aux, .auxlock, .dvi, .eps, .log, .synctex.gz, and .synctext.gz.
# It keeps .tex and .pdf files, but renames those whose filenames start with
# "Fig" followed by digits so the digits are removed:
# for example, Fig1TCM.tex becomes FigTCM.tex.
from pathlib import Path
import re
import sys


REMOVE_SUFFIXES = (
    ".md5",
    ".aux",
    ".auxlock",
    ".dvi",
    ".eps",
    ".log",
    ".synctex.gz",
    ".synctext.gz",
)

KEEP_AND_RENAME_SUFFIXES = {".tex", ".pdf"}


def main():
    root = Path(".")
    fig_dirs = sorted(
        [
            path
            for path in root.iterdir()
            if path.is_dir() and re.match(r"^Fig\d\d", path.name)
        ],
        key=lambda path: path.name.lower(),
    )

    remove_paths = []
    rename_pairs = []
    for directory in fig_dirs:
        for path in sorted(directory.iterdir(), key=lambda item: item.name.lower()):
            if not path.is_file():
                continue

            name = path.name
            if any(name.endswith(suffix) for suffix in REMOVE_SUFFIXES):
                remove_paths.append(path)
                continue

            if path.suffix.lower() in KEEP_AND_RENAME_SUFFIXES:
                new_name = re.sub(r"^Fig\d+", "Fig", name)
                if new_name != name:
                    rename_pairs.append((path, path.with_name(new_name)))

    seen_targets = set()
    for _old, new in rename_pairs:
        if new in seen_targets:
            print(f"Duplicate rename target: {new}")
            return 1
        seen_targets.add(new)

    for old, new in rename_pairs:
        if new.exists() and old != new:
            print(f"Rename target already exists: {new}")
            return 1

    for path in remove_paths:
        path.unlink()

    for old, new in rename_pairs:
        old.rename(new)

    print(f"Removed {len(remove_paths)} temporary LaTeX files")
    print(f"Renamed {len(rename_pairs)} .tex/.pdf files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
