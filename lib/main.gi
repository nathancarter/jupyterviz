############################################################################
##
#W  main.gi              JupyterViz Package                  Nathan Carter
##
##  Installation file for functions of the JupyterViz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##


##  Set the three possible values of PlotDisplayMethod to constants.
BindGlobal( "PlotDisplayMethod_Jupyter", MakeImmutable( "PlotDisplayMethod_Jupyter" ) );
BindGlobal( "PlotDisplayMethod_JupyterSimple", MakeImmutable( "PlotDisplayMethod_JupyterSimple" ) );
BindGlobal( "PlotDisplayMethod_HTML", MakeImmutable( "PlotDisplayMethod_HTML" ) );


##  Detect whether the JupyterKernel package is available.
##  If it is, set our default display mode to using JupyterRenderable objects.
##  Otherwise, we'll use plain HTML.
if IsBoundGlobal( "JupyterRenderable" ) then
    PlotDisplayMethod := PlotDisplayMethod_Jupyter;
else
    PlotDisplayMethod := PlotDisplayMethod_HTML;
fi;


JUPVIZSetUpJupyterRenderable := function ()
    if IsBoundGlobal( "JupyterRenderable" )
       and not IsBoundGlobal( "JUPVIZFileContentsType" ) then
        BindGlobal( "JUPVIZFileContentsType",
            NewType( NewFamily( "JUPVIZFileContentsFamily" ),
                     JUPVIZIsFileContentsRep ) );
        InstallMethod( JUPVIZFileContents, "for a string", [ IsString ],
        function( content )
            return Objectify( ValueGlobal( "JUPVIZFileContentsType" ),
                              rec( content := content ) );
        end );
        InstallMethod( ValueGlobal( "JupyterRender" ),
            [ JUPVIZIsFileContents ],
            function ( fileContents )
                return Objectify( ValueGlobal( "JupyterRenderableType" ),
                    rec( data := rec( text\/plain := fileContents!.content ),
                        metadata := rec( text\/plain := "" ) ) );
            end );
    fi;
end;
JUPVIZSetUpJupyterRenderable();


InstallGlobalFunction( RunJavaScript, function ( script, returnHTML... )
    local html, filename, file;
    if PlotDisplayMethod = PlotDisplayMethod_HTML then
        html := Concatenation(
            "<html>\n",
            "  <body>\n",
            "    <div id='element'></div>\n",
            "  </body>\n",
            "  <script src='https://code.jquery.com/jquery-3.3.1.min.js'\n",
            "    integrity='sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8='\n",
            "    crossorigin='anonymous'>\n",
            "  </script>\n",
            "  <script src='https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.6/require.min.js'>\n",
            "  </script>\n",
            "  <script language='javascript'>\n",
            "    var element = document.getElementById( 'element' );\n",
            "    ", script, "\n",
            "  </script>\n",
            "</html>"
        );
        if Length( returnHTML ) > 0 and returnHTML[1] = true then
            return html;
        fi;
        filename := Filename( DirectoryTemporary(), "visualization.html" );
        file := OutputTextFile( filename, false );
        SetPrintFormattingStatus( file, false );
        PrintTo( file, html );
        CloseStream( file );
        if ARCH_IS_MAC_OS_X() then
            Exec( "open ", filename );
        elif ARCH_IS_WINDOWS() then
            Exec( "start ", filename );
        elif ARCH_IS_UNIX() then
            Exec( "xdg-open ", filename );
        fi;
        return Concatenation( "Displaying result stored in ", filename, "." );
    else
        # Ensure that we have the global variables we need.
        JUPVIZSetUpJupyterRenderable();
        if ( not IsBoundGlobal( "JupyterRenderable" ) ) then
            Error( "The JupyterKernel package is required for this feature." );
        fi;
        # The output element in the notebook will be passed called "element" in
        # the script's environment, which we capture with the closure wrapper
        # below, so that any callbacks or asynchronous code can rely on its having
        # that name indefinitely.
        # We use ValueGlobal to suppress the warning that ensues if you directly
        # use JupyterRenderable as a global variable that is sometimes not
        # defined when this package is loaded.
        return ValueGlobal( "JupyterRenderable" )( rec(
            application\/javascript := Concatenation(
                # use newlines to prevent // comments from harming code
                "( function ( element ) {\n", script,
                "\n} )( element.get( 0 ) )"
            )
        ), rec(
            application\/javascript := ""
        ) );
    fi;
end );


