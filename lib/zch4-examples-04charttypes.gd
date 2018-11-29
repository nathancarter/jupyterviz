#! @Chapter Examples
#! 
#! @Section Types of plots
#! @SectionLabel Ex04charttypes
#! 
#! The default plot type is "line", as you've been seeing in the
#! preceding examples.  You can also choose "bar", "column", "pie",
#! and others.  Let's use a pie chart to show the relative sizes of
#! the conjugacy classes in a group.
#! 
#! @BeginLog
#! G := Group( (1,2,3,4,5,6,7), (1,2) );;
#! CCs := ConjugacyClasses( G );;
#! Plot(
#!     # for class labels, we'll use the first element in the class
#!     List( CCs, C -> PrintString( Set( C )[1] ) ),
#!     # for class sizes, we have to ask for the class as a set
#!     List( CCs, C -> Length( Set( C ) ) ),
#!     # ask for a pie chart with enough height to read the legend
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
