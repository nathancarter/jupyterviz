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

#E  main.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
