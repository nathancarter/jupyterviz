
# This file follows the pattern set down in the Example package.
# It runs all .tst files in this same directory.

# We must load the Jupyter Kernel first, so that we can test all the
# possible behaviors of the JupyterViz package.  If we don't load this
# one, then some tools dependent on it won't be defined when JupyterViz
# loads.
LoadPackage( "jupyterkernel" );
# OK, now load the package we're actually testing.
LoadPackage( "jupyterviz" );

TestDirectory( DirectoriesPackageLibrary( "jupyterviz", "tst" ),
  rec( exitGAP     := true,
       testOptions := rec( compareFunction := "uptowhitespace" ) ) );

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
