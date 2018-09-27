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

# Ensure that the functions that are not supposed to be exposed are not
# exposed (no such tests yet, but they will go here)

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "what-is-defined.tst", 10000 );

############################################################################
##
#E
