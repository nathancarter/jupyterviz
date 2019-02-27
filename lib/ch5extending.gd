#!
#! @Chapter Adding new visualization tools
#! @ChapterLabel extend
#!
#! @Section Why you might want to do this
#!
#! The visualization tools made available by this package (Plotly, D3,
#! CanvasJS, etc.) provide many visualization options.  However, you may
#! come across a situation that they do not cover.  Or a new and better tool
#! may be invented after this package is created, and you wish to add it to
#! the package.
#!
#! There are two supported way to do this.  First, for tools that you wish
#! to be available to all users of this package, you can alter the package
#! code itself to include the tool.  (Then please create a pull request so
#! that your work might be shared with other &GAP; users in a subsequent
#! release of this package.)  Second, for tools that you need for
#! just one project or just one other package, there is support for
#! installing such tools at runtime.  This chapter documents both
#! approaches, each in its own section.  But first, we begin with the list
#! of what you will need to have on hand before you begin, which is the same
#! for both approaches.
#!
#! @Section What you will need
#!
#! Begin by gathering the following information.
#!  * A URL on the internet that serves the JavaScript code defining the new
#!    visualization tool you wish to add.  For instance, the ChartJS library
#!    is imported from CloudFlare, at
#!    <URL>https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.bundle.min.js</URL>.
#!    It is best if you have this URL from a Content Delivery Network (CDN)
#!    to ensure very high availability.  This URL may not be necessary in
#!    all cases.  For instance, perhaps the new visualization tool you wish
#!    to install can be defined using the basic JavaScript features in all
#!    browsers, or is imported via an <Code>iframe</Code> rather
#!    than as a script in the page itself.  If you choose to use such
#!    a URL, it will be imported using RequireJS, which expects you to omit
#!    the final <Code>.js</Code> suffix at the end.
#!  * Knowledge of how to write a short JavaScript function that can embed
#!    the given tool into any given DOM <Code>Element</Code>.  For many
#!    tools, this is just a single call to the main class's contructor or
#!    the library's initialization function.  Or, if you haven't imported
#!    any library that constructs the visualization for you, then this
#!    function may be more extensive, as you construct the visualization
#!    yourself.
#!  * While not necessary, it makes things easy if you know a function to
#!    call in your chosen library that converts JSON data into a
#!    visualization.  This makes it easier for users to pass all the
#!    required data and options from &GAP; code, which is the typical
#!    user's preferred way of defining a visualization.
#!
#! With this information available, proceed to either of the next two
#! sections, depending on whether you intend to upgrade this package itself
#! with a new visualization, or just install one into it at runtime.
#!
#! @Section Extending this package with a new tool
#! @SectionLabel extending
#!
#! This section explains how to enhance this package itself.  If you follow
#! these instructions, you should submit a pull request to have your work
#! added to the main repository for the package, and thus eventually
#! included in the next release of &GAP;.
#!
#! If instead you wish to install a new visualization at runtime for just
#! your own use in a particular project (or in a package that depends on
#! this one), refer to the instructions in the Section
#! <Ref Sect="Section_runtime_extend"/> instead.
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
#!     // The variable "element" is the HTML element in the page into
#!     // which you should place your visualization.  For example, perhaps
#!     // your new toolkit does its work in an SVG element, so you need one:
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
#!     If you are testing in a Jupyter Notebook, you may be able to notice
#!     the change only if you refresh in your  browser the page containing
#!     notebook and also restart the &GAP; kernel in that same page.  Then
#!     try code like the following to test what you've done.
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "NEWTOOL",
#!     # any other data you need goes here as a GAP record,
#!     # which the GAP json package will convert into JSON
#! ) );
#! @EndLog
#! </Item>
#! </Enum>
#!
#! At this point, you have added support in
#! <Ref Func="CreateVisualization"/> for the new tool but have not extended
#! that support to include the high-level functions <Ref Func="Plot"/> or
#! <Ref Func="PlotGraph"/>.  If possible, you should add that support as
#! well, by following the steps below.
#!
#! <Enum>
#!   <Item>Read the documentation for either
#!     <Ref Func="ConvertDataSeriesForTool"/> or
#!     <Ref Func="ConvertGraphForTool"/>, depending on whether the new tool
#!     you have installed supports plots or graphs.  If it supports both,
#!     read both.  That documentation explains the new function you would
#!     need to install in one or both of those records in order to convert
#!     the type of data users provide to <Ref Func="Plot"/> or
#!     <Ref Func="PlotGraph"/> into the type of data used by
#!     <Ref Func="CreateVisualization"/>.</Item>
#!   <Item>Edit the <File>main.gi</File> file in this package.  Find the
#!     section in which new elements are added to the
#!     <Ref Func="ConvertDataSeriesForTool"/> or
#!     <Ref Func="ConvertGraphForTool"/> records.  Add a new section of
#!     code that installs a new field for your tool.  It will look like
#!     one of the following two blocks (or both if your tool supports both
#!     types of visualization).
#! @BeginLog
#! ConvertDataSeriesForTool.NEWTOOL := function ( series )
#!   local result;
#!   # Write the code here that builds the components of the
#!   # GAP record you need, stored in result.
#!   # You can leverage series.x, series.y, and series.options.
#!   return result;
#! end;
#! ConvertGraphForTool.NEWTOOL := function ( graph )
#!   local result;
#!   # Write the code here that builds the components of the
#!   # GAP record you need, stored in result.
#!   # You can leverage graph.vertices, graph.edges, and graph.options.
#!   return result;
#! end;
#! @EndLog
#! </Item>
#!   <Item>Test your work by loading the updated package into &GAP; and
#!     making a call to <Ref Func="Plot"/> or
#!     <Ref Func="PlotGraph"/> that specifically requests the use of your
#!     newly-supported visualization tool.
#! @BeginLog
#! # for plots:
#! Plot( x -> x^2, rec( tool := "NEWTOOL" ) );
#! # or for graphs:
#! PlotGraph( RandomMat( 5, 5 ), rec( tool := "NEWTOOL" ) );
#! @EndLog
#! Verify that it produces the desired results.
#! </Item>
#!   <Item>Once your changes work, commit them to the repository and submit
#!     a pull request back to the original repository, to have your work
#!     included in the default distribution.</Item>
#! </Enum>
#!
#! A complete and working (but silly) example follows.  It is a tiny enough
#! visualization tool that it cannot support either plotting data nor
#! drawing graphs, so we don't have to install high-level API support.
#!
#! This portion would go in <File>lib/js/viz-tool-color.js</File>:
#!
#! @BeginLog
#! // No need to import any library from a CDN for this little example.
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
#! @Section Installing a new tool at runtime
#! @SectionLabel runtime_extend
#!
#! This section explains how to add a new visualization tool to this
#! package at runtime, by calling functions built into the package.  This is
#! most useful when the visualization tool you wish to install is useful in
#! only a narrow context, such as one of your projects or packages.
#!
#! If you have a visualization tool that might be of use to anyone who uses
#! this package, consider instead adding it to the package itself and
#! submitting a pull request to have it included in the next release.  The
#! previous section explains how to do that.
#!
#! To install a new visualization tool at runtime, you have two methods
#! available.  You can either provide all the JavaScript code yourself or
#! you can provide the necessary ingredients that will be automatically
#! filled into a pre-existing JavaScript code template.  We will examine
#! both methods in this section.
#!
#! The previous section thoroughly documents the two types of code that are
#! likely to show up in the definition of a new tool: the installation into
#! RequireJS of the tool's CDN URL and the installation into
#! <Code>window.VisualizationTool</Code> of a function that uses that tool
#! to create a visualization from a given JSON object.
#!
#! If you have all of this JavaScript code already stored in a single GAP
#! string (or in a file that you can load into a string), call it
#! <Code>S</Code>, then you can install it into this package with a single
#! function call, like so:
#! @BeginLog
#! InstallVisualizationTool( "TOOL_NAME_HERE", S );
#! @EndLog
#! Here is a trivial working example.  It is sufficiently small that it does
#! not install any new JavaScript libraries into RequireJS.
#! @BeginLog
#! # GAP code to install a new visualization tool:
#! InstallVisualizationTool( "smallExample",
#! """
#! window.VisualizationTool.smallExample =
#! function ( element, json, callback ) {
#!     element.innerHTML = '<span color=red>' + json.text + '</span>';
#!     callback( element, element.childNodes[0] );
#! }
#! """
#! ) );
#!
#! # GAP code to use that new visualization tool:
#! CreateVisualization( rec(
#!     tool := "smallExample",
#!     text := "This text will show up red."
#! ) );
#! @EndLog
#!
#! Because the assignment of a function to create visualizations from JSON
#! is the essential component of installing a new visualization, we have
#! made that step easier by creating a template into which you can just fill
#! in the function body.  So the above call to
#! <Ref Func="InstallVisualizationTool"/> is equivalent to the following
#! call to <Ref Func="InstallVisualizationToolFromTemplate"/>.
#! @BeginLog
#! InstallVisualizationToolFromTemplate( "smallExample",
#! """
#!     element.innerHTML = '<span color=red>' + json.text + '</span>';
#!     callback( element, element.childNodes[0] );
#! """
#! ) );
#! @EndLog
#!
#! If you provide a third parametr to
#! <Ref Func="InstallVisualizationToolFromTemplate"/>, it is treated as the
#! CDN URL for an external library, and code is automatically inserted that
#! installs that external library into RequireJS and wraps the tool's
#! function body in a <Code>require</Code> call.  For instance, the
#! CanvasJS library (which is built into this package) could have been
#! installed with code like the following.
#! @BeginLog
#! InstallVisualizationToolFromTemplate( "canvasjs",
#! """
#!     ( new window.CanvasJS.Chart( element, json.data ) ).render();
#!     window.resizeToShowContents( element );
#!     callback( element, element.childNodes[0] );
#! """,
#! "https://cdnjs.cloudflare.com/ajax/libs/canvasjs/1.7.0/canvasjs.min.js"
#! ) );
#! @EndLog
#! While RequireJS demands that you omit the <Code>.js</Code> suffix from
#! such an URL, <Ref Func="InstallVisualizationToolFromTemplate"/> will
#! automatically remove it for you if you forget to remove it.
#!
#! After using either of those two methods, if the new visualization tool
#! is capable of drawing either plots or graphs, and you wish to expose it
#! to the high-level API, you should follow the steps for doing so
#! documented in the second half of Section <Ref Sect="Section_extending"/>.
