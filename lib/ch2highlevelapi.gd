#! @Chapter Using the high-level API
#! @ChapterLabel high
#!
#! @Section Charts and Plots
#!
#! This section covers the <Ref Func="Plot"/> function in the high-level
#! API, which is used for showing charts and plots.  If invoked in a Jupyter
#! Notebook, it will show the resulting visualization in the appropriate
#! output cell of the notebook.  If invoked from the &GAP; command line, it
#! will use the system default web browser to show the resulting
#! visualization, from which the user can save a permanent copy, print it,
#! etc.  This section covers that function through a series of
#! examples, but you can see full details in the function reference in
#! Chapter <Ref Chap="Chapter_funcref"/>.
#!
#! To plot a list of numbers as a single data series, just pass the list to
#! <Ref Func="Plot"/>.
#!
#! @BeginLog
#! Plot( [ 6.2, 0.3, 9.1, 8.8 ] );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{plot-1.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="plot-1.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! Notice that the default <Math>x</Math> values for the data are the
#! sequence <Code>[1..n]</Code>, where <Math>n</Math> is the length of the
#! data.  You can specify the <Math>x</Math> values manually, like so:
#!
#! @BeginLog
#! Plot( [ 1 .. 4 ], [ 6.2, 0.3, 9.1, 8.8 ] );
#! @EndLog
#!
#! This is useful if you have a scatter plot of data to make, or if your
#! <Math>x</Math> values are not numbers at all.
#!
#! @BeginLog
#! Plot( [ "Mon", "Tue", "Wed", "Thu" ], [ 6.2, 0.3, 9.1, 8.8 ] );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{plot-2.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="plot-2.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! It is also permissible to send in a list of <Math>(x,y)</Math> pairs
#! rather than placing the <Math>x</Math>s and <Math>y</Math>s in separate
#! lists.  This would do the same as the previous:
#!
#! @BeginLog
#! Plot( [ [ "Mon", 6.2 ], [ "Tue", 0.3 ], [ "Wed", 9.1 ], [ "Thu", 8.8 ] ] );
#! @EndLog
#!
#! You can also pass a single-variable numeric function to have it plotted.
#!
#! @BeginLog
#! Plot( x -> x^0.5 );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{plot-3.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="plot-3.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! It assumes a small domain of positive integers, which you can customize
#! as follows.  Note that the <Math>x</Math> values are passed just as
#! before, but in place of the <Math>y</Math> values, we pass the function
#! that computes them.
#!
#! @BeginLog
#! Plot( [1..50], NrSmallGroups );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{01plotfunction.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="01plotfunction.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! You can append a final parameter to the <Ref Func="Plot"/> command, a
#! record containing a set of options.  Here is an example of using that
#! options record to choose the visualization tool, title, and axis
#! labels.  Section <Ref Sect="Section_plotopts"/> covers options in
#! detail; this is only a preview.
#!
#! @BeginLog
#! Plot( [1..50], n -> Length( DivisorsInt( n ) ),
#!       rec(
#!           tool := "chartjs",
#!           title := "Number of divisors of some small integers",
#!           xaxis := "n",
#!           yaxis := "number of divisors of n"
#!       )
#! );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=2.5in]{02plotoptions.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="300" src="02plotoptions.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! You can also put multiple data series (or functions) on the same plot.
#! Let's pretend you wanted to compare the number of divisors of
#! <Math>n</Math> with the number of groups of order <Math>n</Math> for the
#! first 50 positive integers <Math>n</Math>.
#!
#! To do so, take each call you would make to <Ref Func="Plot"/> to make the
#! separate plots, and place those arguments in a list.  Pass both lists to
#! <Ref Func="Plot"/> to combine the plots, as shown below.  You can put
#! the options record in either list.  Options specified earlier take
#! precedence if there's a conflict.
#!
#! @BeginLog
#! # We're combining Plot( [1..50], NrSmallGroups );
#! # with Plot( [1..50], n -> Length( DivisorsInt( n ) ) );
#! # and adding some options:
#! Plot(
#!     [ [1..50], NrSmallGroups,
#!       rec( title := "Comparison", tool := "anychart" ) ],
#!     [ [1..50], n -> Length( DivisorsInt( n ) ) ]
#! );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{03dataseries.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="03dataseries.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! The default plot type is "line", as you've been seeing in the
#! preceding examples.  You can also choose "bar", "column", "pie",
#! and others.  Let's use a pie chart to show the relative sizes of
#! the conjugacy classes in a group.
#!
#! @BeginLog
#! G := Group( (1,2,3,4,5,6,7), (1,2) );;
#! CCs := List( ConjugacyClasses( G ), Set );;
#! Plot(
#!     # x values are class labels; we'll use the first element in the class
#!     List( CCs, C -> PrintString( C[1] ) ),
#!     # y values are class sizes; these determine the size of pie slices
#!     List( CCs, Length ),
#!     # ask for a pie chart with enough height that we can read the legend
#!     rec( type := "pie", height := 500 )
#! );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{04charttypes.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="04charttypes.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! @Section Options for charts and plots
#! @SectionLabel plotopts
#!
#! The options record passed as the final parameter to <Ref Func="Plot"/>
#! (or as the final element in each list passed to <Ref Func="Plot"/>, if
#! you are plotting multiple series on the same plot) can have the following
#! entries.
#! <List>
#!   <Item><Code>tool</Code> - the visualization tool to use to make
#!     the plot, as a string.  The default is "plotly".  The full list
#!     of tools is available in Section <Ref Sect="Section_term"/>.</Item>
#!   <Item><Code>type</Code> - the type of chart, as a string, the
#!     default for which is "line".  Which types are available depends
#!     on which tool you are using, though it is safe to assume that
#!     most common chart types (line, bar, pie) are supported by all
#!     tools.  Section <Ref Sect="Section_tooldocs"/> contains links to
#!     the documentation for each tool, so that you might see its
#!     full list of capabilities.</Item>
#!   <Item><Code>height</Code> - the height in pixels of the
#!     visualization to produce.  A sensible default is provided,
#!     which varies by tool.</Item>
#!   <Item><Code>width</Code> - the width in pixels of the
#!     visualization to produce.  If omitted, the tool usually fills
#!     the width available.  In a Jupyter Notebook output cell, this is
#!     the width of the cell.  A visualization shown outside of a Jupyter
#!     notebook will take up the entire width of the web page in which
#!     it is displayed.</Item>
#!   <Item><Code>title</Code> - the title to place at the top of the
#!     chart, as a string.  Can be omitted.</Item>
#!   <Item><Code>xaxis</Code> - the text to write below the
#!     <Math>x</Math> axis, as a string.  Can be omitted.</Item>
#!   <Item><Code>yaxis</Code> - the text to write to the left of the
#!     <Math>y</Math> axis, as a string.  Can be omitted.</Item>
#!   <Item><Code>name</Code> - this option should be specified in the
#!     options object for each separate data series, as opposed to just once
#!     for the entire plot.  It assigns a string name to that data series,
#!     typically included in the chart's legend.</Item>
#! </List>
#!
#! @Section Graphs
#!
#! This section covers the <Ref Func="PlotGraph"/> function in the
#! high-level API, which is used for drawing graphs.  If invoked in a
#! Jupyter Notebook, it will show the resulting visualization in the
#! appropriate output cell of the notebook.  If invoked from the &GAP;
#! command line, it will use the system default web browser to show the
#! resulting visualization.  This section covers that function through a
#! series of examples, but you can see full details in the function
#! reference in Chapter <Ref Chap="Chapter_funcref"/>.
#!
#! You can make a graph by calling <Ref Func="PlotGraph"/> on a list of
#! edges, each of which is a pair (a list of length two).
#!
#! @BeginLog
#! PlotGraph( [ [ "start", "option1" ], [ "start", "option2" ],
#!              [ "option1", "end" ], [ "option2", "end" ] ] );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=1.5in]{graph-1.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="180" src="graph-1.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! Vertex names can be strings, as shown above, or any &GAP; data; they will
#! be converted to strings using <Code>PrintString</Code>.  As you can see,
#! the set of vertices is assumed to be the set of things mentioned in the
#! edges.  But you can specify the vertex set separately.
#!
#! For example, if you wanted to graph the divisibility relation on a set
#! of integers, some elements may not be included in any edge.
#!
#! @BeginLog
#! PlotGraph( [ 2 .. 10 ],
#!            [ [ 2, 4 ], [ 2, 6 ], [ 2, 8 ], [ 2, 10 ],
#!              [ 3, 6 ], [ 3, 9 ], [ 4, 8 ], [ 5, 10 ] ] );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{graph-2.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="graph-2.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! But for anything other than a small graph, specifying the vertex or edge
#! set manually may be inconvenient.  Thus if you have a vertex set, you can
#! create the edge set by passing a binary relation as a &GAP; function.
#! Here is an example to create a subgroup lattice.
#!
#! @BeginLog
#! G := Group( (1,2,3), (1,2) );
#! S := function ( H, G )
#!     return IsSubgroup( G, H ) and H <> G;
#! end;
#! PlotGraph( AllSubgroups( G ), S );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=2in]{graph-3.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="240" src="graph-3.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! But all three of the graphs just shown would be better if they had
#! directed edges.  And we might want to organize them differently in the
#! view, perhaps even with some colors, etc.  To this end, you can pass an
#! options parameter as the final parameter to <Ref Func="PlotGraph"/>,
#! just as you could for <Ref Func="Plot"/>.
#!
#! @BeginLog
#! G := Group( (1,2,3), (1,2) );
#! S := function ( H, G )
#!     return IsSubgroup( G, H ) and H <> G;
#! end;
#! PlotGraph( AllSubgroups( G ), S,
#!     rec( directed := true, layout := "grid", arrowscale := 3 ) );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=2in]{graph-4.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="240" src="graph-4.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#!
#! The next section covers all options in detail.
#!
#! @Section Options for graphs
#! @SectionLabel graphopts
#!
#! The options record passed as the final parameter to
#! <Ref Func="PlotGraph"/> can have the following entries.
#! <List>
#!   <Item><Code>tool</Code> - the visualization tool to use to make
#!     the plot, as a string.  The default is "cytoscape".  The full
#!     list of tools is available in Section
#!     <Ref Sect="Section_term"/>.</Item>
#!   <Item><Code>layout</Code> - the name of the layout algorithm to
#!     use, as a string.  Permitted values vary by tool.  Currently
#!     cytoscape supports "preset" (meaning you must have specified
#!     the nodes' positions manually), "cose" (virtual-spring-based
#!     automatic layout), "random", "grid", "circle", "concentric"
#!     (multiple concentric circles), and "breadthfirst" (a
#!     hierarchy).</Item>
#!   <Item><Code>vertexwidth</Code> and <Code>vertexheight</Code> -
#!     the dimensions of each vertex.</Item>
#!   <Item><Code>vertexcolor</Code> - the color of the vertices in the
#!     graph.  This should be a string representing an HTML color,
#!     such as "#ccc" or "red".</Item>
#!   <Item><Code>edgewidth</Code> - the thickness of each edge.</Item>
#!   <Item><Code>edgecolor</Code> - the color of each edge and its
#!     corresponding arrow.  This should be a string representing an
#!     HTML color, such as "#ccc" or "red".</Item>
#!   <Item><Code>directed</Code> - a boolean defaulting to false,
#!     whether to draw arrows to visually indicate that the graph is
#!     a directed graph</Item>
#!   <Item><Code>arrowscale</Code> - a multiplier to increase or
#!     decrease the size of arrows in a directed graph.</Item>
#!   <Item><Code>height</Code> - the height in pixels of the
#!     visualization to produce.  A sensible default is provided,
#!     which varies by tool.</Item>
#!   <Item><Code>width</Code> - the width in pixels of the
#!     visualization to produce.  If omitted, the tool usually fills
#!     the width available.  In a Jupyter Notebook output cell, this is
#!     the width of the cell.  A visualization shown outside of a Jupyter
#!     notebook will take up the entire width of the web page in which
#!     it is displayed.</Item>
#! </List>
#!
