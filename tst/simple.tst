############################################################################
##
#A  simple.tst           Jupyter-Viz Package                Nathan Carter
##
gap> START_TEST("Jupyter-Viz package: simple.tst");

# First load the package without banner (the banner must be suppressed to
# avoid reporting discrepancies in the case when the package is already
# loaded)
gap> LoadPackage( "jupyter-viz", false );
true

# Run the stupidest of tests, to be sure this file works.
gap> StubForTesting( 100 );
105

# Just another example baby test
gap> IsBoundGlobal( "StubForTesting" );
true

## Each test file should finish with the call of STOP_TEST.
## The first argument of STOP_TEST should be the name of the test file.
## The second argument is redundant and is used for backwards compatibility.
gap> STOP_TEST( "simple.tst", 10000 );

############################################################################
##
#E
