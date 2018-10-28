############################################################################
##
##
#W  main.gd              JupyterViz Package                  Nathan Carter
##
##  Declaration file for functions of the JupyterViz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##

#! @Chapter Function reference

#! @Section Public API

#! @Arguments script
#! @Returns an object that, if rendered in a Jupyter notebook, will run <Arg>script</Arg> as JavaScript
#! @Description
#!  If evaluated in a Jupyter notebook, its result, when rendered by that
#!  notebook, will run the JavaScript code in <Arg>script</Arg>.
#!  <P/>
#!  When the given code is run, the varible <Code>element</Code> will be
#!  defined in its environment, and will contain the output element in the
#!  Jupyter notebook corresponding to the code that was just evaluated.
#!  The script is free to write to that output element.
#!  <P/>
#!  This function is not intended for use in the &GAP; REPL.
DeclareGlobalFunction( "RunJavaScript" );

#! @Arguments filename
#! @Returns the string contents of the file whose name is given
#! @Description
#!  Interprets the given <Arg>filename</Arg> relative to the
#!  <File>lib/js/</File> path in the JupyterViz package's installation
#!  folder, because that is where this package stores its JavaScript
#!  libraries.  A <File>.js</File> extension will be added to
#!  <Arg>filename</Arg> iff needed.  A <File>.min.js</File> extension will
#!  be added iff such a file exists, to prioritize minified versions of
#!  files.
#!  <P/>
#!  If the file has been loaded before in this &GAP; session, it will not be
#!  reloaded, but will be returned from a cache in memory, for efficiency.
#!  <P/>
#!  If no such file exists, returns <Keyword>fail</Keyword> and caches
#!  nothing.
DeclareGlobalFunction( "LoadJavaScriptFile" );

#! @Arguments data[,code]
#! @Returns an object that, if rendered in a Jupyter notebook, will run a script to create the desired visualization
#! @Description
#!  The <Arg>data</Arg> must be a record that will be converted to JSON
#!  using &GAP;'s <Package>json</Package> package.
#!  <P/>
#!  The second argument is optional, a string containing JavaScript
#!  <Arg>code</Arg> to run once the visualization has been created.  When
#!  that code is run, the variables <Code>element</Code> and
#!  <Code>visualization</Code> will be in its environment, the former
#!  holding the output element in the notebook containing the
#!  visualization, and the latter holding the visualization element itself.
#!  <P/>
#!  The <Arg>data</Arg> should have the following attributes.
#!   * <Code>tool</Code> (required) - the name of the visualization tool to
#!     use.  Currently supported tools:
#!      * <Code>anychart</Code>, whose JSON data format is given here:<P/>
#!        <URL>https://docs.anychart.com/Working_with_Data/Data_From_JSON</URL>
#!      * <Code>canvas</Code>, that is, a regular HTML canvas element, on
#!        which you can draw using arbitrary JavaScript included in
#!        the <Arg>code</Arg> parameter
#!      * <Code>canvasjs</Code>, whose JSON data format is given here:<P/>
#!        <URL>https://canvasjs.com/docs/charts/chart-types/</URL>
#!      * <Code>chartjs</Code>, whose JSON data format is given here:<P/>
#!        <URL>http://www.chartjs.org/docs/latest/getting-started/usage.html</URL>
#!      * <Code>cytoscape</Code>, whose JSON data format is given here:<P/>
#!        <URL>http://js.cytoscape.org/#notation/elements-json</URL>
#!      * <Code>d3</Code>, which is loaded into an SVG element in the
#!        notebook's output cell, and the caller can call any D3 methods on
#!        that element thereafter, using arbitrary JavaScript included in
#!        the <Arg>code</Arg> parameter
#!      * <Code>html</Code>, which fills the output element with arbitrary
#!        HTML, which the caller should provide as a string in the
#!        <Code>html</Code> field of <Arg>data</Arg>, as documented below
#!      * <Code>plotly</Code>, whose JSON data format is given here:<P/>
#!        <URL>https://plot.ly/javascript/plotlyjs-function-reference/#plotlynewplot</URL>
#!   * <Code>data</Code> (required) - subobject containing all options
#!     specific to the content of the visualization, often passed intact to
#!     the external JavaScript visualization library.  You should prepare
#!     this data in the format required by the library specified in the
#!     <Code>tool</Code> field, following the documentation for that
#!     library cited above.
#!   * <Code>width</Code> (optional) - width to set on the output element
#!     being created
#!   * <Code>height</Code> (optional) - similar, but height
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "html",
#!     data := rec( html := "I am <i>SO</i> excited about this." )
#! ), "console.log( 'Visualization created.' );" );
#! @EndLog
DeclareGlobalFunction( "CreateVisualization" );

