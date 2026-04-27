# Contributing Guide

This repository is meant to help undergraduate research students get started quickly, learn from previous work, and reuse good examples. Contributions are welcome, especially when they make the repository easier to learn from.

## Good Contributions

Examples of helpful contributions:

- a small, well-documented MATLAB example
- a clean LaTeX or TikZ example for a common research need
- notes that explain how to run or adapt an example
- a folder `README.md` that makes an existing example easier to use
- cleanup that removes accidental local clutter from version control

## Before You Add Something New

1. Check whether a similar example already exists.
2. Prefer improving or extending an existing example over adding a near-duplicate.
3. Put new materials in the most relevant topic folder.
4. If no obvious folder exists, add one with a short `README.md`.

## Expectations For Example Folders

Each substantial example folder should ideally include:

- a short description of what the example demonstrates
- the main file to open or run first
- any required software or toolbox
- any special instructions needed to reproduce the output

## Naming Suggestions

- Use descriptive folder names.
- Avoid generic names like `test`, `stuff`, or `new_example`.
- Prefer names that tell future students what they will learn.

## Git Workflow

The basic workflow for small changes is:

```bash
git status
git add <files>
git commit -m "Describe the change clearly"
git push
```

See [GIT-HELP.md](GIT-HELP.md) for a simpler introduction.

## What To Avoid

- Do not commit operating-system clutter such as `.DS_Store`.
- Do not commit temporary editor files or swap files.
- Avoid committing generated files unless they are genuinely useful artifacts for students.
- Avoid restructuring large parts of the repository without updating the surrounding documentation.

## A Good Rule Of Thumb

Leave the repository easier to understand than you found it.
