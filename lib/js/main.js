
/*
 * Utilities for creating visualizations in a Jupyter notebook
 *
 * Some of these functions assume the presence of jQuery, which is present
 * in the Jupyter notebook.
 */

/*
 * The main function of this module: Creates a visualization based on the
 * given JSON data, placing it in the given DOM element.
 *
 * A callback at the end receives the original element as its first
 * parameter, plus the inner visualization element created as part of the
 * process as its second parameter.
 *
 * Its data parameter should be JSON, as documented in the main.gi file in
 * this library.
 *
 * To see the list of visualization tools currently supported, and get links
 * to the data format requirements of each, read the definition of the
 * global window.VisualizationTools object, below.
 *
 * This makes use of several tools defined below, but it is acceptable in
 * JavaScript to define this first.
 */
window.createVisualization = function ( element, data, callback ) {
    // If they requested a tool we know, let's use it.
    if ( window.VisualizationTools[data.tool] )
        window.VisualizationTools[data.tool]( element, data, callback );
    // Otherwise, show an error.
    else {
        window.VisualizationTools.html( element, {
            data : {
                html : 'Error: No known visualization tool, "'
                     + data.tool + '."'
            }
        }, callback );
    }
}

/*
 * Global registry of visualization libraries
 *
 * We install here just one visualization tool, plain HTML.  But this
 * structure is now declared globally, and other scripts can add other
 * tools.  We provide other scripts in this folder that do install other
 * tools, and this organization keeps things modular (and loads only the
 * code you need).
 *
 * Each key in the dictionary is the name of a tool, and its value is a
 * function that should be called to display data using that tool.  The
 * standard is that the function will be passed three parameters:
 *   1. the output element in which to place the visualization
 *   2. a single options object described below
 *   3. a callback that will be called with two parameters, the output
 *      element itself, and whichever of its children contains the created
 *      visualization
 * The options JSON object will have been passed directly from
 * createVisualization(), so see formatting data above for details.
 */
window.VisualizationTools = {

    // A tool to display arbitrary HTML, typically used to show errors if
    // something went wrong, but can be used quite flexibly.
    //
    // We just show json.data.html in an inner div, and return that div.
    html : function ( element, json, callback ) {
        var div = document.createElement( 'div' );
        element.appendChild( div );
        div.innerHTML = json.data.html;
        if ( json.width ) $( div ).width( json.width );
        if ( json.height ) $( div ).height( json.height );
        callback( element, div );
    }

};

/*
 * Resizes a DOM element to be large enough to show its contents
 *
 * Many visualization tools do not automatically resize their containers
 * when they create a large plot.  So we have this tool available for them
 * to use if needed.
 */
window.resizeToShowContents = function ( element ) {
    // Find the largest coordinates for the (right,bottom) points of each
    // element below the given one in the DOM heirarchy.
    var maxima = { right : 0, bottom : 0 };
    $( element ).find( '*' ).each( function ( idx, elt ) {
        var $elt = $( elt );
        var right = $elt.position().left + $elt.outerWidth();
        var bottom = $elt.position().top + $elt.outerHeight();
        maxima = {
            right : Math.max( right, maxima.right ),
            bottom : Math.max( bottom, maxima.bottom )
        };
    } );
    // Ensure that the element we were given is large enough to reveal that
    // bottom-right-most point.
    var $element = $( element );
    $element.width( maxima.right - $element.position().left );
    $element.height( maxima.bottom - $element.position().top );
}
