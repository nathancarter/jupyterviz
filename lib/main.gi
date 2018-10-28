############################################################################
##
#W  main.gi              JupyterViz Package                  Nathan Carter
##
##  Installation file for functions of the JupyterViz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##


##  The output element in the notebook will be passed called "element" in
##  the script's environment, which we capture with the closure wrapper
##  below, so that any callbacks or asynchronous code can rely on its having
##  that name indefinitely.
InstallGlobalFunction( RunJavaScript, function ( script )
    return JupyterRenderable( rec(
        application\/javascript := Concatenation(
            # use newlines to prevent // comments from harming code
            "( function ( element ) {\n", script,
            "\n} )( element.get( 0 ) )"
        )
    ), rec(
        application\/javascript := ""
    ) );
end );


InstallGlobalFunction( JUPVIZAbsoluteJavaScriptFilename,
function ( relativeFilename )
    if not EndsWith( relativeFilename, ".js" ) then
        relativeFilename := Concatenation( relativeFilename, ".js" );
    fi;
    return Filename( DirectoriesPackageLibrary(
        "jupyterviz", "lib/js" )[1], relativeFilename );
end );


BindGlobal( "JUPVIZFileContentsType",
    NewType( NewFamily( "JUPVIZFileContentsFamily" ),
             JUPVIZIsFileContentsRep ) );
InstallMethod( JUPVIZFileContents, "for a string", [ IsString ],
function( content )
    return Objectify( JUPVIZFileContentsType,
                      rec( content := content ) );
end );
InstallMethod( JupyterRender, [ JUPVIZIsFileContents ],
function ( fileContents )
    return Objectify( JupyterRenderableType,
        rec( data := rec( text\/plain := fileContents!.content ),
             metadata := rec( text\/plain := "" ) ) );
end );


InstallValue( JUPVIZLoadedJavaScriptCache, rec( ) );
InstallGlobalFunction( LoadJavaScriptFile, function ( filename )
    local absolute, result;
    if IsBound( JUPVIZLoadedJavaScriptCache.( filename ) ) then
        return JUPVIZLoadedJavaScriptCache.( filename );
    fi;
    absolute := JUPVIZAbsoluteJavaScriptFilename(
        Concatenation( filename, ".min" ) );
    if not IsExistingFile( absolute ) then
        absolute := JUPVIZAbsoluteJavaScriptFilename( filename );
    fi;
    if not IsExistingFile( absolute ) then
        return fail;
    fi;
    result := ReadAll( InputTextFile( absolute ) );
    JUPVIZLoadedJavaScriptCache.( filename ) := result;
    return result;
end );


InstallGlobalFunction( JUPVIZFillInJavaScriptTemplate,
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
            Concatenation( String( dictionary.( key ) ), "\n" )
        );
    od;
    return result;
end );


InstallGlobalFunction( JUPVIZRunJavaScriptFromTemplate,
function ( filename, dictionary )
    return RunJavaScript(
        JUPVIZFillInJavaScriptTemplate( filename, dictionary ) );
end );


InstallGlobalFunction( JUPVIZRunJavaScriptUsingRunGAP, function ( jsCode )
    return JUPVIZRunJavaScriptFromTemplate( "using-runGAP",
        rec( runThis := jsCode ) );
end );


InstallGlobalFunction( JUPVIZRunJavaScriptUsingLibraries,
function ( libraries, jsCode )
    local result, library;
    result := jsCode;
    if IsString( libraries ) then
        libraries := [ libraries ];
    fi;
    for library in Reversed( libraries ) do
        result := JUPVIZFillInJavaScriptTemplate( "using-library",
            rec( library := GapToJsonString( library ),
                 runThis := result ) );
    od;
    return JUPVIZRunJavaScriptFromTemplate( "using-runGAP",
        rec( runThis := result ) );
end );


InstallGlobalFunction( CreateVisualization, function ( json, code... )
    local libraries, toolFile;
    libraries := [ "main" ];
    toolFile := Concatenation( "viz-tool-", json.tool );
    if IsExistingFile( JUPVIZAbsoluteJavaScriptFilename( toolFile ) ) then
        Add( libraries, toolFile );
    fi;
    if Length( code ) = 0 then
        code := "";
    else
        code := code[1];
    fi;
    return JUPVIZRunJavaScriptUsingLibraries( libraries,
        JUPVIZFillInJavaScriptTemplate(
            "create-visualization",
            rec( data := GapToJsonString( json ), after := code ) ) );
end );


#E  main.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
