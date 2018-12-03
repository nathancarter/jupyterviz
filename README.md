<!--
Removing these lines for now because this package is not yet
integrated into GAP or its build system.

[![Build Status](https://travis-ci.org/gap-packages/jupyterviz.svg?branch=master)](https://travis-ci.org/gap-packages/jupyterviz)
[![Code Coverage](https://codecov.io/github/gap-packages/jupyterviz/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/jupyterviz)
-->

# The Jupyter Notebook Visualization Package

## Purpose

This package adds visualization tools to GAP for use in Jupyter notebooks.
These include standard line and bar graphs, pie charts, scatter plots, and
graphs in the vertices-and-edges sense.

## Implementation

These are implemented by importing existing JavaScript visualization
libraries into the notebook as needed, based on the kind of visualization
requested by the GAP code.

The architecture of the package is such that additional JavaScript
visualization libraries can be added easily.

## Usage

The package does not need to be compiled.

See the manual on [the package website](http://nathancarter.github.io/jupyterviz),
which contains many usage examples.

Or experiment with a live notebook on Binder:
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/nathancarter/jupyterviz/master?filepath=inst%2Fgap-4.9.3%2Fpkg%2Fjupyterviz%2F).
(It can be a long loading time, so have patience!)

## Maintainer

 * Nathan Carter

This GAP package is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option)
any later version.
