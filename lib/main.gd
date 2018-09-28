#############################################################################
##
##
#W  main.gd              Jupyter-Viz Package                  Nathan Carter
##
##  Declaration file for functions of the Jupyter-Viz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##

############################################################################
##
#F  RunJavaScript(<script>)
##
##  runs the given JavaScript code in the current Jupyter notebook
##
##  <#GAPDoc Label="RunJavaScript">
##  <ManSection>
##  <Func Name="RunJavaScript" Arg="script"/>
##
##  <Description>
##  runs the JavaScript code <A>script</A> in the current Jupyter notebook
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction( "RunJavaScript" );

############################################################################
##
#F  JUPVIZ_AbsoluteJavaScriptFilename(<filename>)
##
##  converts a JavaScript filename to an absolute path in the package dir
##
DeclareGlobalFunction( "JUPVIZ_AbsoluteJavaScriptFilename" );

#E  main.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
