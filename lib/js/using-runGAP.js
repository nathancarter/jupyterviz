
/*
 * This template file ensures that window.runGAP is installed,
 * then runs some other code that probably depends on runGAP.
 * It does not bother installing it if it's already installed.
 */

if ( !window.hasOwnProperty( 'runGAP' ) ) {

/*
 * Sends code to GAP kernel to execute, calling callback with the results.
 *
 * Because some visualizations should be interactive, we want the ability to
 * call GAP code from the notebook client, using JavaScript, and receive
 * results back, on which we can operate in JavaScript.  This function
 * enables that functionality.
 *
 * If the GAP code yields a result, this calls callback( result, null ).
 * If the GAP code yields an error, this calls callback( null, error ).
 */
window.runGAP = function ( code, callback )
{
    // if the kernel is not ready, just write to the output cell and quit.
    if ( !Jupyter || !Jupyter.notebook || !Jupyter.notebook.kernel )
        return callback( null,
            'JavaScript-based output must be re-evaluated when the notebook'
          + ' is reloaded.  (Re-run the cell to clear this problem.)' );
    // the purpose of the following variables is explained further below
    var errorMessages = [ ];
    var timeout = null;
    // send code to the kernel, with the options specified below
    Jupyter.notebook.kernel.execute( code, {
        iopub : {
            output : function ( message ) {
                // results come back in message.content.data, usually
                // message.content.data["text/plain"], so if that's present,
                // that's a success:
                if ( 'data' in message.content )
                    return callback( message.content.data, null );
                // errors come back in message.content.text, so if we don't
                // have even that, then I have no idea what's going on, so
                // yield an error now:
                if ( !( 'text' in message.content ) )
                    return callback( null, message.content );
                // we have some text, which may be some or all of an error
                // message; more messages may be coming.  so store this one
                // in an array of error messages and start a 200ms timeout
                // to see if we get any further error messages.
                // (if any former timeout was running, clear it first.)
                errorMessages.push( message.content.text );
                if ( timeout !== null )
                    clearTimeout( timeout );
                timeout = setTimeout( function () {
                    // 200ms has passed, so send error to callback
                    callback( null, errorMessages.join( '\n' ) );
                }, 200 );
            },
            clear_output : function ( message ) {
                // could put code here if you want to monitor these
                // messages, but I do not yet need to do so
            }
        },
        shell : {
            reply : function ( message ) {
                // could put code here if you want to monitor these
                // messages, but I do not yet need to do so
            }
        },
        input : function ( message ) {
            // could put code here if you want to monitor these messages,
            // but I do not yet need to do so
        }
    }, {
        // could put code here if you want to monitor these messages, but I
        // do not yet need to do so
    } );
}

}

/*
 * The installation is now guaranteed to be complete, so we can run our
 * other code, which will be inserted as the following template parameter:
 */

$runThis
