############################################################################
##
#A  support-for-repl.tst      JupyterViz Package         Nathan Carter
##
gap> START_TEST("JupyterViz package: support-for-repl.tst");

# Ensure some basic requirements of the output of functions defined in this
# package

# Tell the package we're inside a Jupyter notebook.
gap> LoadPackage( "JupyterKernel", false );
true
gap> PlotDisplayMethod := PlotDisplayMethod_Jupyter;;

# Then verify that the RunJavaScript function works the
# same way that it does in the low-level-api.tst file.
gap> tmp := RunJavaScript( "var x = 5;" );
<jupyter renderable>
gap> JupyterRenderableData( tmp ).( "application/javascript" );
"( function ( element ) {\nvar x = 5;\n} )( element.get( 0 ) )"

# Now verify that if we change the global PlotDisplayMethod setting,
# then RunJavaScript yields an HTML page instead.  We do not test here
# exactly what's in the page, just as long as it seems to contain the
# right stuff.
gap> PlotDisplayMethod := PlotDisplayMethod_HTML;;

# Optional second parameter means return the HTML rather than pop it
# up in the browser.
gap> tmp := RunJavaScript( "JAVASCRIPT CODE HERE", true );;
gap> StartsWith( tmp, "<html>" );
true
gap> EndsWith( tmp, "</html>" );
true
gap> Length( ReplacedString( tmp, "JAVASCRIPT CODE HERE", "X" ) ) < Length( tmp );
true

# Now if we ask to run a piece of JavaScript with a certain library loaded,
# we should be able to find evidence in the code created of that library's
# presence.
gap> tmp := JUPVIZRunJavaScriptUsingLibraries( [ "viz-tool-chartjs" ], "1+1", true );;
gap> StartsWith( tmp, "<html>" );
true
gap> EndsWith( tmp, "</html>" );
true
gap> Length( ReplacedString( tmp, "window.Chart", "X" ) ) < Length( tmp );
true

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "support-for-repl.tst", 10000 );

############################################################################
##
#E
