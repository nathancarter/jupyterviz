############################################################################
##
##
#W  main.gd              Jupyter-Viz Package                  Nathan Carter
##
##  Declaration file for functions of the Jupyter-Viz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##

############################################################################
##
#F  RunJavaScript(<script>)
##
##  runs the given JavaScript code in the current Jupyter notebook
##
##  <#GAPDoc Label="RunJavaScript">
##  <ManSection>
##  <Func Name="RunJavaScript" Arg="script"/>
##
##  <Description>
##  runs the JavaScript code <A>script</A> in the current Jupyter notebook
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction( "RunJavaScript" );

##  The following new types and operations are for internal use only, and
##  are thus undocumented externally.  They are a workaround for the fact
##  that ViewString (used internally by the JupyterKernel's default
##  implementation for JupyterRender) does not properly escape quotes and
##  other characters, making it a terrible way to transmit the contents of a
##  text file from the GAP server to the JavaScript notebook client.
##  We thus create this wrapper for text file contents instead.
DeclareCategory( "JUPVIZ_IsFileContents", IsObject );
DeclareRepresentation( "JUPVIZ_IsFileContentsRep",
    IsComponentObjectRep and JUPVIZ_IsFileContents, [ "content" ] );
DeclareOperation( "JUPVIZ_FileContents", [ IsString ] );

############################################################################
##
#F  LoadJavaScriptFile(<filename>)
##
##  loads the given file from disk, within the package's lib/js directory
##
##  <#GAPDoc Label="LoadJavaScriptFile">
##  <ManSection>
##  <Func Name="LoadJavaScriptFile" Arg="filename"/>
##
##  <Description>
##  loads and returns the string contents of <A>filename</A>, interpreted
##  relative to the lib/js path in this package's directory, appending a
##  .min.js or .js extension as needed
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction( "LoadJavaScriptFile" );

############################################################################
##
#F  JUPVIZ_AbsoluteJavaScriptFilename(<filename>)
##
##  converts a JavaScript filename to an absolute path in the package dir
##
DeclareGlobalFunction( "JUPVIZ_AbsoluteJavaScriptFilename" );

############################################################################
##
#F  JUPVIZ_LoadedJavaScriptCache
##
##  global cache of JavaScript files loaded from this package's folder
##
DeclareGlobalVariable( "JUPVIZ_LoadedJavaScriptCache" );

############################################################################
##
#F  JUPVIZ_FillInJavaScriptTemplate(<filename>,<dictionary>)
##
##  loads a template file and fills it in using the given dictionary
DeclareGlobalFunction( "JUPVIZ_FillInJavaScriptTemplate" );

############################################################################
##
#F  JUPVIZ_RunJavaScriptFromTemplate(<filename>,<dictionary>)
##
##  fills in the template in the given file, then runs it
DeclareGlobalFunction( "JUPVIZ_RunJavaScriptFromTemplate" );

############################################################################
##
#F  JUPVIZ_RunJavaScriptUsingRunGAP(<jsCode>)
##
##  runs the given JavaScript code after ensuring that runGAP() is defined
DeclareGlobalFunction( "JUPVIZ_RunJavaScriptUsingRunGAP" );

############################################################################
##
#F  JUPVIZ_RunJavaScriptUsingLibaries(<libraries>,<jsCode>)
##
##  runs the given JavaScript code after installing the libraries iff needed
DeclareGlobalFunction( "JUPVIZ_RunJavaScriptUsingLibraries" );

############################################################################
##
#F  CreateVisualization(<json>,<code>)
##
##  creates a visualization and then runs code on it
DeclareGlobalFunction( "CreateVisualization" );

#E  main.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
