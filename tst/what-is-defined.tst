############################################################################
##
#A  what-is-defined.tst      Jupyter-Viz Package           Nathan Carter
##
gap> START_TEST("Jupyter-Viz package: what-is-defined.tst");

# First load the package without banner (the banner must be suppressed to
# avoid reporting discrepancies in the case when the package is already
# loaded)
gap> LoadPackage( "jupyter-viz", false );
true

# Ensure that the functions that are supposed to be exposed are exposed
gap> IsBoundGlobal( "RunJavaScript" );
true
gap> IsBoundGlobal( "LoadJavaScriptFile" );
true
gap> IsBoundGlobal( "JUPVIZ_AbsoluteJavaScriptFilename" );
true
gap> IsBoundGlobal( "JUPVIZ_FillInJavaScriptTemplate" );
true
gap> IsBoundGlobal( "JUPVIZ_RunJavaScriptFromTemplate" );
true
gap> IsBoundGlobal( "JUPVIZ_RunJavaScriptUsingRunGAP" );
true
gap> IsBoundGlobal( "JUPVIZ_RunJavaScriptUsingLibraries" );
true
gap> IsBoundGlobal( "CreateVisualization" );
true

# Ensure that global variables are defined
gap> IsBoundGlobal( "JUPVIZ_LoadedJavaScriptCache" );
true

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "what-is-defined.tst", 10000 );

############################################################################
##
#E
