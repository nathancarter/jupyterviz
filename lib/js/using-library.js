
/*
 * This template file ensures that an arbitrary library (specified by
 * filename in the template parameter "library") is installed, then runs
 * some other code that probably depends on that library.  It does not
 * bother re-installing the library if it's already installed.  The code to
 * run after the library is loaded appears in the template parameter
 * "runThis".
 *
 * Because this template file's code uses window.runGAP(), you should ensure
 * that it has been loaded before this code is run.
 */

// Ensure that our global cache of loaded libraries has been initialized.
if ( !window.hasOwnProperty( 'librariesLoadedFromGAP' ) ) {
    window.librariesLoadedFromGAP = { };
}
// Define a callback function that includes the template parameter of all
// code that will be run once the library has been loaded.
function myCallback () {
    $runThis
}

if ( window.librariesLoadedFromGAP.hasOwnProperty( $library ) ) {

    // The library has been loaded, so just run the callback and be done.
    myCallback();

} else {

    // The library hasn't been loaded, so run some GAP code to fetch it.
    var filenameString = JSON.stringify( $library );
    var GAPcode = "JUPVIZFileContents( LoadJavaScriptFile( "
                + filenameString + " ) );"
    window.runGAP( GAPcode, function ( result, error ) {
        // If we got an error, stop here.
        if ( error )
            throw Error( "When loading library " + filenameString
                       + ": " + error );
        // The text/plain attribute of result should contain the lib code:
        result = result["text/plain"];
        // Cache it so we don't re-load it later.
        window.librariesLoadedFromGAP[$library] = result;
        // Try to run it and quit with a useful message if it fails.
        try {
            var whatItEvaluatesTo = eval( result );
        } catch ( e ) {
            throw Error( "Error evaluating code for library "
                       + filenameString + ": " + e );
        }
        // The library is loaded, so we can run the code that needed it:
        return myCallback();
    } );

}
