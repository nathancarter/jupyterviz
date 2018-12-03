#!
#! @Chapter Limitations
#!
#! The functions in this package depend upon being evaluated in a live
#! Jupyter Notebook.  This brings up a few limitations:
#!
#!  * If a notebook with visualizations created by this package is saved and
#!    later reloaded, the visualizations will not persist.  They will be
#!    replaced by an error message instructing the user to re-run the cell
#!    that created the visualization.  This limitation may be removable with
#!    some refactoring of the internal workings of this package.
#!  * The <Code>nbconvert</Code> tool, which converts <File>.ipynb</File>
#!    files into other formats, will not include the visualizations, because
#!    <Code>nbconvert</Code> is not a browser that can evaluate the
#!    JavaScript code that generates the visualizations.
#!  * Since most visualizations load a JavaScript library from a CDN, they
#!    require a working Internet connection to function.
#!
