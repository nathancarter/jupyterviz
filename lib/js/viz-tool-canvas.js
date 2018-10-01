
// A plain JavaScript canvas on which to run arbitrary drawing code.
//
// This is the degenerate case among visualization tools.  It ignores
// json.data and draws nothing, preparing a blank canvas you can use in
// the callback.
window.VisualizationTools.canvas = function ( element, json, callback ) {
    var canvas = document.createElement( 'canvas' );
    if ( json.width ) canvas.width = json.width;
    if ( json.height ) canvas.width = json.height;
    element.appendChild( canvas );
    callback( element, canvas );
};
