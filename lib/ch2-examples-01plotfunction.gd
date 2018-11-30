#! @Chapter Examples
#! 
#! @Section Simple line plot
#! @SectionLabel Ex01plotfunction
#! 
#! The most common thing you might want to do is plot a function on
#! coordinate axes.  To do so, simply choose a list of $x$ values and
#! pass them to `Plot` with the function.
#! 
#! @BeginLog
#! Plot( [1..50], NrSmallGroups );
#! @EndLog
#! 
#! The default plotting tool is `plotly`, but you can change that
#! easily, as later examples show.
#! 

#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{01plotfunction.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="01plotfunction.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