#! @Section Internal methods

#! Using the convention common to &GAP; packages, we prefix all methods not
#! intended for public use with a sequence of characters that indicate our
#! particular package.  In this case, we use the <Code>JUPVIZ</Code> prefix.
#! This is a sort of "poor man's namespacing."
#! <P/>
#! **None of these methods should need to be called by a client of this
#! package.  We provide this documentation here for completeness, not out of
#! necessity.**

#! @Arguments filename
#! @Returns a JavaScript filename to an absolute path in the package dir
#! @Description
#!  Given a relative <Arg>filename</Arg>, convert it into an absolute
#!  filename by prepending the path to the <File>lib/js/</File> folder
#!  within the JupyterViz package's installation folder.  This is used by
#!  functions that need to find JavaScript files stored there.
#!  <P/>
#!  A <File>.js</File> extension is appended if none is included in the
#!  given <Arg>filename</Arg>.
DeclareGlobalFunction( "JUPVIZAbsoluteJavaScriptFilename" );

#! @Description
#!  A cache of the contents of any JavaScript files that have been loaded
#!  from this package's folder.  The existence of this cache means needing
#!  to go to the filesystem for these files only once per &GAP; session.
#!  This cache is used by <Ref Func="LoadJavaScriptFile"/>.
DeclareGlobalVariable( "JUPVIZLoadedJavaScriptCache" );

#! @Arguments filename, dictionary
#! @Returns a string containing the contents of the given template file, filled in using the given dictionary
#! @Description
#!  A template file is one containing identifiers that begin with a dollar
#!  sign (<Code>\$</Code>).  For example, <Code>\$one</Code> and
#!  <Code>\$two</Code> are both identifiers.  One "fills in" the template by
#!  replacing such identifiers with whatever text the caller associates with
#!  them.
#!  <P/>
#!  This function loads the file specified by <Arg>filename</Arg> by passing
#!  that argument directly to <Ref Func="LoadJavaScriptFile"/>.  If no such
#!  file exists, returns <Keyword>fail</Keyword>.  Otherwise, it proceed as
#!  follows.
#!  <P/>
#!  For each key-value pair in the given <Arg>dictionary</Arg>, prefix a
#!  <Code>\$</Code> onto the key, suffix a newline character onto the value,
#!  and then replace all occurrences of the new key with the new value.
#!  The resulting string is the result.
#!  <P/>
#!  The newline character is included so that if any of the values in the
#!  <Arg>dictionary</Arg> contains single-line JavaScript comment characters
#!  (<Code>//</Code>) then they will not inadvertently affect later code in
#!  the template.
DeclareGlobalFunction( "JUPVIZFillInJavaScriptTemplate" );

#! @Arguments filename, dictionary
#! @Returns the composition of <Ref Func="RunJavaScript"/> with <Ref Func="JUPVIZFillInJavaScriptTemplate"/>
#! @Description
#!  This function is quite simple, and is just a convenience function
DeclareGlobalFunction( "JUPVIZRunJavaScriptFromTemplate" );

