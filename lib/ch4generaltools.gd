#! @Chapter Using general tools (HTML, canvas, D3)
#!
#! @Section Why these tools are present
#!
#! These general tools can be used as building blocks to create other
#! custom visualization tools.  As a first example, the canvas tool
#! installs an HTML canvas element and then lets you draw arbitrary shapes
#! on it with JavaScript code.  As a second example, some of the high-level
#! tools this package imports were built on top of D3, a foundational
#! visualization toolkit, which you can access directly.
#!
#! First, we cover an as-yet-unmentioned feature of
#! <Ref Func="CreateVisualization"/> that lets us make use of such general
#! tools.
#!
#! @Section Post-processing visualizations
#!
#! The <Ref Func="CreateVisualization"/> function
#! takes an optional second parameter, a string of JavaScript code to be
#! run once the visualization has been rendered. For example, if the
#! visualization library you were using did not support adding borders
#! around a visualization, but you wanted to add one, you could add it by
#! writing one line of JavaScript code to run after the visualization was
#! rendered.
#!
#! @BeginLog
#! CreateVisualization(
#!     rec(
#!         # put your data here, as in previous sections
#!     ),
#!     "visualization.style.border = '5px solid black'"
#! )
#! @EndLog
#!
#! This holds for any visualization tool, not just AnyChart.  In the code
#! given in the second parameter, two variables will be defined for your
#! use: <Code>element</Code> refers to the HTML element inside of which the
#! visualization was built and <Code>visualization</Code> refers to the
#! HTML element of the visualization itself, as produced by the toolkit you
#! chose.  When used in a Jupyter Notebook, <Code>element</Code> is the
#! output cell itself.
#!
#! Now that we know that we can run arbitrary JavaScript code on a
#! visualization once it's been produced, we can call
#! <Ref Func="CreateVisualization"/> to produce rather empty results, then
#! fill them using our own JavaScript code.  The next section explains
#! how this could be done to create custom visualizations.
#!
#! @Section Injecting JavaScript into general tools
#!
#! @Subsection Example: Native HTML Canvas
#!
#! You can create a blank canvas, then use the existing JavaScript canvas
#! API to draw on it.  This example is trivial, but more complex examples
#! are possible.
#!
#! @BeginLog
#! CreateVisualization(
#!     rec( tool := "canvas", height := 300 ),
#!     """
#!     // visualization is the canvas element
#!     var context = visualization.getContext( '2d' );
#!     // draw an X
#!     context.beginPath();
#!     context.moveTo( 0, 0 );
#!     context.lineTo( 100, 100 );
#!     context.moveTo( 100, 0 );
#!     context.lineTo( 0, 100 );
#!     context.stroke();
#!     """
#! );
#! @EndLog
#!
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics{canvas-example.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="200" src="canvas-example.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! @Subsection Example: Plain HTML
#! @SectionLabel plainhtml
#!
#! This is the degenerate example of a visualization.  It does not create
#! any visualization, but lets you specify arbitrary HTML content instead.
#! It is provided here merely as a convenient way to insert HTML into the
#! notebook.
#!
#! @BeginLog
#! CreateVisualiation(
#!     rec(
#!         tool := "html",
#!         data := rec(
#!             html := "<i>Any</i> HTML can go here.  Tables, buttons, whatever."
#!         )
#!     ),
#!     """
#!     // Here you could install event handlers on tools created above.
#!     // For example, if you had created a button with id="myButton":
#!     var button = document.getElementById( "myButton" );
#!     button.addEventListener( "click", function () {
#!         alert( "My button was clicked." );
#!     } );
#!     """
#! );
#! @EndLog
#!
#! When writing such JavaScript code, note that the Jupyter Notebook has
#! access to a useful function that this package has installed,
#! <Code>runGAP</Code>.  Its signature is
#! <Code>runGAP(stringToEvaluate,callback)</Code> and the following code
#! shows an example of how you could call it from JavaScript in the
#! notebook.
#!
#! @BeginLog
#! runGAP( "2^100;", function ( result, error ) {
#!     if ( result )
#!         alert( "2^100 = " + result );
#!     else
#!         alert( "GAP gave this error: " + error );
#! } );
#! @EndLog
#!
#! This function is not available if running this package outside of a
#! Jupyter Notebook.
#!
#! @Subsection Example: D3
#!
#! While D3 is one of the most famous and powerful JavaScript visualization
#! libraries, it does not have a JSON interface.  Consequently, we can
#! interact with D3 only through the JavaScript code passed in the second
#! parameter to <Ref Func="CreateVisualization"/>.  This makes it much less
#! convenient, but we include it in this package for those who need it.
#!
#! @BeginLog
#! CreateVisualization(
#!     rec( tool := "d3" ),
#!     """
#!     // arbitrary JavaScript code can go here to interact with D3, like so:
#!     d3.select( visualization ).append( "circle" )
#!         .attr( "r", 50 ).attr( "cx", 55 ).attr( "cy", 55 )
#!         .style( "stroke", "red" ).style( "fill", "pink" );
#!     """
#! );
#! @EndLog
#!
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics{d3-example.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="200" src="d3-example.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