InstallGlobalFunction( JUPVIZAbsoluteJavaScriptFilename,
function ( relativeFilename )
    if not EndsWith( relativeFilename, ".js" ) then
        relativeFilename := Concatenation( relativeFilename, ".js" );
    fi;
    return Filename( DirectoriesPackageLibrary(
        "jupyterviz", "lib/js" )[1], relativeFilename );
end );


BindGlobal( "JUPVIZLoadedJavaScriptCache", rec( ) );
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


InstallGlobalFunction( InstallVisualizationTool,
function ( toolName, script )
    local key;
    key := Concatenation( "viz-tool-", toolName );
    if IsBound( JUPVIZLoadedJavaScriptCache.( key ) ) then
        return false;
    fi;
    JUPVIZLoadedJavaScriptCache.( key ) := script;
    return true;
end );
InstallGlobalFunction( InstallVisualizationToolFromTemplate,
function ( toolName, functionBody, CDNURL... )
    local key, template, record;
    key := Concatenation( "viz-tool-", toolName );
    record := rec( toolName := toolName, functionBody := functionBody );
    if Length( CDNURL ) = 0 then
        template := "template-for-viz-tools-without-cdn";
    else
        template := "template-for-viz-tools-with-cdn";
        record.toolString := GapToJsonString( toolName );
        if EndsWith( CDNURL, ".js" ) then
            CDNURL := CDNURL{[1..Length(CDNURL)-3]};
        fi;
        record.CDNURL := GapToJsonString( CDNURL );
    fi;
    return InstallVisualizationTool( toolName,
        JUPVIZFillInJavaScriptTemplate( template, record ) );
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
function ( filename, dictionary, returnHTML... )
    return CallFuncList( RunJavaScript, Concatenation(
        [ JUPVIZFillInJavaScriptTemplate( filename, dictionary ) ],
        returnHTML ) );
end );


InstallGlobalFunction( JUPVIZRunJavaScriptUsingRunGAP,
function ( jsCode, returnHTML... )
    return CallFuncList( JUPVIZRunJavaScriptFromTemplate,
        Concatenation( [ "using-runGAP", rec( runThis := jsCode ) ],
            returnHTML ) );
end );


InstallGlobalFunction( JUPVIZRunJavaScriptUsingLibraries,
function ( libraries, jsCode, returnHTML... )
    local result, library, libName;
    if IsString( libraries ) then
        libraries := [ libraries ];
    fi;
    if PlotDisplayMethod = PlotDisplayMethod_Jupyter then
        result := jsCode;
        for library in Reversed( libraries ) do
            result := JUPVIZFillInJavaScriptTemplate( "using-library",
                rec( library := GapToJsonString( library ),
                     runThis := result ) );
        od;
        return CallFuncList( JUPVIZRunJavaScriptFromTemplate,
            Concatenation( [ "using-runGAP", rec( runThis := result ) ],
                returnHTML ) );
    else
        result := "if ( !window.JUPVIZLibs ) window.JUPVIZLibs = { };\n";
        for library in libraries do
            libName := GapToJsonString( library );
            result := Concatenation( result,
                "if ( !window.JUPVIZLibs[", libName, "] ) {\n",
                LoadJavaScriptFile( library ), "\n",
                "    window.JUPVIZLibs[", libName, "] = 'loaded';\n",
                "}\n"
            );
        od;
        return CallFuncList( RunJavaScript, Concatenation(
            [ Concatenation( result, jsCode ) ], returnHTML ) );
    fi;
end );


