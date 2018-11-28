#!
#! @Chapter How to use this package
#!
#! @Section Purpose
#! @SectionLabel purpose
#!
#! Since 2017, it has been possible to use &GAP; in
#! <URL Text="Jupyter">http://jupyter.org/</URL> through the
#! <Package>JupyterKernel</Package> package.  Output was limited to the
#! ordinary text output &GAP; produces; charts and graphs were not possible.
#!
#! In 2018, Martins and Pfeiffer released <Package>francy</Package>
#! (<URL Text="repository">https://github.com/mcmartins/francy</URL>,
#! <URL Text="article">https://arxiv.org/abs/1806.08648</URL>), which lets
#! users create graphs of a few types (vertices and edges, line chart, bar
#! chart, scatter chart).  It also allows the user to attach actions to the
#! elements of these charts, which result in callbacks to &GAP; that can
#! update the visualization.
#!
#! This package aims to make a wider variety of visualizations accessible to
#! &GAP; users, but does not provide tools for conveniently making such
#! visualizations interactive.  Where the
#! <Package>francy</Package> package excels at interactive visualizations,
#! this package instead gives a broader scope of visualization tools.
#!
#! This is achieved by importing several existing JavaScript visualization
#! toolkits and exposing them to &GAP; code, as described later in this
#! manual.
#!
#! The toolkits currently exposed by this package are listed later in this
#! section.  Each supports its own feature set.  We distinguish informally
#! (just for the purposes of this package) between two types of
#! visualizations supported by the tools this package imports:
#!
#!  * plots - plotting one or more data series, usually on coordinate axes,
#!    using lines, bars, dots, or sometimes a pie chart
#!  * graphs - vertices connected by edges (a graph in the mathematical
#!    sense)
#!
#! While the low-level API gives access to several other types of
#! visualizations, including maps, 3D surfaces, and more, these are the two
#! types of visualizations on which the high-level API focuses.
#!
#! We now list the visualization tools this package exposes to the user, and
#! we list the types of visualizations that each can produce.
#!
#!  * <URL Text="AnyChart">https://www.anychart.com/</URL> - plots, maps
#!  * <URL Text="CanvasJS">https://canvasjs.com/</URL> - plots
#!  * <URL Text="ChartJS">https://www.chartjs.org/</URL> - plots
#!  * <URL Text="Cytoscape">http://www.cytoscape.org/</URL> - graphs
#!  * <URL Text="D3">https://d3js.org/</URL> - this is a general-purpose,
#!    low-level tool on which you can build whatever visualizations you
#!    choose, with effort
#!  * <URL Text="Plotly">https://plot.ly/</URL> - plots, maps
#!  * Native HTML <Code>canvas</Code> element - this is a general-purpose,
#!    low-level tool on which you can build whatever visualizations you
#!    choose, with effort
#!  * Plain HTML - this is a general-purpose,
#!    low-level tool on which you can build whatever visualizations you
#!    choose, with effort
#!
#! @Section Two APIs
#!
#! The package provides a high-level API and a low-level API for accessing
#! its feature set.
#!
#! The high-level API is much easier to use, but does not give the user
#! access to every last feature of the underlying visulization tools.  Most
#! users will wish to use this API.
#!
#! The low-level API requires contructing large nested &GAP; records that,
#! once converted into JSON objects, tell the visualization tools what to
#! display.  This is more work for the user but gives full control over the
#! results.
#!
#! Both of these APIs are documented in this manual.
#!
#! @Section Loading the package into a Jupyter notebook
#!
#! To import the package into a Jupyter notebook, do so just as with any
#! other &GAP; package:  Ensure that the kernel of the notebook is a &GAP;
#! kernel, then execute the following code in one of the notebook cells.
#!
#! @Example
#! LoadPackage( "jupyterviz" );
#! @EndExample
#!
#! @Section Creating a visualization
#!
#! @Subsection High-Level API
#!
#! The high-level API of this package is accessed through one of two
#! functions, <Ref Func="Plot"/> and <Ref Func="PlotGraph"/>.  We introduce
#! each here, but you can read full details about them in the next chapter.
#!
#! The <Code>Plot</Code> function produces only "plots" as defined in the
#! previous section (e.g., bar charts, line charts, pie charts, etc.).
#! It supports the following signatures.
#!
#! @BeginLog
#! # Plot a set of (x,y) pairs
#! Plot( [ [1,6.2], [2,0.3], [3,9.1], [4,8.8] ] );
#! # Plot a set of x values and a set of y values
#! Plot( [1..4], [6.2,0.3,9.1,8.8] );
#! # Or more succinctly:
#! Plot( [6.2,0.3,9.1,8.8] );
#! # Plot a function over a given domain
#! Plot( [1..10], x -> x^2 );
#! # Omitting the domain assumes 1..5
#! Plot( x -> x^0.5 );
#! # You can add options; this one is shown below
#! Plot( x -> x^2, rec( title := "Squared Integers" ) );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{squared-ints.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="squared-ints.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! For the full list of options, refer to the documentation for
#! <Ref Func="Plot"/> and <Ref Func="ConvertDataSeriesForTool"/>.
#!
#! The <Code>PlotGraph</Code> function produces only "graphs" as defined in
#! the previous section (i.e., vertices and edges).
#! It supports the following signatures.
#!
#! @BeginLog
#! # Provide vertices and edges as lists
#! PlotGraph( [ "start", "option1", "option2", "end" ],
#!            [ [ "start", "option1" ], [ "start", "option2" ],
#!              [ "option1", "end" ], [ "option2", "end" ] ] );
#! # Provide edges only, vertices inferred
#! PlotGraph( [ [ "start", "option1" ], [ "start", "option2" ],
#!              [ "option1", "end" ], [ "option2", "end" ] ] );
#! # Provide vertices and a binary edge relation
#! PlotGraph( [ "this", "will", "show", "lex", "order", "on", "words" ],
#!            function ( w1, w2 ) return w1 < w2; end );
#! # Provide an adjacency matrix; entries >0 produce an edge.
#! # This example is the one shown below.
#! # (Obviously, because it is random, your result may differ.)
#! PlotGraph( RandomMat( 10, 10 ) - 1 );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=2in]{random-graph-10.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="250" src="random-graph-10.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! For the full list of options, refer to the documentation for
#! <Ref Func="PlotGraph"/> and <Ref Func="ConvertGraphForTool"/>.
#!
#! @Subsection Low-Level API
#!
#! The low-level API is accessed through just one function,
#! <Ref Func="CreateVisualization"/>.  You can view its complete
#! documentation in the next chapter for details, but examples are given in
#! this section.
#!
#! Nearly all visualizations in this package are created by passing data to
#! the <Ref Func="CreateVisualization"/> function as records describing
#! what to draw.  (Even visualizations created by the high-level API
#! documented above call the <Ref Func="CreateVisualization"/> function
#! under the hood.)  Those records are converted into
#! <URL Text="JSON">http://www.json.org/</URL> form by the
#! <Package>json</Package> package, and handed to whichever JavaScript
#! toolkit you have chosen to use for creating the visualization (or the
#! default tool if you use a high-level function and do not specify).
#!
#! The sections below describe how to communicate, with
#! <Ref Func="CreateVisualization"/>, each of the visualization tools
#! this package makes available.  Thus <Ref Func="CreateVisualization"/> is
#! the low-level API for the entire package, and it usage is documented
#! here.
#!
#! @Subsection Example: AnyChart
#!
#! The AnyChart website contains
#! <URL Text="documentation">https://docs.anychart.com/Working_with_Data/Data_From_JSON</URL>
#! on how to create visualizations from JSON data.  Following those
#! conventions, we could give AnyChart the following JSON to produce a pie
#! chart.
#!
#! @BeginLog
#! {
#!     "chart" : {
#!         "type" : "pie",
#!         "data" : [
#!             { "x" : "Subgroups of order 6", "value" : 1 },
#!             { "x" : "Subgroups of order 3", "value" : 1 },
#!             { "x" : "Subgroups of order 2", "value" : 3 },
#!             { "x" : "Subgroups of order 1", "value" : 1 }
#!         ]
#!     }
#! }
#! @EndLog
#!
#! In &GAP;, the same data would be represented with a record, as follows.
#!
#! @BeginLog
#! myChartData := rec(
#!     chart := rec(
#!         type := "pie",
#!         data := [
#!             rec( x := "Subgroups of order 6", value := 1 ),
#!             rec( x := "Subgroups of order 3", value := 1 ),
#!             rec( x := "Subgroups of order 2", value := 3 ),
#!             rec( x := "Subgroups of order 1", value := 1 )
#!         ]
#!     )
#! );
#! @EndLog
#!
#! We can ask &GAP;, running in a Jupyter notebook, to create a
#! visualization from this data by passing that data directly to
#! <Ref Func="CreateVisualization"/>.  We wrap it in a record that must
#! specify the tool to use (in this case <Code>"anychart"</Code>) and
#! optionally some other details not relevant here.
#!
#! @BeginLog
#! CreateVisualization( rec( tool := "anychart", data := myChartData ) );
#! @EndLog
#!
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{anychart-example.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="anychart-example.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! If you have the data defining a visualization stored in a
#! <File>.json</File> file on disk, you can use the following code rather
#! than rewriting the JSON code into &GAP; code yourself.
#!
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "anychart",
#!     data := JsonStringToGap( ReadAll( InputTextFile( "your-file.json" ) ) )
#! ) );
#! @EndLog
#!
#! AnyChart can make a wide variety of charts (area, bar, box, bubble, bullet,
#! column, doughnut, and so on, for over 125 different types and subtypes).
#! Other JavaScript libraries available also have similarly broad
#! capabilities, but we do not include here examples of CanvasJS, ChartJS,
#! or Plotly, because their capabilities and purpose are somewhat similar
#! to that of AnyChart.  Though their data formats are different, you can
#! find links to those formats' documentation in the documentation for the
#! function <Ref Func="CreateVisualization"/>.  So instead future sections
#! focus on four other examples that are unlike AnyChart.
#!
#! @Subsection Post-processing visualizations
#!
#! Note that <Ref Func="CreateVisualization"/> takes an optional second
#! parameter, a string of JavaScript code to be run once the visualization
#! is complete. For example, if the visualization library did not support a
#! solid black border, but you wanted to add one, you could do so in
#! subsequent code.
#!
#! @BeginLog
#! CreateVisualization(
#!     sameDataAsAbove, # plus this new second parameter:
#!     "visualization.style.border = '5px solid black'"
#! )
#! @EndLog
#!
#! This holds for any visualization tool, not just AnyChart.  In the code
#! given in the second parameter, two variables will be defined for your
#! use: <Code>element</Code> refers to the output cell element in the
#! notebook and <Code>visualization</Code> refers to the visualization that
#! the toolkit you chose created within that output cell (also an HTML
#! element).
#!
#! @Subsection Example: Cytoscape
#!
#! Unlike AnyChart, Cytoscape is for the vertices-and-edges type of graph,
#! not the x-and-y-axes type.  A tiny Cytoscape graph (just $A\to B$) is
#! represented by the following JSON.
#!
#! @BeginLog
#! {
#!     elements : [
#!         { data : { id : "A" } },
#!         { data : { id : "B" } },
#!         { data : { id : "edge", source : "A", target : "B" } }
#!     ],
#!     layout : { name : "grid", rows : 1 }
#! }
#! @EndLog
#!
#! Cytoscape graphs can also have style attributes not shown here.
#!
#! Rather than copy this data directly into &GAP;, let's generate graph
#! data in the same format using &GAP; code.  Here we make a graph of the
#! first 50 positive integers, with $n\to m$ iff $n\mid m$ (ordinary integer
#! divisibility).
#!
#! @BeginLog
#! N := 50;
#! elements := [ ];
#! roots := [ ];
#! for i in [2..N] do
#!     Add( elements, rec( data := rec( id := String( i ) ) ) );
#!     if IsPrime( i ) then
#!         Add( roots, i );
#!     fi;
#!     for j in [2..i-1] do
#!         if i mod j = 0 then
#!             Add( elements, rec( data := rec(
#!                 source := String( j ),
#!                 target := String( i ) ) ) );
#!         fi;
#!     od;
#! od;
#! @EndLog
#!
#! We then need to choose a layout algorithm.  The Cytoscape documentation
#! suggests that the "cose" layout works well.  Here, we do choose a height
#! (in pixels) for the result, because Cytoscape does not automaticlly
#! resize visualizations to fit their contents.  We also set the style for
#! each node to display its ID (which is the integer associated with it).
#!
#! All the code below comes directly from translating the Cytoscape
#! documentation from JSON form to &GAP; record form.  See that
#! documentation for more details; it is cited in the documentation for the
#! <Ref Func="CreateVisualization"/> function.
#!
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "cytoscape",
#!     height := 600,
#!     data := rec(
#!         elements := elements, # computed in the code above
#!         layout := rec( name := "cose" ),
#!         style := [
#!             rec( selector := "node", style := rec( content := "data(id)" ) )
#!         ]
#!     )
#! ) );
#! @EndLog
#!
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{cytoscape-example.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="cytoscape-example.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
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
#!
#! @Subsection Example: Native HTML Canvas
#!
#! You can create a blank canvas, then use the existing JavaScript canvas
#! API to draw on it.
#!
#! @BeginLog
#! CreateVisualization(
#!     rec( tool := "canvas", height := 300 ),
#!     """
#!     // visualization is the canvas element
#!     var context = visualization.getContext( '2d' );
#!     // draw an X
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
#!
#! This is the degenerate example of a visualization.  It does not create
#! any visualization, but lets you specify arbitrary HTML content instead.
#! It is provided here merely as a convenient way to insert HTML into the
#! notebook.
#!
#! @BeginLog
#! CreateVisualiation( rec(
#!     tool := "html",
#!     data := rec(
#!         html := "<i>Any</i> HTML can go here.  Tables, buttons, whatever."
#!     )
#! ) );
#! @EndLog
#!
#! @Section Gallery
#!
#! Readers who would like to see a gallery of examples are encouraged to
#! inspect the following files in this package's repository and/or
#! installation directory.
#!
#!  * <File>tst/in-noteboook-test.ipynb</File> shows several different
#!    visualizations, but can only be loaded in a running Jupyter notebook
#!    with this package installed.
#!  * <File>tst/in-noteboook-test.pdf</File> is a printout, to PDF, of the
#!    previous file, with graphics included (though printing from Jupyter
#!    notebooks is not perfect, and thus the formatting of this PDF is not
#!    that great).
#!
#! Please be aware, however, that the tools imported by this package have an
#! enormous breadth of capabilities not shown in that file.  The reader is
#! encouraged to browse their websites (cited in Section
#! <Ref Sect="Section_purpose"/>) for extensive galleries of visualizations.
#!
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{canvasjs-example.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="canvasjs-example.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