#! @Arguments jsCode
#! @Returns an object that, if rendered in a Jupyter notebook, will run <Arg>jsCode</Arg> as JavaScript after <Code>runGAP</Code> has been defined
#! @Description
#!  There is a JavaScript function called <Code>runGAP</Code>, defined in
#!  the <File>using-runGAP.js</File> file distributed with this package.
#!  That function makes it easy to make callbacks from JavaScript in a
#!  Jupyter notebook to the &GAP; kernel underneath that notebook.  This
#!  &GAP; function runs the given <Arg>jsCode</Arg> in the notebook, but
#!  only after ensuring that <Code>runGAP</Code> is defined globally in that
#!  notebook, so that <Arg>jsCode</Arg> can call <Code>runGAP</Code> as
#!  needed.
#!  <P/>
#!  Here is an example use, from JavaScript, of the <Code>runGAP</Code>
#!  function.
#! @BeginLog
#! var calculation = "2^50";
#! runGAP( calculation + ";", function ( result, error ) {
#!     if ( result )
#!         alert( calculation + "=" + result );
#!     else
#!         alert( "There was an error: " + error );
#! } );
#! @EndLog
DeclareGlobalFunction( "JUPVIZRunJavaScriptUsingRunGAP" );

#! @Arguments libraries, jsCode
#! @Returns an object that, if rendered in a Jupyter notebook, will run <Arg>jsCode</Arg> as JavaScript after all <Arg>libraries</Arg> have been loaded
#! @Description
#!  There are a set of JavaScript libraries stored in the
#!  <File>lib/js/</File> subfolder of this package's installation folder.
#!  The Jupyter notebook does not, by default, know about any of those
#!  libraries.  This &GAP; function runs the given <Arg>jsCode</Arg> in the
#!  notebook, but only after ensuring that all JavaScript files on the list
#!  <Arg>libraries</Arg> have been loaded, so that <Arg>jsCode</Arg> can
#!  make use of the functions and variables that they define.
#!  <P/>
#!  If the first parameter is given as a string instead of a list of
#!  strings, it is treated as a list of just one string.
#! @BeginLog
#! JUPVIZRunJavaScriptUsingLibraries( [ "mylib.js" ],
#!     "alert( 'My Lib defines foo to be: ' + window.foo );" );
#! # Equivalently:
#! JUPVIZRunJavaScriptUsingLibraries( "mylib.js",
#!     "alert( 'My Lib defines foo to be: ' + window.foo );" );
#! @EndLog
DeclareGlobalFunction( "JUPVIZRunJavaScriptUsingLibraries" );

#! @Section Representation wrapper

#! This code is documented for completeness's sake only.  It is not needed
#! for clients of this package.  Package maintainers may be interested in it
#! in the future.
#! <P/>
#! The <Package>JupyterKernel</Package> package defines a method
#! <Code>JupyterRender</Code> that determines how &GAP; data will be shown
#! to the user in the Jupyter notebook interface.  When there is no method
#! implemented for a specific data type, the fallback method uses the
#! built-in &GAP; method <Code>ViewString</Code>.
#! <P/>
#! This presents a problem, because we are often transmitting string data
#! (the contents of JavaScript files) from the &GAP; kernel to the notebook,
#! and <Code>ViewString</Code> is not careful about how it escapes
#! characters such as quotation marks, which can seriously mangle code.
#! Thus we must define our own type and <Code>JupyterRender</Code> method
#! for that type, to prevent the use of <Code>ViewString</Code>.
#! <P/>
#! The declarations documented below do just that.  In the event that
#! <Code>ViewString</Code> were upgraded to more useful behavior, this
#! workaround could probably be removed.  Note that it is used explicitly
#! in the <File>using-library.js</File> file in this package.

#! @Description
#!  The type we create is called <Code>FileContents</Code>, because that is
#!  our purpose for it (to preserve, unaltered, the contents of a text
#!  file).
DeclareCategory( "JUPVIZIsFileContents", IsObject );

#! @Description
#!  The representation for the <Code>FileContents</Code> type
DeclareRepresentation( "JUPVIZIsFileContentsRep",
    IsComponentObjectRep and JUPVIZIsFileContents, [ "content" ] );

#! @Description
#!  A constructor for <Code>FileContents</Code> objects
DeclareOperation( "JUPVIZFileContents", [ IsString ] );

#! Elsewhere, the <Package>JupyterViz</Package> package also installs a
#! <Code>JupyterRender</Code> method for <Code>FileContents</Code> objects
#! that just returns their text content untouched.

#E  main.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
