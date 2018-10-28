
window.requirejs.config( {
    paths : {
        cytoscape : 'https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.2.16/cytoscape.min'
    }
} );

// The Cytoscape library (http://js.cytoscape.org/)
//
// This library is for drawing and analyzing graphs in the mathematical
// sense (vertices and edges).  This routine passes json.data directly
// to the Cytoscape main function.
//
// This modifies the json parameter in-place by adding the element
// parameter as the container field in its data object.  This is done
// because we assume that large graphs may be passed this way, and we do
// not wish to copy them every time.  The caller may feel free to copy
// the json object before passing.
window.VisualizationTools.cytoscape = function ( element, json, callback ) {
    require( [ 'cytoscape' ], function ( cytoscape ) {
        if ( json.width ) $( element ).width( json.width );
        if ( json.height ) $( element ).height( json.height );
        json.data.container = element;
        callback( element, cytoscape( json.data ) );
    } );
};