InstallGlobalFunction( CreateVisualization, function ( json, code... )
    local libraries, toolFile;
    libraries := [ "main" ];
    toolFile := Concatenation( "viz-tool-", json.tool );
    if IsExistingFile( JUPVIZAbsoluteJavaScriptFilename( toolFile ) )
    or IsBound( JUPVIZLoadedJavaScriptCache.( toolFile ) ) then
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


InstallGlobalFunction( JUPVIZMakePlotDataSeries, function ( args... )
    # Define a function that we will use to give any usage errors.
    local usageError, isReal;
    usageError := function ()
        Error( Concatenation(
            "The data for a plot can be given in the following ways: ",
            "1. a list of x values and a list of y values. ",
            "2. a list of x values and a function to apply to them. ",
            "3. a list of (x,y) pairs. ",
            "4. a list of y values (with indices used as x values). ",
            "5. a function (small integers will be used for x values)." ) );
    end;
    if Length( args ) = 0 or Length( args ) > 3 then
        usageError();
    fi;
    # We expect the final argument to be an options object.  If it's not
    # present, just fill in a default options object (an empty record) and
    # re-call.
    if not IsRecord( args[Length( args )] ) then
        Add( args, rec() );
        return CallFuncList( JUPVIZMakePlotDataSeries, args );
    fi;
    # Several times below we will want to check whether something is a
    # real number.  We make this function for that purpose.
    isReal := x -> IsInt( x ) or IsRealFloat( x ) or IsRat( x );
    # Now consider each case we support, as documented above in the usage
    # error function.
    #
    # 1. a list of x values and a list of y values
    # The xs can be any values but the ys must be numbers.
    #
    # This is the situation in which we can just easily store the data in
    # a record and be done.  It is already in the form we want it to be.
    if Length( args ) = 3 and IsList( args[2] )
                          and ForAll( args[2], isReal ) then
        return rec(
            x := args[1],
            y := args[2],
            options := args[3]
        );
    fi;
    #
    # 2. a list of x values and a function to apply to them.
    #
    # We just apply the function to the x values and recur.
    # This then becomes an instance of case 1.
    if Length( args ) = 3 and IsFunction( args[2] ) then
        return JUPVIZMakePlotDataSeries(
            args[1], List( args[1], args[2] ), args[3] );
    fi;
    #
    # 3. a list of (x,y) pairs.
    #
    # We just unzip them into x and y lists separately and recur.
    # This then becomes an instance of case 1.
    if Length( args ) = 2 and IsList( args[1] ) and
       ForAll( args[1], x -> IsList(x) and Length(x) = 2 ) then
        return JUPVIZMakePlotDataSeries(
            List( args[1], L -> L[1] ),
            List( args[1], L -> L[2] ),
            args[2]
        );
    fi;
    #
    # 4. a list of y values (with indices used as x values).
    #
    # It is easy in GAP to construct the list of indices into a given list.
    # This then becomes an instance of case 1.
    if Length( args ) = 2 and IsList( args[1] )
                          and ForAll( args[1], isReal ) then
        return JUPVIZMakePlotDataSeries(
            [ 1 .. Length( args[1] ) ], args[1], args[2] );
    fi;
    #
    # 5. a function (small integers will be used for x values).
    #
    # We simply fill in the first few small integers and recur, letting this
    # degenerate to case 2.
    if Length( args ) = 2 and IsFunction( args[1] ) then
        return JUPVIZMakePlotDataSeries( [1,2,3,4,5], args[1], args[2] );
    fi;
    #
    # If none of those things happened, it's a usage error.
    usageError();
end );


InstallGlobalFunction( JUPVIZRecordKeychainLookup,
function ( record, keychain, default )
    if not IsList( keychain ) then return fail; fi;
    if Length( keychain ) = 0 then return record; fi;
    if not IsRecord( record ) then return default; fi;
    if not IsBound( record.( keychain[1] ) ) then return default; fi;
    return JUPVIZRecordKeychainLookup( record.( keychain[1] ),
        keychain{[2..Length(keychain)]}, default );
end );


InstallGlobalFunction( JUPVIZRecordsKeychainLookup,
function ( records, keychain, default )
    local record, attempt;
    for record in records do
        attempt := JUPVIZRecordKeychainLookup( record, keychain, default );
        if not ( attempt = default ) then return attempt; fi;
    od;
    return default;
end );


InstallGlobalFunction( JUPVIZFetchWithDefault,
function ( record, others, chain, default, action )
    if IsString( chain ) then chain := [ chain ]; fi;
    action( JUPVIZRecordKeychainLookup( record, chain,
        JUPVIZRecordsKeychainLookup( others, chain, default ) ) );
end );


InstallGlobalFunction( JUPVIZFetchIfPresent,
function ( record, others, chain, action )
    local result;
    if IsString( chain ) then chain := [ chain ]; fi;
    result := JUPVIZRecordKeychainLookup( record, chain,
        JUPVIZRecordsKeychainLookup( others, chain, fail ) );
    if not ( result = fail ) then action( result ); fi;
end );


BindGlobal( "ConvertDataSeriesForTool", rec() );


ConvertDataSeriesForTool.plotly := function ( series )
    local result;
    result := rec( data := StructuralCopy( series ) );
    Perform( result.data, function ( s )
        JUPVIZFetchWithDefault( s, series, [ "options", "type" ], "line",
            function ( t ) s.type := t; end );
        JUPVIZFetchIfPresent( s.options, [], "name",
            function ( n ) s.name := n; end );
    end );
    JUPVIZFetchWithDefault( 0, series, [ "options", "type" ], "line",
        function ( t )
            if t = "pie" then
                Perform( result.data, function ( s )
                    s.labels := s.x;
                    s.values := s.y;
                    Unbind( s.x );
                    Unbind( s.y );
                end );
            fi;
        end );
    JUPVIZFetchWithDefault( 0, series, [ "options", "height" ], 400,
        function ( h ) result.layout := rec( height := h ); end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "width" ],
        function ( w ) result.layout.width := w; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "title" ],
        function ( t ) result.layout.title := t; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "xaxis" ],
        function ( x ) result.layout.xaxis := rec( title := x ); end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "yaxis" ],
        function ( y ) result.layout.yaxis := rec( title := y ); end );
    Perform( result.data, function ( s ) Unbind( s.options ); end );
    return result;
