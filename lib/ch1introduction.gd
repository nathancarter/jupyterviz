#!
#! @Chapter Introduction
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
#! chart, scatter chart) in a Jupyter notebook.  It also allows the user to
#! attach actions to the elements of these charts, which result in
#! callbacks to &GAP; that can update the visualization.
#!
#! This visualization package has different aims in three ways.  First, it
#! can function either in a Jupyter notebook or directly from the &GAP;
#! REPL on the command line.  Second, it aims to make a wider variety of
#! visualizations accessible to &GAP; users.  Third, it does not provide
#! tools for conveniently making such visualizations interactive.  Where
#! the <Package>francy</Package> package excels at interactive
#! visualizations, this package instead gives a broader scope of
#! visualization tools and does not require Jupyter.
#!
#! These goals are achieved by importing several existing JavaScript
#! visualization toolkits and exposing them to &GAP; code, as described
#! later in this manual.
#!
#! @Section Terminology (What is a Graph?)
#! @SectionLabel term
#!
#! There is an unfortunate ambiguity about the word "graph" in mathematics.
#! It is used to mean both "the graph of a function drawn on coordinate
#! axes" and "a collection of vertices with edges connecting them."  This is
#! particularly troublesome in a package like this one, where we will
#! provide tools for drawing both of these things!  Consequently, we remove
#! the ambiguity as follows.
#!
#! We will say "charts and plots" to refer to the first concept (lines,
#! curves, bars, dots, etc. on coordinate axes) and "graphs" (or sometimes
#! "graph drawing") to refer only to the second concept (vertices and
#! edges).  This convention holds throughout this entire document.
#!
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \begin{tabular}{c c c}
#!         \includegraphics[height=1.6in]{squared-ints.png} &amp; ~ &amp;
#!         \includegraphics[height=1.6in]{random-graph-10.png} \\
#!         A plot or chart &amp; &amp; A graph
#!         \end{tabular}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<table align="center" border=0><tr><td><img height="200" src="squared-ints.png"/></td><td><img height="200" src="random-graph-10.png"/></td></tr><tr><td>A plot or chart</td><td>A graph</td></tr></table>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting images not shown here.</Alt>
#!
#! To support both of these types of visualizations, this package imports
#! a breadth of JavaScript visualization libraries (and you can extend it
#! with more, as in Chapter <Ref Chap="Chapter_extend"/>).  We split them
#! into the categories defined above.
#!
#! @Subsection Toolkits for drawing charts and plots
#!
#!  * <URL Text="AnyChart">https://www.anychart.com/</URL>
#!  * <URL Text="CanvasJS">https://canvasjs.com/</URL>
#!  * <URL Text="ChartJS">https://www.chartjs.org/</URL>
#!  * <URL Text="Plotly">https://plot.ly/</URL> (the default tool used when
#!    you call <Ref Func="Plot"/>)
#!
#! @Subsection Toolkits for drawing graphs
#!
#!  * <URL Text="Cytoscape">http://www.cytoscape.org/</URL> (the default
#!    tool used when you call <Ref Func="PlotGraph"/>)
#!
#! @Subsection General purpose tools with which you can define custom visualizations
#!
#!  * <URL Text="D3">https://d3js.org/</URL>
#!  * Native HTML <Code>canvas</Code> element
#!  * Plain HTML
#!
#! @Section The high-level API and the low-level API
#!
#! This package exposes the JavaScript tools to the &GAP; user in two ways.
#!
#! Foundationally, a low-level API gives direct access to the JSON passed to
#! those tools and to JavaScript code for manipulating the visualizations
#! the tools create.  This is powerful but not convenient to use.
#!
#! More conveniently, a high-level API gives two functions, one for creating
#! plots and charts (<Ref Func="Plot"/>) and one for creating graphs
#! (<Ref Func="PlotGraph"/>).  The high-level API should handle the vast
#! majority of use cases, but if an option you need is not supported by it,
#! there is still the low-level API on which you can fall back.
#!
#! @Section Loading the package (in Jupyter or otherwise)
#!
#! To import this package, use the following &GAP; command from the command
#! line or from a cell in a Jupyter notebook running a &GAP; kernel.
#! @Example
#! LoadPackage( "jupyterviz" );
#! @EndExample
#!
#! To see how to use the package, we recommend next reading Chapter
#! <Ref Chap="Chapter_high"/> on the high-level API, and if you find it
#! necessary, also Chapter <Ref Chap="Chapter_low"/> on the low-level API.
#! Each chapter contains numerous examples of how to use the package.
#!
