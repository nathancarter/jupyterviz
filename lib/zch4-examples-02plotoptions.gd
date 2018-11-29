#! @Chapter Examples
#! 
#! @Section Adding an options parameter
#! @SectionLabel Ex02plotoptions
#! 
#! You can append a final parameter to the `Plot` command, a record
#! containing a set of options.  Here is an example of using that
#! options record to choose the visualization tool, title, and axis
#! labels.
#! 
#! @BeginLog
#! Plot( [1..50], n -> Length( DivisorsInt( n ) ),
#!       rec(
#!           tool := "chartjs",
#!           title := "Number of divisors of some small integers",
#!           xaxis := "n",
#!           yaxis := "number of divisors of n"
#! ) );
#! @EndLog

#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[height=3in]{02plotoptions.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img height="350" src="02plotoptions.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
