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

# JUPVIZ_LoadedJavaScriptCache (internal) is an empty record (at first)
gap> JUPVIZ_LoadedJavaScriptCache;
rec(  )

# LoadJavaScriptFile function
gap> LoadJavaScriptFile( "this does not exist" );
fail
gap> LoadJavaScriptFile( "for-testing" ); # gets minified version
"function square(x){return x*x}"
gap> LoadJavaScriptFile( "for-testing.js" ); # gets non-minified version
"function square ( x ) {\n  return x * x;\n}\n"

# JUPVIZ_FillInJavaScriptTemplate function
gap> JUPVIZ_FillInJavaScriptTemplate( "testing-template", rec( debug := "'example'", param := "5" ) );
"function f ( x ) {\n  console.log( 'example'\n );\n  return 5\n + x;\n}\n"

# JUPVIZ_LoadedJavaScriptCache (internal) is no longer empty
gap> IsBound( JUPVIZ_LoadedJavaScriptCache.( "for-testing" ) );
true
gap> IsBound( JUPVIZ_LoadedJavaScriptCache.( "for-testing.js" ) );
true

# JUPVIZ_AbsoluteJavaScriptFilename function (internal)
gap> EndsWith( JUPVIZ_AbsoluteJavaScriptFilename( "example" ), "/lib/js/example.js" );
true

# JUPVIZ_RunJavaScriptFromTemplate function
gap> tmp := JUPVIZ_RunJavaScriptFromTemplate( "testing-template", rec( debug := "A", param := "B" ) );
<jupyter renderable>
gap> JupyterRenderableData( tmp ).( "application/javascript" );
"( function ( element ) { function f ( x ) {\n  console.log( A\n );\n  return B\n + x;\n}\n } )( element.get( 0 ) )"

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "correct-output.tst", 10000 );

############################################################################
##
#E
