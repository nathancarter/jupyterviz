############################################################################
##
#A  correct-output.tst      Jupyter-Viz Package           Nathan Carter
##
gap> START_TEST("Jupyter-Viz package: correct-output.tst");

# First load the package without banner (the banner must be suppressed to
# avoid reporting discrepancies in the case when the package is already
# loaded)
gap> LoadPackage( "jupyter-viz", false );
true

# Ensure some basic requirements of the output of functions defined in this
# package

# RunJavaScript function
gap> tmp := RunJavaScript( "var x = 5;" );
<jupyter renderable>
gap> JupyterRenderableData( tmp ).( "application/javascript" );
"( function ( element ) { var x = 5; } )( element.get( 0 ) )"

# JUPVIZ_AbsoluteJavaScriptFilename function (internal)
gap> EndsWith( JUPVIZ_AbsoluteJavaScriptFilename( "example" ), "/lib/js/example.js" );
true

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "correct-output.tst", 10000 );

############################################################################
##
#E
