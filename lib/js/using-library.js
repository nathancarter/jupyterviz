
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
// If the library has been loaded, just run the callback and be done.
if ( window.librariesLoadedFromGAP.hasOwnProperty( $library ) ) {
    return myCallback();
}
// Run some GAP code to fetch the library.
var filenameString = JSON.stringify( $library );
var GAPcode = "JUPVIZ_FileContents( LoadJavaScriptFile( "
            + filenameString + " ) );"
window.runGAP( GAPcode, function ( result, error ) {
    // If we got an error, stop here.
    if ( error )
        throw Error( "Could not load library " + filenameString
                   + ": " + error );
    // Otherwise, the text/plain attribute of result should contain the JS
    // code of the library, with a pair of superfluous quotes around it for
    // some reason.
    result = result["text/plain"];
    // Cache it so we don't re-load it later.
    window.librariesLoadedFromGAP[$library] = result;
    // Try to run it and quit with a useful message if it fails.
    try {
        console.log( "Running this library code:", result );
        var whatItEvaluatesTo = eval( result );
        console.log( "Finished with this result:", whatItEvaluatesTo );
    } catch ( e ) {
        throw Error( "Error evaluating code for library "
                   + filenameString + ": " + e );
    }
    // The library is loaded, so we can run the code that needed it:
    return myCallback();
} );
