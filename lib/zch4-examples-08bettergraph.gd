#! @Chapter Examples
#! 
#! @Section Drawing a better graph
#! @SectionLabel Ex08bettergraph
#! 
#! We can improve the previous example by removing the edges from
#! each subgroup to itself.  We do so by redefining our edge relation
#! to exclude nonproper inclusions.
#! 
#! We can improve it further by making the edges directed and the
#! layout try to respect the graph's structure.  We do so by passing
#! a third argument to `PlotGraph`, a record of options.
#! 
#! @BeginLog
#! G := Group( (1,2,3), (1,2) );
#! S := function ( H, G )
#!     return IsSubgroup( G, H ) and H <> G;
#! end;
#! PlotGraph(
#!     AllSubgroups( G ), S,
#!     rec( directed := true, layout := "grid" )
#! );
#! @EndLog

#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{08bettergraph.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="08bettergraph.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
