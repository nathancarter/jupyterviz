#!
#! @Chapter Adding new visualization tools
#!
#! @Section Why you might want to do this
#!
#! The visualization tools made available by this package (Plotly, D3,
#! CanvasJS, etc.) provide many visualization options.  However, you may
#! come across a situation that they do not cover.  Or a new and better tool
#! may be invented after this package is created, and you wish to add it to
#! the package.
#!
#! Currently, the only supported way to do this is to alter the package code
#! itself.  In the future, it would be nice to make it so that you can
#! register new visualization tools with the package without modifying the
#! package code.  But until then, this is the supported method.
#!
#! @Section What you will need
#!
#! Before proceeding, you will need the following information:
#!  * A URL on the internet that serves the JavaScript code defining the new
#!    visualization tool you wish to add.  For instance, the ChartJS library
#!    is imported from CloudFlare, at
#!    <URL>https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min</URL>.
#!    It is best if you have this URL from a Content Delivery Network (CDN)
#!    to ensure very high availability.
#!  * Knowledge of how to write a short JavaScript function that can embed
#!    the given tool into any given DOM <Code>Element</Code>.  For many
#!    tools, this is just a single call to the main class's contructor or
#!    the library's initialization function.
#!  * While not necessary, it makes things easy if you know what function to
#!    call in your chosen library to define a visualization from JSON data.
#!    This makes it easier for users to pass all the required data and
#!    options from &GAP; code, which is the typical user's preferred way of
#!    defining a visualization.
#!
#! @Section The appropriate procedure
#!
#! Throughout these steps, I will assume that the name of the new tool you
#! wish to install is <Code>NEWTOOL</Code>.  I choose all capital letters
#! to make it stand out, so that you can tell where you need to fill in
#! blanks in the examples, but you should probably use lower-case letters,
#! to match the convention used by all of the built-in tools.
#!
#! <Enum>
#!   <Item>Clone the repository for this package.</Item>
#!   <Item>Enter the <File>lib/js/</File> folder in the repository.</Item>
#!   <Item>Duplicate the file <File>viz-tool-chartjs.js</File> and rename it
#!     suitably for the tool you wish to import, such as
#!     <File>viz-tool-NEWTOOL.js</File>.  It **must** begin with
#!     <File>viz-tool-</File>.</Item>
#!   <Item>Edit that file.  At the top, you will notice the installation of
#!     the CDN URL mentioned in the previous section.  Replace it with the
#!     URL for your toolkit, and replace the identifier <Code>chartjs</Code>
#!     with <Code>NEWTOOL</Code>.
#! @BeginLog
#! window.requirejs.config( {
#!     paths : {
#!         NEWTOOL : 'https://cdn.example.com/NEWTOOL.min.js'
#!     }
#! } );
#! @EndLog
#! </Item>
#!   <Item>In the middle of the same file, feel free to update the comments
#!     to reflect your toolkit rather than ChartJS.</Item>
#!   <Item>At the end of the same file, you will notice code that installs
#!     <Code>chartjs</Code> as a new function in the
#!     <Code>window.VisualizationTools</Code> object.  Replace it with code
#!     that installs your tool instead.  See the comments below for some
#!     guidance.
#! @Log
#! window.VisualizationTools.NEWTOOL = function ( element, json, callback ) {
#!     // The variable "element" is the output cell in the notebook into
#!     // which you should place your visualization.  For example, perhaps
#!     // your new toolkit draws in SVG elements, so you need one:
#!     var result = document.createElement( 'SVG' );
#!     element.append( result );
#!     // The variable "json" is all the data, in JSON form, passed from
#!     // GAP to tell you how to create a visualization.  The data format
#!     // convention is up to you to explain and document with your new
#!     // tool.  Two attributes in particular are important here, "width"
#!     // and "height" -- if you ignore everything else, at least respect
#!     // those in whatever way makes sense for your visualization.  Here
#!     // is an example for an SVG:
#!     if ( json.width ) result.width = json.width;
#!     if ( json.height ) result.width = json.height;
#!     // Then use RequireJS to import your toolkit (which will use the CDN
#!     // URL you registered above) and use it to fill the element with the
#!     // desired visualization.  You may or may not need to modify "json"
#!     // before passing it to your toolkit; this is up to the conventions
#!     // you choose to establish.
#!     require( [ 'NEWTOOL' ], function ( NEWTOOL ) {
#!         // Use your library to set up a visualization.  Example:
#!         var viz = NEWTOOL.setUpVisualizationInElement( result );
#!         // Tell your library what to draw.  Example:
#!         viz.buildVisualizationFromJSON( json );
#!         // Call the callback when you're done.  Pass the element you were
#!         // given, plus the visualization you created.
#!         callback( element, result );
#!     } );
#! };
#! @EndLog
#! </Item>
#!   <Item>Optionally, in the <File>lib/js/</File> folder, run the
#!     <File>minify-all-scripts.sh</File> script, which compresses your
#!     JavaScript code to save on data transfer, memory     allocation,
#!     and parsing time.  Rerun that script each time you change your file
#!     as well.</Item>
#!   <Item>You should now be able to use your new visualization tool in
#!     &GAP;.  Verify that your changes worked, and debug as necessary.
#!     You may be able to notice the change only if you refresh in your
#!     browser the page containing the Jupyter notebook in question and also
#!     restart the &GAP; kernel in that same page.  Then try code like the
#!     following in the Jupyter notebook to test what you've done.
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "NEWTOOL",
#!     # any other data you need goes here
#! ) );
#! @EndLog
#! </Item>
#!   <Item>Once your changes work, commit them to the repository and submit
#!     a pull request back to the original repository, to have your work
#!     included in the default distribution.</Item>
#! </Enum>
#!
#! A complete and working (but silly) example follows.
#!
#! This portion would go in <File>lib/js/viz-tool-color.js</File>:
#!
#! @BeginLog
#! // No need to import any library from a CDN for this baby example.
#! window.VisualizationTools.color = function ( element, json, callback ) {
#!     // just writes json.text in json.color, that's all
#!     var span = document.createElement( 'span' );
#!     span.textContent = json.text;
#!     span.style.color = json.color;
#!     callback( element, span );
#! };
#! @EndLog
#!
#! This is an example usage of that simple tool from &GAP; in a Jupyter
#! notebook:
#!
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "color",
#!     text := "Happy St. Patrick's Day.",
#!     color := "green"
#! ) );
#! @EndLog
#!