end;


ConvertDataSeriesForTool.chartjs := function ( series )
    local result;
    Perform( series, function ( s )
        if not ( s.x = series[1].x ) then
            Error( Concatenation(
                "Multiple arrays of x values ",
                "not supported yet in ChartJS." ) );
        fi;
    end );
    result := rec(
        data := rec(
            labels := StructuralCopy( series[1].x ),
            datasets := [ ]
        )
    );
    Perform( series, function ( s )
        local next;
        next := rec( data := s.y );
        JUPVIZFetchIfPresent( s, [], [ "options", "name" ],
            function ( n ) next.name := n; end );
        JUPVIZFetchIfPresent( next, [], [ "name" ],
            function ( n ) next.label := n; Unbind( next.name ); end );
        Add( result.data.datasets, next );
    end );
    JUPVIZFetchWithDefault( 0, series, [ "options", "type" ], "line",
        function ( t ) result.type := t; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "width" ],
        function ( w ) result.width := w; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "height" ],
        function ( h ) result.height := h; end );
    result.options := rec();
    JUPVIZFetchIfPresent( 0, series, [ "options", "xaxis" ],
        function ( x )
            result.options.scales := rec(
                xAxes := [
                    rec(
                        scaleLabel := rec(
                            labelString := x,
                            display := true
                        )
                    )
                ]
            );
        end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "yaxis" ],
        function ( y )
            if not IsBound( result.options.scales ) then
                result.options.scales := rec();
            fi;
            result.options.scales.yAxes := [
                rec(
                    scaleLabel := rec(
                        labelString := y,
                        display := true
                    )
                )
            ];
        end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "title" ],
        function ( t )
            result.options.title := rec(
                display := true,
                text := t
            );
        end );
    return result;
end;


