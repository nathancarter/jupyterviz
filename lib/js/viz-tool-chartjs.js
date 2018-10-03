
window.requirejs.config( {
    paths : {
        chartjs : 'https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min'
    }
} );

// The ChartJS library (see https://www.chartjs.org/)
//
// This passes json.data directly to ChartJS's new Chart() constructor.
// See its documentation here for details regarding the format:
// http://www.chartjs.org/docs/latest/getting-started/usage.html
window.VisualizationTools.chartjs = function ( element, json, callback ) {
    var canvas = document.createElement( 'canvas' );
    if ( json.width ) canvas.width = json.width;
    if ( json.height ) canvas.width = json.height;
    element.appendChild( canvas );
    require( [ 'chartjs' ], function ( chartjs ) {
        new window.Chart( canvas, json.data );
        callback( element, canvas );
    } );
};
