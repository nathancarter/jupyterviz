
window.requirejs.config( {
    paths : {
        plotly : 'https://cdn.plot.ly/plotly-latest.min'
    }
} );

// The Plotly library (see https://plot.ly/)
//
// This passes json.data directly to Plotly's newPlot() function.
// See its documentation here for details regarding the format:
// https://plot.ly/javascript/plotlyjs-function-reference/#plotlynewplot
window.VisualizationTools.plotly = function ( element, json, callback ) {
    require( [ 'plotly' ], function ( plotly ) {
        plotly.newPlot( element, json.data );
        callback( element, element.childNodes[0] );
    } );
};
