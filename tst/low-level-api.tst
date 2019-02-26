############################################################################
##
#A  low-level-api.tst      JupyterViz Package           Nathan Carter
##
gap> START_TEST("JupyterViz package: low-level-api.tst");

# Ensure some basic requirements of the output of functions defined in this
# package

# Tell the package we're inside a Jupyter notebook.
gap> LoadPackage( "JupyterKernel", false );
true
gap> PlotDisplayMethod := PlotDisplayMethod_Jupyter;;

# RunJavaScript function
gap> tmp := RunJavaScript( "var x = 5;" );
<jupyter renderable>
gap> JupyterRenderableData( tmp ).( "application/javascript" );
"( function ( element ) {\nvar x = 5;\n} )( element.get( 0 ) )"

# JUPVIZLoadedJavaScriptCache (internal) is an empty record (at first)
gap> JUPVIZLoadedJavaScriptCache;
rec(  )

# LoadJavaScriptFile function
gap> LoadJavaScriptFile( "this does not exist" );
fail
gap> LoadJavaScriptFile( "for-testing" ); # gets minified version
"function square(x){return x*x}"
gap> LoadJavaScriptFile( "for-testing.js" ); # gets non-minified version
"function square ( x ) {\n  return x * x;\n}\n"

# JUPVIZFillInJavaScriptTemplate function
gap> JUPVIZFillInJavaScriptTemplate( "testing-template.js", rec( debug := "'example'", param := "5" ) );
"function f ( x ) {\n  console.log( 'example'\n );\n  return 5\n + x;\n}\n"

# JUPVIZLoadedJavaScriptCache (internal) is no longer empty
gap> IsBound( JUPVIZLoadedJavaScriptCache.( "for-testing" ) );
true
gap> IsBound( JUPVIZLoadedJavaScriptCache.( "for-testing.js" ) );
true

# JUPVIZAbsoluteJavaScriptFilename function (internal)
gap> EndsWith( JUPVIZAbsoluteJavaScriptFilename( "example" ), "/lib/js/example.js" );
true

# JUPVIZRunJavaScriptFromTemplate function (internal)
gap> tmp := JUPVIZRunJavaScriptFromTemplate( "testing-template.js", rec( debug := "A", param := "B" ) );
<jupyter renderable>
gap> JupyterRenderableData( tmp ).( "application/javascript" );
"( function ( element ) {\nfunction f ( x ) {\n  console.log( A\n );\n  return B\n + x;\n}\n\n})( element.get( 0 ) )"

# JUPVIZRunJavaScriptUsingRunGAP function (internal)
gap> tmp := JUPVIZRunJavaScriptUsingRunGAP( "2+2" );
<jupyter renderable>
gap> tmp := JupyterRenderableData( tmp ).( "application/javascript" );;
gap> Length( tmp ) > 100; # big template
true

# JUPVIZRunJavaScriptUsingLibraries function (internal)
gap> tmp1 := JUPVIZRunJavaScriptUsingLibraries( [ "for-testing" ], "2+2" );
<jupyter renderable>
gap> tmp1 := JupyterRenderableData( tmp1 ).( "application/javascript" );;
gap> Length( tmp1 ) > 100; # big template
true
gap> tmp2 := JUPVIZRunJavaScriptUsingLibraries( "for-testing", "2+2" );
<jupyter renderable>
gap> tmp2 := JupyterRenderableData( tmp2 ).( "application/javascript" );;
gap> tmp1 = tmp2; # string is treated as length-1 list of strings?
true

# CreateVisualization function
gap> tmp := CreateVisualization( rec( tool := "html", data := rec( html := "test" ) ), "console.log( 'done' );" );
<jupyter renderable>
gap> tmp2 := JupyterRenderableData( tmp ).application\/javascript;;
gap> Length( tmp2 ) > 100; # lots of code
true
gap> ContainsString := function ( haystack, needle ) return Length( ReplacedString( haystack, needle, "" ) ) < Length( haystack ); end;;
gap> ContainsString( tmp2, "runGAP" ); # runGAP is called
true
gap> ContainsString( tmp2, "createVisualization" ); # this is called, too
true
gap> ContainsString( tmp2, "\"main\"" ); # this library is also loaded
true
gap> ContainsString( tmp2, "John Lennon" ); # sanity check
false
gap> tmp := CreateVisualization( rec( tool := "html", data := rec( html := "example" ) ), "" );;
gap> tmp2 := CreateVisualization( rec( tool := "html", data := rec( html := "example" ) ) );;
gap> JupyterRenderableData( tmp ) = JupyterRenderableData( tmp2 ); # second argument defaults to empty string
true

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "low-level-api.tst", 10000 );

############################################################################
##
#E
