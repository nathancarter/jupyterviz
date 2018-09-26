<!--
Removing these lines for now because this package is not yet
integrated into GAP or its build system.

[![Build Status](https://travis-ci.org/gap-packages/jupyter-viz.svg?branch=master)](https://travis-ci.org/gap-packages/jupyter-viz)
[![Code Coverage](https://codecov.io/github/gap-packages/jupyter-viz/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/jupyter-viz)
-->

# The Jupyter Notebook Visualization Package

* Website: nathancarter.github.io/jupyter-viz/
* Repository: https://github.com/nathancarter/jupyter-viz

## Purpose

This package adds visualization tools to GAP for use in Jupyter
notebooks.  These include standard line and bar graphs, pie
charts, scatter plots, and graphs in the vertices-and-edges sense.

## Implementation

These are implemented by importing existing JavaScript
visualization libraries into the notebook as needed, based on the
kind of visualization requested by the GAP code.

The architecture of the package is such that additional JavaScript
visualization libraries can be added easily.

## Usage

The package does not need to be compiled.

To use the package, start a Jupyter Notebook session with a GAP
kernel and run a cell containing

	LoadPackage("jupyter-viz");

to load the package.

For details on how to use the package see its documentation in
the `doc` subdirectory (view its HTML version or `manual.pdf` via
a PDF viewer).

## Maintainer

 * Nathan Carter

This GAP package is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.
