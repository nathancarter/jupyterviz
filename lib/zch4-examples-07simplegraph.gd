#! @Chapter Examples
#! 
#! @Section Drawing a simple graph
#! @SectionLabel Ex07simplegraph
#! 
#! Previous examples dealt with charting and plotting, but now we
#! transition into examples on graph drawing (with vertices and
#! edges).  Thus we begin using the `PlotGraph` function.
#! 
#! It can take a vertex set and relation, as shown below.
#! 
#! @BeginLog
#! G := Group( (1,2,3), (1,2) );;
#! S := function ( H, G ) return IsSubgroup( G, H ); end;;
#! PlotGraph( AllSubgroups( G ), S );
#! @EndLog
#! 
#! As you can see below, this doesn't look as nice as we'd like, so
#! let's consider how to improve it in the next example.
#! 

#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{07simplegraph.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="07simplegraph.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
