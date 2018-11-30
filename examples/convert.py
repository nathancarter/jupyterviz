#!/usr/bin/python

# This is a simple python script to convert a short markdown
# document into a jupyter notebook that can be run to show the
# contents of the markdown document.

# It is essentially a baby version of jupytext
# (https://github.com/mwouts/jupytext) but I couldn't get that
# project to do what I wanted; it didn't seem to support GAP.

# This package uses this tool to create .ipynb files that can
# be run to generate the visualizations shown in the manual.
# Those files are written in this folder, and must be manually
# loaded and the visualizations manually saved.

# It also creates a .gd file that can be included in the manual.
# It is a chapter that lists all the examples in this folder,
# and is written to the ../lib/ folder with a filename that
# inserts it as the last chapter in the manual.  It assumes that
# the manually saved visualization files (one per notebook) have
# been saved as notebookname.png and copied into the ../lib/
# folder, so that they can be referenced in this documentation.

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
  }
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
  }
"""
image = """
#! <Alt Only="LaTeX">
#!     \\begin{center}
#!         \\includegraphics[height=3in]{%s.png}
#!     \\end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="%s.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
"""

# Declare the workhorse function:
def process_file ( mdfile ):
    # "Verify" the file is an .md file
    if mdfile[-3:] != '.md':
        print "Input file must have extension .md: " + mdfile
        sys.exit()

    # Read the input file and store it in this format:
    # [
    #   [ "markdown", [ "# My title here\n" ] ],
    #   [ "markdown", [ "\n" ] ],
    #   [ "markdown", [ "Look at this code:\n" ] ],
    #   [ "code",     [ "G := Group((1,2),(3,4));\n" ] ],
    #   ...
    # ]
    print "Processing: " + mdfile
    print "\tReading file..."
    lines = [ ]
    mode = 'markdown'
    inf = open( mdfile, 'r' )
    for line in inf.readlines():
        if line[:3] == "```":
            if mode == "markdown":
                mode = "code"
            else:
                mode = "markdown"
        else:
            lines += [ [ mode, [ line ] ] ]
    inf.close()
    
    # Find chunks of successive lines of the same type
    # and unite them into single cells, so we will then have
    # this format:
    # [
    #   [ "markdown", [ "# My title here\n" ],
    #                 [ "\n" ],
    #                 [ "Look at this code:\n" ] ],
    #   [ "code",     [ "G := Group((1,2),(3,4));\n" ] ],
    #   ...
    # ]
    index = 0
    while index < len( lines ) - 1:
        if lines[index][0] == lines[index+1][0]:
            lines[index][1] += lines[index+1][1]
            lines.pop( index+1 )
        else:
            index += 1
    
    # Remove the newline character from the last line of
    # any code cell.
    for line in lines:
        if line[0] == "code":
            line[1][len( line[1] )-1] = \
                line[1][len( line[1] )-1].strip()
    
    # Remove any empty markdown cells, because they come out
    # funny in the notebook.  (It doesn't show them empty,
    # but fills them with "please type here" content.)
    index = 0
    while index < len( lines ):
        if lines[index][0] == "markdown":
            if "".join( lines[index][1] ).strip() == "":
                lines.pop( index )
            else:
                index += 1
        else:
            index += 1
    
    # Write the .ipynb output file in this same folder.
    outfile = mdfile[:-3] + '.ipynb'
    seen_code_yet = False
    print "\tWriting " + outfile + "..."
    outf = open( outfile, 'w' )
    outf.write( header )
    for index, line in enumerate( lines ):
        if line[0] == "markdown":
            template = mdcell
        else:
            template = codecell
            if not seen_code_yet:
                outf.write( template % json.dumps( \
                    [ "LoadPackage( \"jupyterviz\" );" ] ) )
                outf.write( "," )
                seen_code_yet = True
        outf.write( template % json.dumps( line[1] ) )
        if index < len( lines ) - 1:
            outf.write( "," )
    outf.write( footer )
    outf.close()
    
    # Replace markdown headings with AutoDoc headings,
    # then write the .gd output file in the ../lib/ folder.
    outfname = "../lib/ch2-examples-" + mdfile[:-3] + ".gd"
    print "\tWriting " + outfname + "..."
    outf = open( outfname, 'w' )
    outf.write( "#! @Chapter Examples\n" );
    for line in lines:
        if line[0] == "markdown":
            for subline in line[1]:
                if subline[:2] == "# ":
                    subline = "@Section " + subline[2:]
                outf.write( "#! " + subline )
                if subline[:9] == "@Section ":
                    outf.write( "#! @SectionLabel Ex" + \
                        mdfile[:-3] + "\n" )
        else:
            outf.write( "#! @BeginLog\n" )
            outf.write( "#! " + "#! ".join( line[1] ) + "\n" )
            outf.write( "#! @EndLog\n" )
    outf.write( image % ( mdfile[:-3], mdfile[:-3] ) )
    outf.close()

# Use the workhorse function on all .md files in this folder:
converted = [ ]
for fname in os.listdir( "." ):
    if fname[-3:] == ".md":
        process_file( fname )
        converted += [ fname ]
print "Done."
print "Don't forget to open each X.ipynb file generated this " + \
      "way, run all cells, and save the final image created " + \
      "as ../doc/X.png so that it can be included in the docs."
print "You can copy and paste these commands to make it easier:"
for name in converted:
    print "jupyter notebook " + name

