# Student Paths

This guide is intended to help undergraduate research students choose a sensible starting point.

## Path 1: Brand-New To Computational Research

Start here if you are new to Git, MATLAB, and technical writing.

1. Read [GIT-HELP.md](GIT-HELP.md).
2. Work through [Matlab/README.md](Matlab/README.md).
3. Run one example from `Matlab/NumerialIntegrationOfScalarODE`.
4. Learn simple plotting examples in `Matlab/PlottingSubplotsAndMultipleYAxes`.
5. When you are ready to write reports, move to [Latex/README.md](Latex/README.md).

## Path 2: MATLAB For Modeling And Analysis

Start here if your project is mainly computational or mathematical.

1. Begin with [Matlab/README.md](Matlab/README.md).
2. Continue to [MatlabMore/README.md](MatlabMore/README.md).
3. Try one worksheet or one numerical integration example.
4. Choose a specialized topic such as parameter search, Markov chains, or binding curves.

Good first `MatlabMore` folders:

- `ExampleMatlabWorksheets`
- `NumericalIntegrationOf2DLinearODESystem`
- `ExampleMatlabBindingCurveCooperativity`
- `ExampleMatlabParameterSearch`

## Path 3: Writing Papers, Posters, And Figures

Start here if your immediate need is communication rather than numerical modeling.

1. Read [Latex/README.md](Latex/README.md).
2. Start with `Latex/ExampleLatexMinimal` or `Latex/ExampleLatexSimple`.
3. Move to [TikZ/README.md](TikZ/README.md) for diagrams and publication-quality figures.
4. Explore `Latex/ExampleLatexPosters` only after you are comfortable compiling smaller examples.

## Path 4: Exploratory Notes And Reproducible Documents

Start here if you want computation and narrative in one place.

1. Read [Notebooks/README.md](Notebooks/README.md).
2. Explore the existing example.
3. If your workflow needs symbolic computation tied to LaTeX, continue to [Sagemath/README.md](Sagemath/README.md).

## Path 5: HPC And Cluster Work

This is an advanced path.

1. First understand the MATLAB code you want to run locally.
2. Then read [HPC-Sciclone/README.md](HPC-Sciclone/README.md).
3. Use the cluster example only after you are comfortable with the local workflow.

## General Advice

- Start from the smallest example that teaches the concept you need.
- Prefer understanding one example deeply over opening ten folders at once.
- Keep your own project work separate from the shared examples whenever possible.
- If you figure out something confusing, add a short `README.md` so the next student has an easier start.
