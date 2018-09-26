##  This builds the documentation of the Jupyter-VIz package
##  Needs: GAPDoc package, latex, pdflatex, mkindex
##  
LoadPackage( "GAPDoc" );

# Build docs of many different formats.
MakeGAPDocDoc( "doc",                # docs dir (relative)
               "main",               # main docs file (without .xml)
               [ "../lib/main.gd" ], # source files containing docs
               "Jupyter-Viz",        # name of book, in GAP help system
               "MathJax"             # optional, produces another HTML file
               );; 

# Copy style files from GAPDoc into the docs folder here.
CopyHTMLStyleFiles( "doc" );

# Create the manual.lab file so other packages could refer to this one.
GAPDocManualLab( "Jupyter-Viz" );; 

