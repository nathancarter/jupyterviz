############################################################################
##
#W  main.gi              Jupyter-Viz Package                  Nathan Carter
##
##  Installation file for functions of the Jupyter-Viz package.
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


##  This function is intentionally undocumented, because it is for internal
##  use by this package.  It converts a filename relative to the
##  package/lib/js/ folder into an absolute filename, suffixing it with .js
##  iff needed.
InstallGlobalFunction( JUPVIZ_AbsoluteJavaScriptFilename,
function ( relativeFilename )
    if not EndsWith( relativeFilename, ".js" ) then
        relativeFilename := Concatenation( relativeFilename, ".js" );
    fi;
    return Filename( DirectoriesPackageLibrary(
        "jupyter-viz", "lib/js" )[1], relativeFilename );
end );


##  This variable is intentionally undocumented, because it is for internal
##  use by this package.  It caches JavaScript files loaded from disk, so
##  that we can go to the filesystem for them only once per GAP session.
InstallValue( JUPVIZ_LoadedJavaScriptCache, rec( ) );


############################################################################
##
#F  LoadJavaScriptFile(<filename>)
##
##  loads the given file from disk, within the package's lib/js directory
##
##  Returns the string contents of the file.  If the file has been loaded
##  before in this GAP session, it will not be reloaded, but will be
##  returned from a cache in memory, for efficiency.
##
##  A ".js" extension will be added to the filename iff needed.  A ".min.js"
##  extension will be added iff such a file exists, to prioritize minified
##  versions of files.
##
##  If no such file exists, returns fail and caches nothing.
##
InstallGlobalFunction( LoadJavaScriptFile, function ( filename )
    local absolute, result;
    if IsBound( JUPVIZ_LoadedJavaScriptCache.( filename ) ) then
        return JUPVIZ_LoadedJavaScriptCache.( filename );
    fi;
    absolute := JUPVIZ_AbsoluteJavaScriptFilename(
        Concatenation( filename, ".min" ) );
    if not IsExistingFile( absolute ) then
        absolute := JUPVIZ_AbsoluteJavaScriptFilename( filename );
    fi;
    if not IsExistingFile( absolute ) then
        return fail;
    fi;
    result := ReadAll( InputTextFile( absolute ) );
    JUPVIZ_LoadedJavaScriptCache.( filename ) := result;
    return result;
end );


############################################################################
##
#F  JUPVIZ_FillInJavaScriptTemplate(<filename>,<dictionary>)
##
##  loads a template file and fills it in using the given dictionary
##
##  Loads the contents of the given file using the LoadJavaScriptFile
##  function.  For every key of the given dictionary, prefix a dollar sign
##  and replace all instance of that new key with the given value.  For
##  instance, if the dictionary maps "foo" to "some text" then every
##  occurrence of "$foo" in the file will be replaced by "some text" before
##  being returned.  This treats the file as a template whose parameters are
##  the $-prefixed keys in the given dictionary.  Returns the result as a
##  string.
##
##  Each substitution is followed by a newline, so that if the substituted
##  text contains a JavaScript one-line comment, it will not inadvertently
##  comment out any subsequent code in the template.
##
##  If no such file exists, returns fail.
##
InstallGlobalFunction( JUPVIZ_FillInJavaScriptTemplate,
function ( filename, dictionary )
    local key, result;
    result := LoadJavaScriptFile( filename );
    if result = fail then
        return fail;
    fi;
    for key in RecNames( dictionary ) do
        result := ReplacedString( result,
            Concatenation( "$", key ),
            # to permit //-style comments, we must add \n:
            Concatenation( dictionary.( key ), "\n" )
        );
    od;
    return result;
end );


##  This function is intentionally undocumented, because it is for internal
##  use by this package.  It composes the fill-in-template function with the
##  the RunJavaScript function, for convenience.
InstallGlobalFunction( JUPVIZ_RunJavaScriptFromTemplate,
function ( filename, dictionary )
    return RunJavaScript(
        JUPVIZ_FillInJavaScriptTemplate( filename, dictionary ) );
end );


##  This function is intentionally undocumented, because it is for internal
##  use by this package.  It runs the given code, but after pasting it into
##  a template that ensures that window.runGAP() is defined.
InstallGlobalFunction( JUPVIZ_RunJavaScriptUsingRunGAP, function ( jsCode )
    return JUPVIZ_RunJavaScriptFromTemplate( "using-runGAP",
        rec( runThis := jsCode ) );
end );


#E  main.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
