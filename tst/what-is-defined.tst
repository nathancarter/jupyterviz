############################################################################
##
#A  what-is-defined.tst      JupyterViz Package           Nathan Carter
##
gap> START_TEST("JupyterViz package: what-is-defined.tst");

# Ensure that the functions that are supposed to be exposed are exposed
gap> IsBoundGlobal( "RunJavaScript" );
true
gap> IsBoundGlobal( "LoadJavaScriptFile" );
true
gap> IsBoundGlobal( "JUPVIZAbsoluteJavaScriptFilename" );
true
gap> IsBoundGlobal( "JUPVIZFillInJavaScriptTemplate" );
true
gap> IsBoundGlobal( "JUPVIZRunJavaScriptFromTemplate" );
true
gap> IsBoundGlobal( "JUPVIZRunJavaScriptUsingRunGAP" );
true
gap> IsBoundGlobal( "JUPVIZRunJavaScriptUsingLibraries" );
true
gap> IsBoundGlobal( "CreateVisualization" );
true

# Ensure that global variables are defined
gap> IsBoundGlobal( "JUPVIZLoadedJavaScriptCache" );
true

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "what-is-defined.tst", 10000 );

############################################################################
##
#E
