
# This file follows the pattern set down in the Example package.
# It runs all .tst files in this same directory.

LoadPackage( "jupyterviz" );

TestDirectory( DirectoriesPackageLibrary( "jupyterviz", "tst" ),
  rec( exitGAP     := true,
       testOptions := rec( compareFunction := "uptowhitespace" ) ) );

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
