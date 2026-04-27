# Cleanup Notes

This file records conservative recommendations for future structural cleanup.

## High-Value Non-Breaking Improvements Already Made

- added top-level and folder-level `README.md` files
- added a student roadmap in `STUDENT-PATHS.md`
- added a contribution guide
- clarified that some folders are teaching entry points and others are archival references

## Likely Future Cleanup Candidates

### MATLAB

- split `MatlabMore/RandomMatlab` into topic-based folders
- decide whether `ExampleMatlabSpeedingUp` and `ExampleSpeedingUpMatlab` should be merged
- add more subfolder `README.md` files in specialized folders

### LaTeX

- decide whether `ExampleLatex Latexian` should remain separate from `ExampleLatex`
- separate poster templates from poster archives
- consider whether folders with historical spaces in their names should be renamed

### General

- identify generated artifacts that are worth keeping versus artifacts that should be removed from version control
- identify old examples that should be explicitly marked `Archive`
- optionally create a clearer top-level split between `Beginner`, `Intermediate`, and `Reference`

## Guiding Principle

Prefer changes that improve navigation and comprehension without breaking existing file paths unless there is a strong reason to restructure more aggressively.