ConvertDataSeriesForTool.canvasjs := function ( series )
    local result;
    result := rec( data := [ ] );
    Perform( series, function ( s )
        local next;
        next := rec(
            dataPoints := List(
                [ 1 .. Length( s.x ) ],
                i -> rec( x := s.x[i], y := s.y[i] )
            )
        );
        JUPVIZFetchWithDefault( s, series, [ "options", "type" ], "line",
            function ( t ) next.type := t; end );
        JUPVIZFetchIfPresent( s.options, [], [ "name" ],
            function ( n )
                next.legendText := n;
                next.showInLegend := true;
            end );
        Add( result.data, next );
    end );
    JUPVIZFetchWithDefault( 0, series, [ "options", "height" ], 400,
        function ( h ) result.height := h; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "width" ],
        function ( w ) result.width := w; end );
    JUPVIZFetchWithDefault( 0, series, [ "options", "animationEnabled" ],
        true, function ( e ) result.animationEnabled := e; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "theme" ],
        function ( t ) result.theme := t; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "xaxis" ],
        function ( x ) result.axisX := rec( title := x ); end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "yaxis" ],
        function ( y ) result.axisY := rec( title := y ); end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "title" ],
        function ( t ) result.title := rec( text := t ); end );
    return result;
end;


ConvertDataSeriesForTool.anychart := function ( series )
    local result, i, s;
    result := rec(
        chart := rec(
            series := [ ],
            legend := rec( position := "top" )
        )
    );
    Perform( series, function ( s )
        local next;
        next := rec(
            data := List(
                [ 1 .. Length( s.x ) ],
                i -> rec( x := s.x[i], value := s.y[i] )
            )
        );
        JUPVIZFetchWithDefault( s, series, [ "options", "type" ], "line",
            function ( t ) next.seriesType := t; end );
        JUPVIZFetchIfPresent( s, [], [ "options", "name" ],
            function ( n ) next.name := n; end );
        Add( result.chart.series, next );
    end );
    JUPVIZFetchWithDefault( 0, series, [ "options", "type" ], "line",
        function ( t ) result.chart.type := t; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "width" ],
        function ( w ) result.width := w; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "height" ],
        function ( h ) result.height := h; end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "xaxis" ],
        function ( x )
            result.chart.xAxes := [
                rec(
                    orientation := "bottom",
                    title := rec( text := x )
                )
            ];
        end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "yaxis" ],
        function ( y )
            result.chart.yAxes := [
                rec(
                    orientation := "left",
                    title := rec( text := y )
                )
            ];
        end );
    JUPVIZFetchIfPresent( 0, series, [ "options", "title" ],
        function ( t ) result.chart.title := t; end );
    return result;
end;


InstallGlobalFunction( JUPVIZPlotDataSeriesList, function ( series... )
    local result;
    JUPVIZFetchWithDefault( 0, series, [ "options", "tool" ], "plotly",
        function ( tool )
            if not IsBound( ConvertDataSeriesForTool.( tool ) ) then
                Error( Concatenation(
                    "Not a known plot visualization tool: ", tool ) );
            fi;
            result := CreateVisualization( rec(
                tool := tool,
                data := ConvertDataSeriesForTool.( tool )( series )
            ), "" );
        end );
    return result;
end );


