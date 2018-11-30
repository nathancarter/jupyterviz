#!/usr/bin/python

# This is a simple python script to look through all the GAP code
# and documentation in the lib/ folder of this repository, find
# all example code snippets, and extract them all into a single
# Jupyter Notebook.

# The resulting notebook can then be loaded and the user can
# manually run one or more of the code snippets.  This is useful
# when generating visualizations that will then be included in the
# original manual, to show the results of the code snippets.

# This script is to be run without parameters.  It finds all the
# lib/*.gd files and processes them in alphabetical order by
# filename.

import sys
import json
import os

# Declare some global variables to use as output templates:

header = """
{
 "cells": [
"""
footer = """
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "GAP 4",
   "language": "gap",
   "name": "gap-4"
  },
  "language_info": {
   "codemirror_mode": "gap",
   "file_extension": ".g",
   "mimetype": "text/x-gap",
   "name": "GAP 4",
   "nbconvert_exporter": "",
   "pygments_lexer": "gap",
   "version": "4.9.2"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
"""
mdcell = """
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": %s
  }%s
"""
codecell = """
  {
   "cell_type": "code",
   "execution_count": 0,
   "metadata": {
    "name": "GAP"
   },
   "outputs": [],
   "source": %s
  }%s
"""

# The function that gathers snippets from a file and the global
# variable in which it puts them:
snippets = [ ]
def process_file ( gdfile ):
    global snippets
    print "Processing " + gdfile + "..."
    mode = "not in a snippet"
    inf = open( gdfile, "r" )
    for line in inf.readlines():
        if line.strip() == "#! @BeginLog":
            mode = "in a snippet"
            snippets += [ [ ] ]
        elif line.strip() == "#! @EndLog":
            mode = "not in a snippet"
        elif mode == "in a snippet":
            snippets[len(snippets)-1] += [ line[3:] ]
    inf.close()

# The function that writes all the snippets into a file:
outfile = "extracted_snippets.ipynb"
def write_all ():
    global snippets, outfile
    print "Writing " + outfile + "..."
    outf = open( outfile, "w" )
    outf.write( header )
    outf.write( mdcell % ( json.dumps( [ \
        "# Snippets extracted from all files in `lib/*.gd`\n" \
    ] ), "," ) )
    outf.write( codecell % ( json.dumps( [ \
        "LoadPackage( \"jupyterviz\" );" ] ), "," ) )
    comma = ","
    for index, snippet in enumerate( snippets ):
        snippet[len(snippet)-1] = snippet[len(snippet)-1].strip()
        if index == len( snippets ) - 1:
            comma = ""
        outf.write( codecell % ( json.dumps( snippet ), comma ) )
    outf.write( footer )
    outf.close()

# Use the above functions on lib/*.gd
for fname in os.listdir( "lib" ):
    if fname[-3:] == ".gd":
        process_file( "lib/" + fname )
write_all()
print "Done.  You can open the resulting file with this command:"
print "jupyter notebook " + outfile

