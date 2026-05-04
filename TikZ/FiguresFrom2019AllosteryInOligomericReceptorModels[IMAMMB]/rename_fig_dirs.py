#!/usr/bin/env python3
# Rename top-level directories whose names start with "Fig" so they use a
# sequential two-digit prefix followed by a hyphen: Fig01-Something,
# Fig02-Something, Fig03-Something, and so on.
# Directories are processed in natural sorted order, and any existing number
# plus an optional separator immediately after "Fig" is replaced by the new
# sequence number and hyphen.
import os
import re
import sys


def natural_key(name):
    return [
        int(part) if part.isdigit() else part.lower()
        for part in re.split(r"(\d+)", name)
    ]


def main():
    root = "."
    dirs = [
        name
        for name in os.listdir(root)
        if name.startswith("Fig") and os.path.isdir(os.path.join(root, name))
    ]
    dirs.sort(key=natural_key)

    pairs = []
    for index, old in enumerate(dirs, 1):
        suffix = old[3:]
        suffix = re.sub(r"^\d+", "", suffix)
        suffix = re.sub(r"^[-_\s]+", "", suffix)
        if not suffix:
            print(f"Cannot derive suffix for directory: {old}")
            return 1
        new = f"Fig{index:02d}-{suffix}"
        pairs.append((old, new))

    targets = [new for _, new in pairs]
    if len(targets) != len(set(targets)):
        seen = set()
        dupes = sorted({name for name in targets if name in seen or seen.add(name)})
        print("Duplicate target names:", *dupes, sep="\n")
        return 1

    conflicts = [
        new
        for old, new in pairs
        if old != new and os.path.exists(os.path.join(root, new))
    ]
    if conflicts:
        print("Target names already exist:", *conflicts, sep="\n")
        return 1

    temps = []
    for index, (old, _new) in enumerate(pairs, 1):
        temp = f".__codex_rename_tmp_{index:02d}__{old}"
        if os.path.exists(os.path.join(root, temp)):
            print(f"Temporary name already exists: {temp}")
            return 1
        temps.append(temp)

    for old, temp in zip(dirs, temps):
        os.rename(os.path.join(root, old), os.path.join(root, temp))

    for temp, (_old, new) in zip(temps, pairs):
        os.rename(os.path.join(root, temp), os.path.join(root, new))

    for old, new in pairs:
        print(f"{old} -> {new}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