InstallGlobalFunction( Plot, function ( args... )
    if Length( args ) = 0 then
        Error( "Plot requires at least one argument." );
    fi;
    # If the last argument is a record, we assume it's an options object,
    # and thus Plot was called with the same arguments as we should pass to
    # JUPVIZMakePlotDataSeries.  If the last argument is a function, we assume
    # it's to be applied to the first argument, and thus again, we pass the
    # arguments directly on to JUPVIZMakePlotDataSeries.
    if IsRecord( args[Length( args )] ) or
       IsFunction( args[Length( args )] ) then
        return JUPVIZPlotDataSeriesList(
            CallFuncList( JUPVIZMakePlotDataSeries, args ) );
    fi;
    # At this point, we know we have either been called as
    # Plot(xList,yList), as Plot(xyList), as Plot(yList), or
    # Plot(argset1,argset2,...).  In all cases, all args are lists.
    # Verify that and signal an error if it's not so.
    if not ForAll( args, x -> IsList( x ) ) then
        Error( "Invalid argument types given to Plot." );
    fi;
    # If there's just one argument and it's a list of pairs, we assume we
    # are in the Plot(xyList) case, which means just pass that directly to
    # JUPVIZMakePlotDataSeries.
    if Length( args ) = 1 and
       ForAll( args[1], x -> IsList( x ) and Length( x ) = 2 ) then
        return JUPVIZPlotDataSeriesList(
            CallFuncList( JUPVIZMakePlotDataSeries, args ) );
    fi;
    # If there's just one argument and it's a list of numbers, we assume we
    # are in the Plot(yList) case, which means just pass that directly to
    # JUPVIZMakePlotDataSeries.
    if Length( args ) = 1 and ForAll( args[1],
           x -> IsInt( x ) or IsRealFloat( x ) or IsRat( x ) ) then
        return JUPVIZPlotDataSeriesList(
            CallFuncList( JUPVIZMakePlotDataSeries, args ) );
    fi;
    # Before doing the comparison further below, we verify that args[1][1]
    # isn't an error.  If it is, they're passing empty lists, which is not
    # sensible for Plot().
    if Length( args[1] ) = 0 then
        Error( "Empty list passed as first argument to Plot." );
    fi;
    # To distinguish the Plot(xs,ys) case from the
    # Plot(argset1,argset2,...) case, we see if the first argument is a
    # list of lists.  If not, it's the first case, which we can pass
    # directly on to JUPVIZMakePlotDataSeries.
    if Length( args ) = 2 and
       ( not IsList( args[1][1] ) or IsString( args[1][1] ) ) and
       not IsFunction( args[1][1] ) then
        return JUPVIZPlotDataSeriesList(
            CallFuncList( JUPVIZMakePlotDataSeries, args ) );
    fi;
    # The only case remaining is the Plot(argset1,argset2,...) case, which
    # means we must iterate over all the arguments, call JUPVIZMakePlotDataSeries
    # on each, and pile them all into an array.
    return CallFuncList( JUPVIZPlotDataSeriesList,
        List( args, x -> CallFuncList( JUPVIZMakePlotDataSeries, x ) ) );
end );


BindGlobal( "ConvertGraphForTool", rec() );


ConvertGraphForTool.cytoscape := function ( graph )
    local result, edgestyle;
    result := rec(
        elements := [ ],
        layout := rec(),
        style := [
            rec(
                selector := "node",
                style := rec( content := "data(id)" )
            )
        ]
    );
    JUPVIZFetchWithDefault( graph, [], [ "options", "layout" ], "cose",
        function ( lname ) result.layout.name := lname; end );
    JUPVIZFetchIfPresent( graph, [], [ "options", "vertexwidth" ],
        function ( w ) result.style[1].style.width := w; end );
    JUPVIZFetchIfPresent( graph, [], [ "options", "vertexheight" ],
        function ( h ) result.style[1].style.height := h; end );
    JUPVIZFetchIfPresent( graph, [], [ "options", "vertexcolor" ],
        function ( c ) result.style[1].style.( "background-color" ) := c;
        end );
    edgestyle := rec();
    JUPVIZFetchIfPresent( graph, [], [ "options", "edgewidth" ],
        function ( w ) edgestyle.width := w; end );
    JUPVIZFetchIfPresent( graph, [], [ "options", "edgecolor" ],
        function ( c ) edgestyle.( "line-color" ) := c; end );
    JUPVIZFetchWithDefault( graph, [], [ "options", "directed" ], false,
        function ( directed )
            if directed then
                edgestyle.( "mid-target-arrow-shape" ) := "vee";
                JUPVIZFetchIfPresent( graph, [], [ "options", "edgecolor" ],
                    function ( c )
                        edgestyle.( "mid-target-arrow-color" ) := c;
                    end );
                JUPVIZFetchIfPresent( graph, [],
                    [ "options", "arrowscale" ],
                    function ( s ) edgestyle.( "arrow-scale" ) := s; end );
            fi;
        end );
    if Length( RecNames( edgestyle ) ) > 0 then
        Add( result.style, rec( selector := "edge", style := edgestyle ) );
    fi;
    Perform( graph.vertices, function ( v )
        local vertex;
        if IsRecord( v ) and IsBound( v.name ) and
           IsBound( v.x ) and IsBound( v.y ) then
            vertex := rec(
                data := rec( id := v.name ),
                position := rec( x := v.x, y := v.y )
            );
        else
            vertex := rec( data := rec( id := PrintString( v ) ) );
        fi;
        Add( result.elements, vertex );
    end );
    Perform( graph.edges, function ( e )
        Add( result.elements,
            rec(
                data := rec(
                    source := PrintString( e[1] ),
                    target := PrintString( e[2] )
                )
            )
        );
    end );
    return result;
