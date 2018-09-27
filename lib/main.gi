#############################################################################
##
#W  main.gi              Jupyter-Viz Package                  Nathan Carter
##
##  Installation file for functions of the Jupyter-Viz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##

#############################################################################
##
#F  RunJavaScript(<script>)
##
##  runs the given JavaScript code in the current Jupyter notebook
##
##  This function actually produces and returns an object that, if it is the
##  result displayed in a Jupyter notebook cell, will be treated, by the
##  notebook, as instructions to run the given JavaScript code, which should
##  be a string.
##
##  The output element in the notebook will be passed called "element" in
##  the script's environment, which we capture with the closure wrapper
##  below, so that any callbacks or asynchronous code can rely on its having
##  that name indefinitely.
##
InstallGlobalFunction( RunJavaScript, function ( script )
    return JupyterRenderable( rec(
        ( "application/javascript" ) := Concatenation(
            "( function ( element ) { ", script, " } )( element.get( 0 ) )"
        )
    ), rec() );
end );

#E  main.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here