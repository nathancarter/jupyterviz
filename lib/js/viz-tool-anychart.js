
window.requirejs.config( {
    paths : {
        anychart : 'https://cdn.anychart.com/releases/8.3.0/js/anychart-bundle.min'
    }
} );

// The AnyChart library (see https://www.anychart.com/)
//
// This passes json.data directly to the anychart.fromJson() function,
// then asks it to draw that chart in the given element.
// After the rendering is complete, we then resize the output element to
// be large enough to contain the chart that has been created within it,
// because CanvasJS does not do so automatically.
// See the documentation here for details regarding the format:
// https://docs.anychart.com/Working_with_Data/Data_From_JSON
window.VisualizationTools.anychart = function ( element, json, callback ) {
    require( [ 'anychart' ], function ( dummy ) {
        window.anychart.fromJson( json.data )
            .container( element ).draw();
        window.resizeToShowContents( element );
        // The AnyChart SVGs don't auto-resize to fit contents, so we
        // do that manually as well.
        $( element ).find( 'svg' ).each( function ( idx, elt ) {
            $( elt ).height( $( elt.parentNode ).height() );
        } );
        callback( element, element.childNodes[0] );
    } );
};