end;


InstallGlobalFunction( JUPVIZMakePlotGraphRecord, function ( args... )
    local vertices, edges, i, j;
    # Ensure we were passed some arguments
    if Length( args ) = 0 then
        Error( "PlotGraph requires at least one argument." );
    fi;
    # Ensure there's an options object at the end
    if not IsRecord( args[Length( args )] ) then
        Add( args, rec() );
        return CallFuncList( JUPVIZMakePlotGraphRecord, args );
    fi;
    # If we're just given an adjacency matrix, convert that to vertices and
    # edges.  All positive entries in the matrix count as forming an edge.
    # Then recur using the vertex and edge sets.
    if Length( args ) = 2 and IsMatrix( args[1] ) and
       IsRectangularTable( args[1] ) and
       Length( args[1] ) = Length( args[1][1] ) then
        vertices := [ 1..Length( args[1] ) ];
        edges := [ ];
        for i in vertices do
            for j in vertices do
                if args[1][i,j] > 0 then Add( edges, [i,j] ); fi;
            od;
        od;
        return JUPVIZMakePlotGraphRecord( vertices, edges, args[2] );
    fi;
    # If we're just given edges, compute a vertex set from that, then recur
    # with both pieces of data.
    if Length( args ) = 2 and IsList( args[1] ) and Length( args[1] ) > 0
       and ForAll( args[1], x -> IsList( x ) and Length( x ) = 2 ) then
        vertices := [ ];
        Perform( args[1], function ( e )
            if not ( e[1] in vertices ) then Add( vertices, e[1] ); fi;
            if not ( e[2] in vertices ) then Add( vertices, e[2] ); fi;
        end );
        return JUPVIZMakePlotGraphRecord( vertices, args[1], args[2] );
    fi;
    # If we were given something other than three arguments, something is
    # wrong.
    if Length( args ) > 3 then
        Error( "Too many arguments given to PlotGraph." );
    fi;
    # If the second argument is a function, then use it to compute the set
    # of edges, and then recur with that data.
    if IsFunction( args[2] ) then
        edges := [ ];
        for i in args[1] do
            for j in args[1] do
                if args[2]( i, j ) then Add( edges, [i,j] ); fi;
            od;
        od;
        return JUPVIZMakePlotGraphRecord( args[1], edges, args[3] );
    fi;
    # The only case remaining should be the vertices and edges case. Verify.
    if not ForAll( args[2], x -> IsList( x ) and Length( x ) = 2 ) then
        Error( Concatenation(
            "Invalid edges list for PlotGraph.  ",
            "It must be a list of two-element lists." ) );
    fi;
    # We create a data structure of vertices, edges, and options.
    # Various conversion functions will make this suitable for each
    # visualization tool.
    return rec(
        vertices := args[1],
        edges := args[2],
        options := args[3]
    );
end );


InstallGlobalFunction( PlotGraph, function ( args... )
    local result, options, tool;
    options := args[Length( args )];
    if not IsRecord( options ) then options := rec(); fi;
    result := CallFuncList( JUPVIZMakePlotGraphRecord, args );
    JUPVIZFetchWithDefault( options, [], [ "tool" ], "cytoscape",
        function ( tool )
            if not IsBound( ConvertGraphForTool.( tool ) ) then
                Error( Concatenation(
                    "Not a known graph visualization tool: ", tool ) );
            fi;
            result := rec(
                tool := tool,
                data := ConvertGraphForTool.( tool )( result )
            );
            JUPVIZFetchWithDefault( options, [], [ "height" ], 400,
                function ( h ) result.height := h; end );
            JUPVIZFetchIfPresent( options, [], [ "width" ],
                function ( w ) result.width := w; end );
            result := CreateVisualization( result, "" );
        end );
    return result;
end );


#E  main.gi  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
